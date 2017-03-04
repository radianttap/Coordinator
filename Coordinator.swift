//
//  Coordinator.swift
//  Radiant Tap Essentials
//
//  Created by Aleksandar Vacić on 21.10.16..
//  Copyright © 2016 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

/**
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

open class Coordinator<T>: UIResponder {
	/// A callback function used by coordinators to signal events.
	public typealias Callback = (Any) -> Void


	/// The root view controller for a coordinator.
	///	Each coordinator creates its VC hierarchy internally, so there should be no need to alter this once set
	open var rootViewController: T


	/// You need to supply at least one UIViewController (or any of its subclasses) that will be loaded as root.
	///	Usually one of container controllers (UINavigationController, UITabBarController etc)
	///
	/// - parameter rootViewController: UIViewController at the top of the hierarchy.
	///
	/// - returns: Coordinator instance, prepared to start
	public required init(rootViewController: T?) {
		guard let rootViewController = rootViewController else {
			fatalError("Must supply UIViewController (or any of its subclasses) or override this init and instantiate VC in there.")
		}
		//	set as initial controller. Can't be changed later on
		self.rootViewController = rootViewController
	}


	/// Default identifier is the class name of the Coordinator subclass
	public static var identifier: String {
		return String(describing: self)
	}

	open var identifier: String {
		return type(of: self).identifier
	}


	/// Parent Coordinator
	open var parent: Any?	//	this annoys me, but will fix as time allows


	///	A dictionary of child Coordinators, where key is Coordinator's identifier property
	open var childCoordinators: [String: Any] = [:]



	/// Tells the coordinator to create its initial view controller and take over the user flow.
	///	Use this method to configure your `rootViewController` (if it isn't already).
	///	Some examples:
	///	* instantiate and assign `viewControllers` for UINavigationController or UITabBarController
	///	* assign itself (Coordinator) as delegate for the shown UIViewController(s)
	///	* setup closure entry/exit points
	///	etc.
	///
	///	- Parameter completion: An optional `Callback` executed at the end.
	open func start(with completion: @escaping Callback = {_ in}) {}

	/// Tells the coordinator that it is done and that it should 
	///	rewind the view controller state to where it was before `start` was called.
	///	That means either dismiss presented controller or pop pushed ones.
	///
	///	- Parameter completion: An optional `Callback` executed at the end.
	open func stop(with completion: @escaping Callback = {_ in}) {}



	/**
	Adds new child coordinator and starts it.

	- Parameter coordinator: The coordinator implementation to start.
	- Parameter completion: An optional `Callback` passed to the coordinator's `start()` method.

	- Returns: The started coordinator.
	*/
	public func startChild<U>(coordinator: Coordinator<U>, completion: @escaping Callback = {_ in}) {
		childCoordinators[coordinator.identifier] = coordinator
		coordinator.parent = self
		coordinator.start(with: completion)
	}


	/**
	Stops the given child coordinator and removes it from the `childCoordinators` array

	- Parameter coordinator: The coordinator implementation to start.
	- Parameter completion: An optional `Callback` passed to the coordinator's `stop()` method.
	*/
	public func stopChild<U>(coordinator: Coordinator<U>, completion: @escaping Callback = {_ in}) {
		coordinator.parent = nil
		coordinator.stop {
			[unowned self] obj in
			guard
				let coord = obj as? Coordinator<Any>,
				let c = self.childCoordinators.removeValue(forKey: coord.identifier)
			else { return }
			completion(c)
		}
	}

	/**
	Stops the child coordinator with given identifier and removes it from the `childCoordinators` array

	- Parameter coordinator: The coordinator implementation to start.
	- Parameter completion: An optional `Callback` passed to the coordinator's `stop()` method.
	*/
	public func stopChild<U>(with identifier: String, type: U.Type, completion: @escaping Callback = {_ in}) {
		guard let c = childCoordinators[identifier] as? Coordinator<U> else { return }
		stopChild(coordinator: c, completion: completion)
	}

	///	Returns either `parent` coordinator or nil if there isn‘t one
	override open var coordinatingResponder: UIResponder? {
		return parent as? UIResponder
	}
}



//	Inject parentCoordinator property into all UIViewControllers
extension UIViewController {
	private struct AssociatedKeys {
		static var ParentCoordinator = "ParentCoordinator"
	}
	///	*Must* be set for View Controller acting as Coordinator.rootViewController
	public var parentCoordinator: Any? {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.ParentCoordinator)
		}
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.ParentCoordinator, newValue, .OBJC_ASSOCIATION_ASSIGN)
		}
	}
}




/**
Driving engine of the message passing through the app, with no need for Delegate pattern nor Singletons.

Coordinable will piggy-back on the UIResponder.next? in order to pass the message through UIView/UIVC hierarchy of any depth and complexity.
However, it does not interfere with the regular UIResponder functionality.

At the UIViewController level (see below), it‘s intercepted to switch up to the coordinator, if the UIVC has one.
Once that happens, it stays in the Coordinator hierarchy, since coordinator can be nested only inside other coordinators.
*/
public extension UIResponder {
	open var coordinatingResponder: UIResponder? {
		return next
	}
	/*	// sort-of implementation of the custom message/command to put into your Coordinable extension
	func messageTemplate(args: Whatever, sender: Any?) {
		coordinatingResponder?.messageTemplate(args: args, sender: sender)
	}
 */
}


//extension UIView: Coordinable {
//	open var coordinatingResponder: Coordinable? {
//		return next as? Coordinable
//	}
//}

extension UIViewController {
	/**	(from UIKit `next:` docs)

	---
	The UIResponder class does not store or set the next responder automatically,
	instead returning nil by default.

	Subclasses must override this method to set the next responder.
	UIView implements this method by returning the UIViewController object
	that manages it (if it has one) or its superview (if it doesn’t);
	UIViewController implements the method by returning its view’s superview;
	UIWindow returns the application object, and UIApplication returns nil.

	---

	Thus this returns `parentCoordinator` if the current UIViewController has one,
	or its view's `superview` if it doesn‘t.
	*/
	///	Returns either `parent` coordinator or nil if there isn‘t one
	override open var coordinatingResponder: UIResponder? {
		guard let parentCoordinator = self.parentCoordinator as? UIResponder else {
			return view.superview
		}
		return parentCoordinator
	}
}

