//
//  Coordinating.swift
//  Radiant Tap Essentials
//
//  Copyright © 2017 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

///	Helper protocol to simplify coordinator‘s hierarchy walk-up.
///
///	Note: This protocol should not be subclassed.
public protocol Coordinating: class {
	///	Unique string to identify specific Coordinator instance
	///
	///	By default it will be String representation of the Coordinator's subclass.
	///	If you directly instantiate `Coordinator<T>`, then you need to set it manually
	var identifier: String { get }

	/// Parent Coordinator can be any other Coordinator
	weak var parent: Coordinating? { get set }

	///	A dictionary of child Coordinators, where key is Coordinator's identifier property
	var childCoordinators: [String: Coordinating] { get }

	///	Returns either `parent` coordinator or `nil` if there isn‘t one
	var coordinatingResponder: UIResponder? { get }

	///	Tells the coordinator to start, which means at the end of this method it should
	///	display some UIViewController
	func start(with completion: @escaping () -> Void)

	///	Tells the coordinator to stop, which means it should clear out any internal stuff
	///	it possible tracks. I.e. list of shown UIViewControllers
	func stop(with completion: @escaping () -> Void)

	///	Call this method if the Coordinator is using UINavigationController
	///	as rootViewController and customer has just pop-ed out of `coordinator` domain
	///
	///	This allows you to inform `coordinator.parent` it should activate something else
	///	(like previous childCoordinator, if there is one)
	func coordinatorDidFinish(_ coordinator: Coordinating, completion: @escaping () -> Void)

	///	Adds the supplied coordinator into its childCoordinators dictionary and calls its `start` method
	func startChild(coordinator: Coordinating, completion: @escaping () -> Void)

	///	Calls `stop` on the supplied coordinator and removes it from its childCoordinators dictionary
	func stopChild(coordinator: Coordinating, completion: @escaping () -> Void)

	///	Coordinator will assign itself as parentCoordinator of its rootController,
	///	ready to start displaying its content View Controllers.
	///
	///	See NavigationCoordinator for one possible usage.
	func activate()
}


