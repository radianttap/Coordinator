[Coordinator](../README.md) : the [Pattern](Pattern.md) · the **Library** · the [Class](Class.md) · recommended [Implementation](Implement.md)

## Coordinator: the library

Per this library, Coordinator instance is essentially defined by these two points:

· **1** · It has one instance of UIViewController which is its *root ViewController*. This is usually some container controller like `UINavigationController` but it can be any subclass.

This way, it can internally create instances of UIVC, populate their input with data it needs and then just _show_ or _present_ them as needed. By reusing these essential UIKit mechanisms it minimally interferes with how iOS already works. 

Coordinator takes care of navigation and routing while View Controller takes care of UI controls, touches and their corresponding events.

· **2** · It subclasses `UIResponder`, same as `UIView` and `UIViewController` do.

This is crucial. Library [extends UIResponder](https://github.com/radianttap/Coordinator/blob/master/Coordinator/UIKit-CoordinatingExtensions.swift) by giving it a new property called `coordinatingResponder`. This means that if you define a method like this:

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

So this is how the chain is closed up. Which brings us to the `Coordinator` class.
