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

	///	This method is implemented to detect when customer "pop" back using UINC's backButtonItem.
	///	(Need to detect that in order to remove popped VC from Coordinator's `viewControllers` array.)
	///
	///	It is strongly advised to *not* override this method, but it's allowed to do so in case you really need to.
	///	What you likely want to override is `handlePopBack(to:)` method.
	open func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
		//	By the moment this method is called, UINC's viewControllers is already updated.
		//	If it was push, `viewControllers` will contain this shown `viewController`.
		//	For pop, VC is already removed.

		guard let transitionCoordinator = navigationController.transitionCoordinator else {
			//	TransitionCoordinator is not present, most likely because `popViewController(animated: false)` is called.
			//	In the Coordinator-based app, this should *not* be done, ever.
			return
        }

		//	If transitionCoordinator is present, it's an animated push or pop.
		//	Check if FROM ViewController is still present in NC's viewControllers list;
		//	if it is, it means that this is push and we don't care about this.
		guard
			let fromViewController = transitionCoordinator.viewController(forKey: .from),
            !navigationController.viewControllers.contains(fromViewController)
		else {
			return
        }

		self.didPopTransition(to: viewController)
	}

	///	If you subclass NavigationCoordinator, then override this method if you need to
	///	do something special when customer taps the UIKit's backButton in the navigationBar.
	///
	///	By default, this does nothing.
	open func handlePopBack(to vc: UIViewController?) {
	}


	//	MARK:- Presenting

	public func present(_ vc: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
		vc.parentCoordinator = self
		rootViewController.present(vc, animated: animated, completion: completion)
	}

	public func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
		rootViewController.dismiss(animated: animated, completion: completion)
	}


	//	MARK:- Navigating

	///	Main method to push supplied UIVC to the navigation stack.
	///	First it adds the `vc` to the Coordinator's `viewControllers` then calls `show(vc)` on the root.
	public func show(_ vc: UIViewController) {
		viewControllers.append(vc)
		rootViewController.show(vc, sender: self)
	}

	///	Clears entire navigation stack on both the Coordinator and UINavigationController by
	/// setting this `[vc]` on respective `viewControllers` property.
	public func root(_ vc: UIViewController) {
		viewControllers = [vc]
		rootViewController.viewControllers = [vc]
	}

	///	Replaces current top UIVC in the navigation stack (currently visible UIVC) in the root
	///	with the supplied `vc` instance.
	public func top(_ vc: UIViewController, animated: Bool = true) {
		if viewControllers.count == 0 {
			root(vc)
			return
		}
		viewControllers.removeLast()

		if animated {
			rootViewController.viewControllers.removeLast()
			show(vc)
		} else {
			viewControllers.append(vc)
			rootViewController.viewControllers = viewControllers
		}
	}

	///	Pops back to previous UIVC in the stack, inside this Coordinator.
	public func pop(animated: Bool = true) {
		//	there must be at least two VCs in order for UINC.pop to succeed (you can't pop the last VC in the stack)
		if viewControllers.count < 2 {
			return
		}
		viewControllers = Array(viewControllers.dropLast())

		rootViewController.popViewController(animated: animated)
	}

	///	Pops back to the given instance, removing one or more UIVCs from the navigation stack.
	public func pop(to vc: UIViewController, animated: Bool = true) {
		guard let index = viewControllers.firstIndex(of: vc) else { return  }

		let lastPosition = viewControllers.count - 1
		if lastPosition - index <= 0 {
			return
		}

		viewControllers = Array(viewControllers.dropLast(lastPosition - index))
		rootViewController.popToViewController(vc, animated: animated)
	}


	//	MARK:- Coordinator lifecycle

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
			guard let index = rootViewController.viewControllers.firstIndex(of: vc) else { continue }
			rootViewController.viewControllers.remove(at: index)
		}

		//	clean up UIVC instances
		viewControllers.removeAll()

		//	must call this
		super.stop(with: completion)
	}

	override open func coordinatorDidFinish(_ coordinator: Coordinating, completion: @escaping () -> Void = {}) {
		//	some child Coordinator reports that it's done (pop-ed back from, most likely)
        super.coordinatorDidFinish(coordinator) {
			[weak self] in
			guard let self = self else { return }

			//	figure out which Coordinator should now take ownershop of root NC
			guard let topVC = self.rootViewController.topViewController else {
				completion()
				return
			}
			//	if it belongs to this Coordinator, then re-activate itself
			if self.viewControllers.contains(topVC) {
				self.activate()
				self.handlePopBack(to: topVC)

				completion()
				return
			}

			//	if not, go through other possible child Coordinators
			for (_, c) in self.childCoordinators {
				if
					let c = c as? NavigationCoordinator,
					c.viewControllers.contains(topVC)
				{
					c.activate()
					c.handlePopBack(to: topVC)

					completion()
					return
				}
			}

			//	if nothing found, then this Coordinator is also done, along with its child
			self.parent?.coordinatorDidFinish(self, completion: completion)
        }
    }

	open override func activate() {
		//	take back ownership over root (UINavigationController)
		super.activate()

		//	assign itself again as `UINavigationControllerDelegate`
		rootViewController.delegate = self
	}

	///	Activates existing Coordinator instance by assigning itself as UINCDelegate for the rootViewController. (read: calls `activate()`)
	///	Then installs its `viewControllers` on (root) UINavigationController, effectivelly clearing out its previous stack.
	///
	///	Call this when you want to entirely replace one Coordinator instance with another Coordinator.
	open override func takeover() {
		activate()

		//	re-assign own content View Controllers, clearing out whatever is there
		rootViewController.viewControllers = viewControllers
	}
}

private extension NavigationCoordinator {
	func didPopTransition(to viewController: UIViewController) {
		//	Check: is there any controller left shown in this Coordinator?
		if viewControllers.count == 0 {
			//	there isn't thus inform the parent Coordinator that this child Coordinator is done.
			parent?.coordinatorDidFinish(self, completion: {})
			return
		}

		//	If VC, which was just shown, is the last in this Coordinator's stack,
		//	then nothing to do, because the other VC (which was pop-ed) was not in this Coordinator's domain.
		//		| If this actually happens, it likely points to a mistake somewhere else.
		//		| (It means we had some `show(vc)` happen that _did not_ update this Coordinator's viewControllers,
		//		|  nor it switched to some other Coordinator which should have become UINC.delegate)
		if viewController === viewControllers.last {
			return
		}
		
		//	Check: is VC present in Coordinator's viewControllers sequence?
		//		| Note: using firstIndex(of:) and not .last nicely handles if you programatically pop more than one UIVC.
		guard let index = viewControllers.firstIndex(of: viewController) else {
			//	it's not, it means UINC moved to some other Coordinator domain and thus bail out from here
			parent?.coordinatorDidFinish(self, completion: {})
			return
		}

		let lastIndex = viewControllers.count - 1
		if lastIndex <= index {
			return
		}
		viewControllers = Array(viewControllers.dropLast(lastIndex - index))

		handlePopBack(to: viewController)
	}
}
