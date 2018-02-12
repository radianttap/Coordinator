//
//  Coordinator.swift
//  Radiant Tap Essentials
//
//  Copyright © 2016 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit


///	Simple closure which allows you to wrap any coordinatingResponder method and
///	add it into a `queuedMessages` array on the Coordinator.
///
///	You need to do this in case method needs a dependency that may not be available
///	at that particular moment. So save it until dependencies are updated.
public typealias CoordinatingQueuedMessage = () -> Void


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

	///	List of wrapped methods requiring dependency which is not available right now
	fileprivate(set) public var queuedMessages: [CoordinatingQueuedMessage] = []

	///	Simply add the message wrapped in the closure. Mind the capture list for `self`.
	public func enqueueMessage(_ message: @escaping CoordinatingQueuedMessage ) {
		queuedMessages.append( message )
	}

	///	Call this each time your Coordinator's dependencies are updated
	public func processQueuedMessages() {
		//	make a local copy
		let arr = queuedMessages
		//	clean up the queue, in case it's re-populated while this pass is ongoing
		queuedMessages.removeAll()
		//	execute each message
		arr.forEach { $0() }
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
		rootViewController.parentCoordinator = self
		completion()
	}

	/// Tells the coordinator that it is done and that it should
	///	rewind the view controller state to where it was before `start` was called.
	///	That means either dismiss presented controller or pop pushed ones.
	///
	///	- Parameter completion: An optional `Callback` executed at the end.
	open func stop(with completion: @escaping () -> Void = {}) {
		rootViewController.parentCoordinator = nil
		completion()
	}


	open func coordinatorDidFinish(_ coordinator: Coordinating, completion: @escaping () -> Void = {}) {
		stopChild(coordinator: coordinator, completion: completion)
	}

	///	Coordinator can be in memory, but it‘s not currently displaying anything.
	///	For example, parentCoordinator started some other Coordinator which then took over root VC to display its VCs,
	///	but did not stop this one.
	///
	///	Parent Coordinator can then re-activate this one, in which case it should take-over the
	///	the ownership of the root VC.
	open func activate() {
		rootViewController.parentCoordinator = self
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

