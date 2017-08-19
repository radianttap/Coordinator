//
//  NavigationCoordinator.swift
//  Radiant Tap Essentials
//
//  Copyright © 2017 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

open class NavigationCoordinator: Coordinator<UINavigationController>, UINavigationControllerDelegate {
	//	this keeps the references to actual UIViewControllers managed by this Coordinator only
	open var viewControllers: [UIViewController] = []

	public override init(rootViewController: UINavigationController?) {
		super.init(rootViewController: rootViewController)

		rootViewController?.delegate = self
	}

	public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
		//	get the FROM coordinator in the NC transition
		guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
			return
		}

		//	check is this pop:
		if let vc = viewControllers.last, vc === fromViewController {
			//	this is pop. remove this controller from Coordinator's list
			viewControllers.removeLast()
		}
		//	is there any controller left shown?
		if viewControllers.count == 0 {
			//	inform the parent Coordinator that this child Coordinator has no more views
			parent?.coordinatorDidFinish(self)
			return
		}
	}

	public func show(_ vc: UIViewController) {
		viewControllers.append(vc)
		rootViewController.show(vc, sender: self)
	}

	public func root(_ vc: UIViewController) {
		viewControllers = [vc]
		rootViewController.viewControllers = [vc]
	}
}


