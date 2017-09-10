//
//  Coordinator.swift
//  Radiant Tap Essentials
//
//  Copyright © 2016 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

/*
Coordinators are a design pattern that encourages decoupling view controllers
such that they know as little as possible about how they are presented.

As such, view controllers should never directly push/pop or present other VCs.
They should either use:
1. Delegate pattern to indicate such action is needed and owning Coordinator will assign itself delegate
2. Specific closures that owning Coordinator will populate and thus respond to
3. Custom actions implemented using `targetViewController(for:sender:)` API

Coordinators can be “nested” such that child coordinators encapsulate different flows
and prevent any one of them from becoming too large.

Each coordinator has an identifier to simplify logging and debugging.
Identifier is also used as key for the childCoordinators dictionary

You can either use Coordinator instances directly or – far more likely –
subclass them to add specific behavior for the given particular usage.

Note: Don't overthink this. Idea is to have fairly small number of coordinators in the app.
If you embed controllers into other VC (thus using them as simple UI components),
then keep that flow inside the given container controller.
Expose to Coordinator only those behaviors that cause push/pop/present to bubble up
*/


///	Main Coordinator instance, where T is UIViewController or any of its subclasses.
open class Coordinator<T: UIViewController>: UIResponder, Coordinating {
	open let rootViewController: T


	/// You need to supply UIViewController (or any of its subclasses) that will be loaded as root of the UI hierarchy.
	///	Usually one of container controllers (UINavigationController, UITabBarController etc).
	///
	/// - parameter rootViewController: UIViewController at the top of the hierarchy.
	///
	/// - returns: Coordinator instance, prepared to start
	public init(rootViewController: T?) {
		guard let rvc = rootViewController else {
			fatalError("Must supply UIViewController (or any of its subclasses) or override this init and instantiate VC in there.")
		}
		self.rootViewController = rvc
		super.init()

		rvc.parentCoordinator = self
	}


	open lazy var identifier: String = {
		return String(describing: type(of: self))
	}()


	/// Parent Coordinator can be any other Coordinator
	open weak var parent: Coordinating?

	///	A dictionary of child Coordinators, where key is Coordinator's identifier property
	///	The only way to add/remove something is through startChild/stopChild methods
	fileprivate(set) public var childCoordinators: [String: Coordinating] = [:]



	open override var coordinatingResponder: UIResponder? {
		return parent as? UIResponder
	}



	/// Tells the coordinator to create/display its initial view controller and take over the user flow.
	///	Use this method to configure your `rootViewController` (if it isn't already).
	///	Some examples:
	///	* instantiate and assign `viewControllers` for UINavigationController or UITabBarController
	///	* assign itself (Coordinator) as delegate for the shown UIViewController(s)
	///	* setup closure entry/exit points
	///	etc.
	///
	///	- Parameter completion: An optional `Callback` executed at the end.
	open func start(with completion: @escaping () -> Void = {}) {
		completion()
	}

	/// Tells the coordinator that it is done and that it should
	///	rewind the view controller state to where it was before `start` was called.
	///	That means either dismiss presented controller or pop pushed ones.
	///
	///	- Parameter completion: An optional `Callback` executed at the end.
	open func stop(with completion: @escaping () -> Void = {}) {
		completion()
	}


	open func coordinatorDidFinish(_ coordinator: Coordinating) {
		stopChild(coordinator: coordinator)
	}

	/**
	Adds new child coordinator and starts it.

	- Parameter coordinator: The coordinator implementation to start.
	- Parameter completion: An optional `Callback` passed to the coordinator's `start()` method.

	- Returns: The started coordinator.
	*/
	public func startChild(coordinator: Coordinating, completion: @escaping () -> Void = {}) {
		childCoordinators[coordinator.identifier] = coordinator
		coordinator.parent = self
		coordinator.start(with: completion)
	}


	/**
	Stops the given child coordinator and removes it from the `childCoordinators` array

	- Parameter coordinator: The coordinator implementation to stop.
	- Parameter completion: An optional `Callback` passed to the coordinator's `stop()` method.
	*/
	public func stopChild(coordinator: Coordinating, completion: @escaping () -> Void = {}) {
		coordinator.parent = nil
		coordinator.stop {
			[unowned self] in

			self.childCoordinators.removeValue(forKey: coordinator.identifier)
			completion()
		}
	}
}



//	Inject parentCoordinator property into all UIViewControllers
extension UIViewController {
	private struct AssociatedKeys {
		static var ParentCoordinator = "ParentCoordinator"
	}

	public weak var parentCoordinator: Coordinating? {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.ParentCoordinator) as? Coordinating
		}
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.ParentCoordinator, newValue, .OBJC_ASSOCIATION_ASSIGN)
		}
	}
}




/**
Driving engine of the message passing through the app, with no need for Delegate pattern nor Singletons.

It piggy-backs on the UIResponder.next? in order to pass the message through UIView/UIVC hierarchy of any depth and complexity.
However, it does not interfere with the regular UIResponder functionality.

At the UIViewController level (see below), it‘s intercepted to switch up to the coordinator, if the UIVC has one.
Once that happens, it stays in the Coordinator hierarchy, since coordinator can be nested only inside other coordinators.
*/
public extension UIResponder {
	@objc public var coordinatingResponder: UIResponder? {
		return next
	}

	/*
	// sort-of implementation of the custom message/command to put into your Coordinable extension

	func messageTemplate(args: Whatever, sender: Any?) {
		coordinatingResponder?.messageTemplate(args: args, sender: sender)
	}
 */
}


extension UIViewController {
	/**
	Returns `parentCoordinator` if the current UIViewController has one,
	or its view's `superview` if it doesn‘t.

	---
	(Attention: from UIResponder.next documentation)

	The UIResponder class does not store or set the next responder automatically,
	instead returning nil by default.

	Subclasses must override this method to set the next responder.
	UIView implements this method by returning the UIViewController object
	that manages it (if it has one) or its superview (if it doesn’t);
	UIViewController implements the method by returning its view’s superview;
	UIWindow returns the application object, and UIApplication returns nil.
	*/
	override open var coordinatingResponder: UIResponder? {
		guard let parentCoordinator = self.parentCoordinator else {
			return view.superview
		}
		return parentCoordinator as? UIResponder
	}
}

