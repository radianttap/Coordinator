//
//  Coordinator.swift
//  Radiant Tap Essentials
//
//  Created by Aleksandar Vacić on 21.10.16..
//  Copyright © 2016 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

//	Must do 2-step dance due to the way Swift works with generic protocols
//	`associatedtype RootController` is needed to allow any kind of UIVC subclass to
//	become Coordinator's root VC
public protocol CoordinatorType: class {
	associatedtype RootController
	associatedtype Identifier

	/// You need to supply at least one UIViewController (or any of its subclasses) that will be loaded as root.
	///	Usually one of container controllers (UINavigationController, UITabBarController etc)
	///
	/// - parameter rootViewController: UIViewController at the top of the hierarchy.
	///
	/// - returns: Coordinator instance, prepared to start
	init(rootViewController: RootController?)

	/// The root view controller for a coordinator. 
	///	Each coordinator creates its VC hierarchy internally, so this is read-only property (post init)
	var rootViewController: RootController { get }

	///	Unique identifier for the Coordinator
	var identifier: Identifier { get }
}


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
open class Coordinator<T>: UIResponder, CoordinatorType where T: UIResponder {
	///	This
	public typealias RootController = T

	///	Identifier is used to ease-up debug, logging etc.
	public typealias Identifier = String

	/// A callback function used by coordinators to signal events.
	public typealias Callback = (Coordinator) -> Void



	

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





	/// Default identifier is the class name of the Coordinator
	public var identifier: Identifier {
		return String(describing: self)
	}

	/// Parent Coordinator
	open var parent: Any?
	///	A dictionary of child Coordinators, where key is Coordinator's identifier property
	open var childCoordinators: [Identifier: Coordinator] = [:]



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
	
	For coordinators, we need to return either the parent coordinator if there is one _or_
	nil. Coordinator can be nested only inside other coordinators.

	For this to work properly though, each UIViewController presented by coordinator 
	must adopt `Coordinable` protocol and have parentCoordinator property populated by its
	owning Coordinator

	 */
	override open var next: UIResponder? {
		guard let parent = self.parent as? UIResponder else { return nil }
		return parent
	}



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
	public func startChild(coordinator: Coordinator, completion: @escaping Callback = {_ in}) {
		childCoordinators[coordinator.identifier] = coordinator
		coordinator.parent = self
		coordinator.start(with: completion)
	}


	/**
	Stops the given child coordinator and removes it from the

	- Parameter coordinator: The coordinator implementation to start.
	- Parameter completion: An optional `Callback` passed to the coordinator's `stop()` method.
	*/
	public func stopChild(coordinator: Coordinator, completion: @escaping Callback = {_ in}) {
		coordinator.parent = nil
		coordinator.stop { [unowned self] coordinator in
			guard let c = self.childCoordinators.removeValue(forKey: coordinator.identifier) else { return }
			completion(c)
		}
	}
}


/**
Must be adopted by UIViewController subclasses that are presented by Coordinators,
so that responder chain works properly.

Coordinators must set this property for their rootViewController.
*/
public protocol Coordinable: class {
	var parentCoordinator: Any? { get set }
}

extension UIViewController: Coordinable {
	private struct AssociatedKeys {
		static var ParentCoordinator = "ParentCoordinator"
	}
	///	*Must* bet set for View Controller acting as Coordinator.rootViewController
	open var parentCoordinator: Any? {
		get {
			guard let obj = objc_getAssociatedObject(self, &AssociatedKeys.ParentCoordinator) else { return nil }
			return obj
		}
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.ParentCoordinator, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}

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

	Thus, to avoid messing up the Responder chain, here return either 
	- the `parentCoordinator` if it exists or
	- the `view.superview`
	*/
	override open var next: UIResponder? {
		guard let parentCoordinator = self.parentCoordinator as? UIResponder else {
			return view.superview
		}
		return parentCoordinator
	}
}
