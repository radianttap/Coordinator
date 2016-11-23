//
//  Coordinator.swift
//  Radiant Tap Essentials
//
//  Created by Aleksandar Vacić on 21.10.16..
//  Copyright © 2016 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

public protocol CoordinatorType: class {
	associatedtype RootController

	/// You need to supply at least one UIViewController (or any of its subclasses) that will be loaded as root.
	///	Usually one of container controllers (UINavigationController, UITabBarController etc)
	///
	/// - parameter rootViewController: UIViewController at the top of the hierarchy.
	///
	/// - returns: Coordinator instance, prepared to start
	init(rootViewController: RootController?)

	/// The root view controller for a coordinator. Each coordinator creates its VC hierarchy internally, so this is read-only property
	var rootViewController: RootController { get }
}


/**
Coordinators are a design pattern that encourages decoupling view controllers
such that they know as little as possible about how they are presented.
As such, view controllers should never directly push/pop or present other VCs

Coordinators can be “nested” such that child coordinators encapsulate different flows
and prevent any one of them from becoming too large.

Each coordinator has an identifier to simplify logging and debugging.
Identifier can also be used as subscript for the childCoordinators "array"

## Usage

1. Create a simple class named anything you want and adopt this protocol.

2. Each coordinator you create should know all possible exit points from all view controllers it should handle.

3. Exit points are closure properties of type Callback:
- declared by view controller
- defined by coordinator when VC is instantiated

Note: Don't overthink this. If you embed controllers into other VC, then keep their flow their own business.
Expose only those behaviors that cause push/pop/present to bubble up to the Coordinator
*/
public class Coordinator<T>: CoordinatorType {
	///	This
	public typealias RootController = T

	///	Identifier is used to ease-up debug, logging etc.
	public typealias Identifier = String

	/// A callback function used by coordinators to signal events.
	public typealias Callback = (Coordinator) -> Void



	

	/// The root view controller for a coordinator. Each coordinator creates its VC hierarchy internally, so this is read-only property
	public let rootViewController: T

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
	var identifier: Identifier {
		return String(describing: self)
	}

	/// Parent Coordinator
	var parent: Coordinator?

	///	essentially an array of child coordinators
	private(set) var childCoordinators: [Identifier: Coordinator] = [:]





	/// Tells the coordinator to create its initial view controller and take over the user flow.
	func start(with completion: @escaping Callback = {_ in}) {}

	/// Tells the coordinator that it is done and that it should rewind the view controller state to where it was before `start` was called.
	func stop(with completion: @escaping Callback = {_ in}) {}



	/**
	Adds new child coordinator and starts it.

	- Parameter coordinator: The coordinator implementation to start.
	- Parameter callback: An optional `CoordinatorCallback` passed to the coordinator's `start()` method.

	- Returns: The started coordinator.
	*/
	func startChild(coordinator: Coordinator, completion: @escaping Callback = {_ in}) {
		childCoordinators[coordinator.identifier] = coordinator
		coordinator.start(with: completion)
	}


	/**
	Stops the given child coordinator and removes it from the

	- Parameter coordinator: The coordinator implementation to start.
	- Parameter callback: An optional `CoordinatorCallback` passed to the coordinator's `start()` method.
	*/
	func stopChild(coordinator: Coordinator, completion: @escaping Callback = {_ in}) {
		coordinator.stop { [unowned self] coordinator in
			guard let c = self.childCoordinators.removeValue(forKey: coordinator.identifier) else { return }
			completion(c)
		}
	}
}

