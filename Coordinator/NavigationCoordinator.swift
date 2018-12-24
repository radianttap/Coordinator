//
//  NavigationCoordinator.swift
//  Radiant Tap Essentials
//
//  Copyright © 2017 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

open class NavigationCoordinator: Coordinator<UINavigationController>, UINavigationControllerDelegate {
	//	References to actual UIViewControllers managed by this Coordinator instance.
	open var viewControllers: [UIViewController] = []

	///	This method is implemented to detect when "pop" happens.
	///	`popViewController` must be detected in order to remove popped VC from Coordinator's `viewControllers` array.
	public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
		let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from)
		self.didShowController(viewController, fromViewController: fromViewController)
	}

	public func present(_ vc: UIViewController) {
		rootViewController.present(vc, animated: true, completion: nil)
	}

	public func dismiss() {
		rootViewController.dismiss(animated: true, completion: nil)
	}

	public func show(_ vc: UIViewController) {
		viewControllers.append(vc)
		rootViewController.show(vc, sender: self)
	}

	public func root(_ vc: UIViewController) {
		viewControllers = [vc]
		rootViewController.viewControllers = [vc]
	}

	public func top(_ vc: UIViewController) {
		if viewControllers.count == 0 {
			root(vc)
			return
		}
		viewControllers.removeLast()
		rootViewController.viewControllers.removeLast()
		show(vc)
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

	///	If you subclass NavigationCoordinator, then override this method if you need to
	///	do something special when customer taps the UIKit's backButton in the navigationBar.
	///
	///	By default, this does nothing.
	open func handlePopBack(to vc: UIViewController?) {
	}

	open override func start(with completion: @escaping () -> Void) {
		//	assign itself as UINavigationControllerDelegate
		rootViewController.delegate = self
		//	must call this
		super.start(with: completion)
	}

	open override func stop(with completion: @escaping () -> Void) {
		//	relinquish being delegate for UINC
		rootViewController.delegate = nil

		//	remove all of its UIVCs from the root UINC
		for vc in viewControllers {
			guard let index = rootViewController.viewControllers.index(of: vc) else { continue }
			rootViewController.viewControllers.remove(at: index)
		}
		//	clean up UIVC instances
		viewControllers.removeAll()
		//	must call this
		super.stop(with: completion)
	}

	open override func activate() {
		//	take ownership over UINavigationController
		super.activate()
		//	assign itself again as UINavigationControllerDelegate
		rootViewController.delegate = self
		//	re-assign own content View Controllers
		rootViewController.viewControllers = viewControllers
	}
}

private extension NavigationCoordinator {
	func didShowController(_ viewController: UIViewController, fromViewController: UIViewController?) {
		guard let fromViewController = fromViewController else { return }

		//	if this FROM controller is not in the Coordinator's internal list, ignore it
		if !viewControllers.contains( viewController ) { return }

		//	check is this pop:
		if let vc = self.viewControllers.last, vc === fromViewController {
			//	it is pop. remove this controller from Coordinator's list
			self.viewControllers.removeLast()
			//	customization point for the NavigationCoordinator's subclass
			//	to update its internal state on pop-back
			self.handlePopBack(to: self.viewControllers.last)
		}

		//	is there any controller left shown in this Coordinator?
		if self.viewControllers.count == 0 {
			//	inform the parent Coordinator that this child Coordinator has no more VCs
			self.parent?.coordinatorDidFinish(self, completion: {})
			return
		}
	}
}
