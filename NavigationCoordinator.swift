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
	}

	public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {

        if #available(iOS 10.0, *) {
        navigationController.transitionCoordinator?.notifyWhenInteractionChanges({ [unowned self] context in
            guard !context.isInteractive else { return }
            self.willShowController(viewController, fromViewController: context.viewController(forKey: .from))

        })} else {
            //    get the FROM coordinator in the NC transition
            let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from)
            self.willShowController(viewController, fromViewController: fromViewController)
        }
	}

	public func present(_ vc: UIViewController) {
		rootViewController.present(vc, animated: true, completion: nil)
	}

	public func show(_ vc: UIViewController) {
		viewControllers.append(vc)
		rootViewController.show(vc, sender: self)
	}

	public func root(_ vc: UIViewController) {
		viewControllers = [vc]
		rootViewController.viewControllers = [vc]
	}

	public func pop(to vc: UIViewController, animated: Bool = true) {
		rootViewController.popToViewController(vc, animated: animated)

		if let index = viewControllers.index(of: vc) {
			let lastPosition = viewControllers.count - 1
			if lastPosition > 0 {
				viewControllers = Array(viewControllers.dropLast(lastPosition - index))
			}
		}
	}

	open func handlePopBack(to vc: UIViewController?) {
	}

	open override func start(with completion: @escaping () -> Void) {
		rootViewController.delegate = self
		super.start(with: completion)
	}

	open override func stop(with completion: @escaping () -> Void) {
		rootViewController.delegate = nil
		viewControllers.removeAll()
		super.stop(with: completion)
	}
}

fileprivate extension NavigationCoordinator {
    func willShowController(_ toViewController: UIViewController, fromViewController: UIViewController?) {
        guard let fromViewController = fromViewController else { return }

        //    check is this pop:
        if let vc = self.viewControllers.last, vc === fromViewController {
            //    this is pop. remove this controller from Coordinator's list
            self.viewControllers.removeLast()
            self.handlePopBack(to: self.viewControllers.last)
        }
        //    is there any controller left shown?
        if self.viewControllers.count == 0 {
            //    inform the parent Coordinator that this child Coordinator has no more views
            self.parent?.coordinatorDidFinish(self)
            return
        }
    }
}


