[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# Coordinator

Implementation of _Coordinator_ design pattern. It is *the* application architecture pattern for iOS, carefully designed to fit into UIKit; so much it could easily be `UICoordinator`.

Since this is *core architectural pattern*, it’s not possible to explain its usage with one or two clever lines of code. Give it a day or two; analyze and play around with the demo example. I’m pretty sure you’ll find it worthy of your time and future projects.


## Installation

### Manually 

My preferred method is to integrate Coordinator into the project manually. Just drag `Coordinator` folder into your project — it‘s only four files.

If you prefer to use dependency managers, see below. 
Releases are tagged with [Semantic Versioning](https://semver.org) in mind.

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Coordinator into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'Coordinator', 	:git => 'https://github.com/radianttap/Coordinator.git'
```

You must use direct link through `:git` since CocoaPods central repository contains a framework of the same name.[^1]

Look into `Example-CocoaPods` folder for an example app using CocoaPods as dependency manager.

### Setting up with Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Coordinator into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "radianttap/Coordinator"
```

`Coordinator.xcodeproj` in the root is using Carthage for the example app and is also housing the framework itself. 

## Coordinator: the pattern 
(and why you need to use it)

[`UIViewController`](https://developer.apple.com/documentation/uikit/uiviewcontroller), in essence, is very straight-forward implementation of MVC pattern: it is mediator between data model / data source of any kind and one `UIView`. It has two roles:

- receives the _data_ and configure / deliver it to the `view`
- respond to actions and events that occurred in the view
- route that response back into data storage or into some other UIViewController instance

No, I did not make off-by-one error. The 3rd item should not be there but it is in the form of [show](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621377-show), [showDetailViewController](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621432-showdetailviewcontroller), [performSegue](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621413-performsegue), [present](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621380-present) & [dismiss](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621505-dismiss), [navigationController](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621860-navigationcontroller), [tabBarController](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621169-tabbarcontroller) etc. Those methods and properties should never be found inside your UIViewController code.

> UIViewController instance should *not care* nor it should *know* about any other instance of UIVC or anything else.

It should only care about its input (data) and output (events and actions). 
It does not care who/what sent that input. It does not care who/what handles its output.

**Coordinator** is an object which 

* instantiates UIVCs
* feeds the input into them
* receives the output from them

It order to do so, it also:

* keeps references to any data sources in the app
* implements data and UI _flows_ it is responsible for
* manages UI screens related to those flows (one screen == one UIVC)

#### Example

Login flow that some AccountCoordinator may implement:

1. create an instance of LoginViewController and display it
2. receive username/password from LoginViewController
3. send them to AccountManager
4. If AccountManager returns an error, deliver that error back to LoginViewController
5. If AccountManager returns a User instance, replace LoginViewController with UserProfileViewController

In this scenario, LoginVC does not know that AccountManager exists nor it ever references it. It also does not know that AccountCoordinator nor UserProfileVC exist.

How can that be possible? Read on.

## Coordinator: the library

In my library, Coordinator instance is essentially defined by these two points:

· **1** · It always has one instance of UIViewController which is its *root ViewController*. This is usually some container controller like `UINavigationController` but it can be any subclass.

This way, it can internally create instances of UIVC, populate their input with data it needs and then just _show_ or _present_ them as needed. By reusing these essential UIKit mechanisms it minimally interferes with how iOS already works. 

Coordinator takes care of navigation and routing while View Controller takes care of UI controls, touches and their corresponding events.

· **2** · It subclasses `UIResponder`, same as `UIView` and `UIViewController` do.

This is crucial. My library [extends UIResponder](https://github.com/radianttap/Coordinator/blob/master/Coordinator/UIKit-CoordinatingExtensions.swift) by giving  it a new property called `coordinatingResponder`. This means that if you define a method like this:

```swift
extension UIResponder {

@objc dynamic func accountLogin(username: String,
        password: String,
        onQueue queue: OperationQueue? = nil,
        sender: Any?,
        callback: @escaping (User?, Error?) -> Void)
{
    coordinatingResponder?.accountLogin(username: username,
        password: password,
        onQueue: queue,
        sender: sender,
        callback: callback)
}

}
```

you can

* Call `accountLogin()` from *anywhere*: view controller, view, button's event handler, table/collection view cell, UIAlertAction etc.
* That call will be passed *up* the responder chain until it reaches some Coordinator instance which overrides that method. It none does, it gets to UIApplicationDelegate (which is the top UI point your app is given by iOS runtime) and nothing happens.
* Through the `callback` closure, Coordinator can then pass the results back *down* the chain.
* At any point in this chain you can override this method, do whatever you want and continue the chain (or not, as you need)

There is no need for Delegate pattern (although nothing stops you from using one). No other pattern is required, ever. 

By reusing the essential component of UIKit design — the responder chain — UIViewController's output can travel up *and* down the…

### CoordinatingResponder chain

This is all that’s required for the chain to work:

```swift
public extension UIResponder {
	@objc public var coordinatingResponder: UIResponder? {
		return next
	}
}
```

That bit covers all the `UIView` subclasses: all the cells, buttons and other controls.

Then on `UIViewController` level, this is specialized further:

```swift
extension UIViewController {
	override open var coordinatingResponder: UIResponder? {
		guard let parentCoordinator = self.parentCoordinator else {
			guard let parentController = self.parent else {
				guard let presentingController = self.presentingViewController else {
					return view.superview
				}
				return presentingController as UIResponder
			}
			return parentController as UIResponder
		}
		return parentCoordinator as? UIResponder
	}
}

```

Once responder chain moves into UIViewController instances, it stays there regardless of how the UIVC was displayed on screen: pushed or presented or embedded, it does not matter.

Once it reaches the Coordinator’s `rootViewController` then the method call is passed to the `parentCoordinator` of that root VC. 

```swift
extension UIViewController {
	public weak var parentCoordinator: Coordinating? {
		get { ... }
		set { ... }
	}
}
```

So this is how the chain is closed up. Which brings us to the…

### Coordinator: the class

`Coordinator` class is parameterized with UIViewController subclass it uses as root. (`Coordinating` protocol exists mainly to avoid issues with generic classes and collections.)

```swift
open class Coordinator<T: UIViewController>: UIResponder, Coordinating {
	public init(rootViewController: T?) { ... }
	
	open override var coordinatingResponder: UIResponder? {
		return parent as? UIResponder
	}
}
```

Since apps can be fairly complex, each Coordinator can have an unlimited number of child Coordinators. So you can have AccountCoordinator, PaymentCoordinator, CartCoordinator, CatalogCoordinator and so on. There are no rule nor guidelines: group your related app screens under particular Coordinator umbrella as you see fit.

When you instantiate a Coordinator instance, you call `start()` to use it and `stop()` when it’s no longer needed.

In the Coordinator subclass, you’ll override the method you defined in the UIResponder extension and actually do something useful instead of just calling the same method on next `coordinatingResponder`.

## Demo example

The best explanation for any architecture is demo app, which I built.

Example app mimics a shopping app. It has a fairly complete implementation of the [Layers architecture](http://aplus.rs/tags/layers/) where Coordinator is one of the central elements.

Look into `AppDelegate` where you can see that each app must have an instance of `AppCoordinator`, which is main entry point into the app. It’s created and strongly referenced by the AppDelegate. 

This Coordinator then spawns any other Coordinators you need, when you need them. AppCoordinator is the only one that’s always in memory.

## Advanced features & tips

See in the demo how I use `Section` and `Page` enums to declare parts and screens of the app and thus hide internal implementation of each Coordinator from the rest of the app.

Section == one Coordinator instance, one semantic part of the app (my account, catalog, payment etc)

Page == one screen inside a particular Coordinator. Each page corresponds to one UIViewController.

### NavigationCoordinator

This is the only concrete subclass my library offers and I encourage you to subclass it for your own needs. It uses `UINavigationController` as root VC. 

Entire app in the demo uses just one instance of UINC which is shared among all Coordinators.

### AppDependency

A very simple conduit to keep all your low-level (non-UI) singletons in one struct, automatically accessible to any Coordinator, at any level, through adoption of `NeedsDependency` protocol.

#### Message queueing

Some dependencies can take a while to setup, things like Core Data stack. Thus you may end up in situation where your UI is shown before DataManager or middleware is ready to respond.

You can queue the received coordinatingResponder method call: 

```swift
override func fetchPromotedProducts(sender: Any?, completion: @escaping ([Product], Error?) -> Void) {
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

See `CatalogCoordinator` in the demo, `fetchPromotedProducts()` method for an example.

### Naming your coordinatingResponder methods

I use consistent naming scheme to group my UIResponder extension methods. All stuff dealing with shopping cart use `cart` prefix. Same with account, catalog etc. Xcode’s autocomplete then helps to filter possible options when coding.

(Sometimes a little consistency and common sense is enough.)

### OperationQueue

Note the use of `OperationQueue.perform` static method. 

Since UIKit mandates usage on main thread only, this allows you to suggest to the eventual action responder that it should execute `callback()` on the given `queue`. 

If no queue is specified, it’s executed on the current queue.

## Further reading

On my blog: [Coordinator: the missing pattern in UIKit](http://aplus.rs/2018/coordinator-missing-pattern-uikit/)

Rough [history of development](http://aplus.rs/tags/coordinator/), also on my blog. I did not come up with the library all at once, it was a gradual process as all good things are.

[Mind map your app](https://speakerdeck.com/radianttap/mind-map-your-app) - slides from my talk at NSBudapest meetup in May 2018. Very rough [video recording](https://youtu.be/7bOo7X5znKw) of that talk.

***

Soroush Khanlou: [Coordinators Redux](http://khanlou.com/2015/10/coordinators-redux/)

Andrey Panov: [Coordinators Essential tutorial](https://medium.com/blacklane-engineering/coordinators-essential-tutorial-part-i-376c836e9ba7)

Matthew Wyskiel: [Protocol-Oriented App Coordinators in Swift](https://mattwyskiel.github.io/posts/2016/07/20/protocol-oriented-app-coordinator-swift.html)

Coordinators are fairly old pattern but it was Soroush who brought them under iOS developer spotlight in 2015. My library follows the core idea but employs a different implementation.

***

Bill Dudney, WWDC 2014, session 224: [Core iOS Application Architectural Patterns](https://developer.apple.com/videos/play/wwdc2014/224/)

Andy Matuschak & Colin Barrett, WWDC 2014, session 229: [Advanced iOS Application Architecture and Patterns](https://developer.apple.com/videos/play/wwdc2014/229/)

I file these two talks under *essential education* for any iOS developer. While not directly associated with Coordinator pattern, you should still carefully watch and listen to understand what it means to “fit inside iOS SDK”.


## License

[MIT](https://choosealicense.com/licenses/mit/), as usual.


[^1]: That framework seems long abandoned and my requests to remove it and thus allow me to publish mine were unsuccessful.