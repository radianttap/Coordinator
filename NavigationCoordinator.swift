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

	///	This method is implemented to detect when "pop" happens.
	///	`popViewController` must be detected in order to remove popped VC from Coordinator's `viewControllers` array.
	public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
		if #available(iOS 10.0, *) {
			let wasStartedInteractive = navigationController.transitionCoordinator?.initiallyInteractive ?? false
			if !wasStartedInteractive {
				//	non-interactive transition
				let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from)
				self.willShowController(viewController, fromViewController: fromViewController)

			} else {
				//	interactive
				navigationController.transitionCoordinator?.notifyWhenInteractionChanges {
					[unowned self] context in
					//	if cancelled, pop will not happen. so just bail out
					if context.isCancelled { return }
					//	if switched to interactive segment, bail out
					if context.isInteractive { return }
					//	if transition did not finish at least 50%, then it's the same as cancelled
					if context.percentComplete < 0.5 { return }

					//	TODO:
					//	if transition switches back to interactive after this point,
					//	then we will essentially have `push` again. or not..?

					let fromViewController = context.viewController(forKey: .from)
					self.willShowController(viewController, fromViewController: fromViewController)
				}
			}

		} else { // < iOS 10
			let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from)
			self.willShowController(viewController, fromViewController: fromViewController)
		}
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

	open func handlePopBack(to vc: UIViewController?) {
	}

	open override func start(with completion: @escaping () -> Void) {
		rootViewController.delegate = self
		super.start(with: completion)
	}

	open override func stop(with completion: @escaping () -> Void) {
		rootViewController.delegate = nil

		for vc in viewControllers {
			guard let index = rootViewController.viewControllers.index(of: vc) else { continue }
			rootViewController.viewControllers.remove(at: index)
		}

		viewControllers.removeAll()

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
	func willShowController(_ viewController: UIViewController, fromViewController: UIViewController?) {
		guard let fromViewController = fromViewController else { return }

		if !viewControllers.contains( viewController ) { return }

		//	check is this pop:
		if let vc = self.viewControllers.last, vc === fromViewController {
			//	this is pop. remove this controller from Coordinator's list
			self.viewControllers.removeLast()
			self.handlePopBack(to: self.viewControllers.last)
		}
		//	is there any controller left shown?
		if self.viewControllers.count == 0 {
			//	inform the parent Coordinator that this child Coordinator has no more views
			self.parent?.coordinatorDidFinish(self, completion: {})
			return
		}
	}
}


