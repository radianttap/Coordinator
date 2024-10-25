[Coordinator](../README.md) : the [Pattern](Pattern.md) · the [Library](Library.md) · the [Class](Class.md) · recommended **Implementation**

## Recommended implementation

Since iOS 13, Apple strongly encourages iOS apps using scene-based structure and behavior. Any scene (window) can be created/terminated at any moment. Thus the only object in the app that will live as long as the app is alive is `AppDelegate` which will spawn a scene, when needed. Each scene should have at least one Coordinator instance, let’s call it `SceneCoordinator`.

Thus the only place to keep app-wide dependencies is `AppDelegate`.
There can be way too many of these dependencies to shuffle around thus it’s good idea to create a singular container for all of them:

### AppDependency

A very simple conduit to keep all your non-UI dependencies in one struct, automatically accessible to any Coordinator, at any level. 

```swift
struct AppDependency {
	var webService: WebService?
	var dataManager: DataManager?
	var accountManager: AccountManager?
	var contentManager: ContentManager?

	//	Init

	init(
		webService: WebService? = nil,
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

### AppDelegate

As said before, instances of app-wide dependencies should then be kept here.

```
final class AppDelegate: UIResponder, UIApplicationDelegate {
	var webService: WebService(...)
	var dataManager: DataManager(...)
	...
	

	var appDependency: AppDependency? {
		didSet {
			updateSceneDependencies()
		}
	}
	
	func updateSceneDependencies() {...}
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		//	instantiate all services and middleware
		//	build and set AppDependency
		rebuildDependencies()

		return true
	}
```

Method `rebuildDependencies()` simply (re)creates AppDependency struct with whatever is currently available and assigns it to the said property.

### Pass dependencies from AppDelegate to scenes

The following method is the only place where we can pass these dependencies down to `UISceneSession` (and thus to `UIScene`):

```swift
func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

	connectingSceneSession.appDependency = appDependency
	return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
}
```

For this to work, we need inject appDependency property into UISceneSession:

```swift
extension UISceneSession {
	@MainActor
	private struct AssociatedKeys {
		static var appDependency: Void?
	}
	
	var appDependency: AppDependency? {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.appDependency) as? AppDependency
		}
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.appDependency, newValue, .OBJC_ASSOCIATION_COPY)
			sceneCoordinator?.appDependency = newValue
		}
	}
}
```

And now this method in `AppDelegate` would work as well.

```swift
func updateSceneDependencies() {
	let application = UIApplication.shared
	
	application.openSessions.forEach {
		$0.appDependency = appDependency
	}
}

```

### SceneCoordinator

Here’s a typical Coordinator that uses `UINavigationController` as its root VC:

```swift
@MainActor
final class SceneCoordinator: NavigationCoordinator, NeedsDependency {
	private weak var scene: UIScene!
	private weak var sceneDelegate: SceneDelegate!
	
	init(scene: UIScene,
		 sceneDelegate: SceneDelegate,
		 appBundleIdentifier: String? = nil)
	{
		self.scene = scene
		self.sceneDelegate = sceneDelegate
		
		let vc = NavigationController()
		super.init(rootViewController: vc)
		
		appDependency = scene.session.appDependency
	}
	
	override var coordinatingResponder: UIResponder? {
		return sceneDelegate
	}
```

`SceneCoordinator` takes over management of `window`’s `rootViewController` continues the `coordinatingResponder` chain from here to `SceneDelegate`.

### SceneDelegate

Now we can instantiate our `SceneCoordinator` and pass-on the supplied `AppDependency` from the scene’s session.

```
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?
	private(set) var coordinator: SceneCoordinator?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		
		let window = UIWindow(windowScene: windowScene)
		self.window = window
		
		let sceneCoordinator = SceneCoordinator(scene: scene, sceneDelegate: self)
		self.coordinator = sceneCoordinator

		window.rootViewController = sceneCoordinator.rootViewController

		window.makeKeyAndVisible()
		sceneCoordinator.start()
	}
	
	override var coordinatingResponder: UIResponder? {
		window
	}
}
```

`SceneDelegate` also concludes the coordinatingResponder’s upward chain.

### Declarative routing

Use an enum called `Page` inside `ApplicationCoordinator` to declare natural full UI screens of the app.

Each specific screen will be UIVC instance. Each case can have zero or more associated values, which are public arguments / parameters for the screen.

```swift
enum Page {
	case login
	case createAccount
	case confirmAccount(code: String?)
	case profile(user: User)
	...
}
```

Now you simply need one global method to switch to any screen in the app:

```swift
extension UIResponder {
	@objc func globalDisplay(page: PageBox, sender: Any? = nil) {
		coordinatingResponder?.globalDisplay(page: page, sender: sender)
	}
}
```

Override this method anywhere in the coordinatingResponder chain to do what is needed. In this case, usually at any Coordinator to push related UIVC instance.

We need `PageBox` wrapper since the method arguments must be ObjC-friendly. This is super easy to do, giving us wrap and unwrap:

```swift
final class PageBox: NSObject {
	let unbox: Page
	init(_ value: Page) {
		self.unbox = value
	}
}
extension Page {
	var boxed: PageBox { return PageBox(self) }
}
```

This is also easy to script with tools like [Sourcery](https://github.com/krzysztofzablocki/Sourcery/).

### Naming your coordinatingResponder methods

I use consistent naming scheme to group my coordinatingResponder methods. Anything that affects entire app is prefixed with `global` like `globalDisplay(page:sender:)` method above.

All stuff dealing with shopping cart can use `cart` prefix. Same with account, catalog etc. Xcode’s autocomplete then helps to filter possible options when coding.

(Sometimes a little consistency and common sense is enough.)

