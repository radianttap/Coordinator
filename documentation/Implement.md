[Coordinator](../README.md) : the [Pattern](Pattern.md) · the [Library](Library.md) · the [Class](Class.md) · recommended **Implementation**

## Recommended implementation

Create one instance of `ApplicationCoordinator`, which is main entry point into the app. It’s created and strongly referenced by the AppDelegate. 

```swift
final class AppDelegate: ... {
	var window: UIWindow?
	var applicationCoordinator: ApplicationCoordinator!

	func application(_ application: UIApplication,
					 willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
	{
		window = UIWindow(frame: UIScreen.main.bounds)

		applicationCoordinator = {
			let nc = UINavigationController()
			let c = ApplicationCoordinator(rootViewController: nc)
			return c
		}()
		window?.rootViewController = applicationCoordinator.rootViewController

		return true
	}

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
	{
		window?.makeKeyAndVisible()
		applicationCoordinator.start()
		return true
	}
```

This Coordinator then spawns any other Coordinators you need, when you need them. AppCoordinator is the only one that’s always in memory.

### Declarative routing

Use an enum called `Section` inside `ApplicationCoordinator` to declare natural UI parts of the app: _Content_, _Account_, _Payment_, _Order_, _Cart_ etc. Each case will correspond to (content) Coordinator instance.

Each specific screen will be UIVC instance. Model them with another enum called `Page`, inside each of the content Coordinators. Each case can have zero or more associated values, which are public arguments / parameters for the screen.

```swift
final class ApplicationCoordinator: ... {
	enum Section {
	  case content(page: ContentCoordinator.Page?)
	  case account(page: AccountCoordinator.Page?)
	  case payment(page: PaymentCoordinator.Page?)
	}
	var section: Section = .content(page: nil)
}

...

final class AccountCoordinator: ... {
	enum Page {
		case login
		case createAccount
		case confirmAccount(code: String?)
		case profile(user: User)
		...
	}
	var page: Page = .login
}

```

Now, when Coordinator is started, it will process the `section` or `page` property and setup display of appropriate UI.

### Data and Middleware instances

`ApplicationCoordinator` is the crown, the top of your app stack. Hence it is the natural place to keep instances to all the non-UI objects (which are most likely various singletons).

Things like: `DataManager`, `DataImporter`, `WebService`, `AccountManager`, `PaymentManager` etc.

```swift
final class ApplicationCoordinator: ... {
	private lazy var webService: WebService = WebService()
	private lazy var dataManager: DataManager = DataManager(service: webService)
	private lazy var accountManager: AccountManager = AccountManager(dataManager: dataManager)
	private lazy var contentManager: ContentManager = ContentManager(dataManager: dataManager)
	...
}
```

### AppDependency

A very simple conduit to keep all your non-UI dependencies in one struct, automatically accessible to any Coordinator, at any level. 

```swift
struct AppDependency {
	var webService: WebService?
	var dataManager: DataManager?
	var accountManager: AccountManager?
	var contentManager: ContentManager?

	//	Init

	init(webService: WebService? = nil,
		 dataManager: DataManager? = nil,
		 accountManager: AccountManager? = nil,
		 contentManager: ContentManager? = nil)
	{
		self.webService = webService
		self.dataManager = dataManager
		self.accountManager = accountManager
		self.contentManager = contentManager
	}
}
```

Every time `appDependency` is updated on any Coordinator, it must pass the new value to all its child Coordinators.

```swift
final class ContentCoordinator: NavigationCoordinator {
	var appDependency: AppDependency? {
		didSet { 
			updateChildCoordinatorDependencies()
		}
	}

```

This way, Coordinators can fulfill their promise to be *routing mechanism* between any UIVC and any back-end object.

#### Message queueing

Some dependencies can take a while to setup, things like Core Data stack. Thus you may end up in situation where your UI is shown before DataManager or middleware is ready to respond.

You can queue the received coordinatingResponder method call: 

```swift
override func contentFetchPromotedProducts(sender: Any?, completion: @escaping ([Product], Error?) -> Void) {
	guard let manager = dependencies?.catalogManager else {
		enqueueMessage {
			[weak self] in self?.fetchPromotedProducts(sender: sender, completion: completion)
		}
		return
	}
	manager.promotedProducts(callback: completion)
}
```

...and wait until dependency is updated; then try again:

```swift
var dependencies: AppDependency? {
	didSet {
		updateChildCoordinatorDependencies()
		processQueuedMessages()
	}
}
```

### Naming your coordinatingResponder methods

I use consistent naming scheme to group my UIResponder extension methods. All stuff dealing with shopping cart use `cart` prefix. Same with account, catalog etc. Xcode’s autocomplete then helps to filter possible options when coding.

(Sometimes a little consistency and common sense is enough.)

