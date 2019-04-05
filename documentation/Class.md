[Coordinator](../README.md) : the [Pattern](Pattern.md) · the [Library](Library.md) · the **Class** · recommended [Implementation](Implement.md)

## Coordinator: the class

`Coordinator` class is parameterized with UIViewController subclass it uses as root VC. 
(`Coordinating` protocol exists mainly to avoid issues with generic classes and collections.)

```swift
open class Coordinator<T: UIViewController>: UIResponder, Coordinating {
	public init(rootViewController: T?) { ... }
	
	open override var coordinatingResponder: UIResponder? {
		return parent as? UIResponder
	}
}
```

Since apps can be fairly complex, each Coordinator can have an unlimited number of child Coordinators. Thus you can have `AccountCoordinator`, `PaymentCoordinator`, `CartCoordinator`, `CatalogCoordinator` and so on. There are no rules nor guidelines: group your related app screens under particular Coordinator umbrella as you see fit.

When you instantiate a Coordinator instance, you call `start()` to use it and `stop()` when it’s no longer needed.

In the Coordinator subclass, you’ll override the method you defined in the UIResponder extension and actually do something useful instead of just calling the same method on next `coordinatingResponder`.

### NavigationCoordinator

This is the only concrete subclass this library offers and I encourage you to subclass it for your own needs. 

It uses `UINavigationController` as root VC and it keeps references to shown UIVCs in its own `viewControllers` property. This property shadows UINavigationController’s property of the same name but it is not cleared out until the NavigationCoordinator is stopped. This allows you to replace one NavigationCoordinator instance with another and saving and restoring their stack of UIVC instances in the process.

If offers all the methods you may need when working with navigation pattern:

· `root(_ vc: UIViewController)‌` — replaces entire navigation stack with just this one given UIVC. Perfect when switching from one multi-screen user flow (like say account creation process) to single view (say account confirmation code screen)

· `show(_ vc: UIViewController)` — same as navigationController.show().

· `top(_ vc: UIViewController)‌` — replace the visible UIVC with the given one. Does not replace entire navigation stack, just the last UIVC (which is currently visible)

· `‌pop(to vc: UIViewController, animated: Bool = true)` — programmatically pop the stack to the given UIVC instance, which should exist in the navigation stack.

· `‌present(_ vc: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil)` — `NavigationCoordinator` will setup itself as `parentCoordinator` for the given `vc` and then its root UINavigationController will present that `vc`

· `‌dismiss(animated: Bool = true, completion: (() -> Void)? = nil)` — dismiss the currently presented UIVC.

NavigationController gives you a chance to react to the customer tap on the Back button. Simply override this method and update your internal state:

· `‌handlePopBack(to vc: UIViewController?)`