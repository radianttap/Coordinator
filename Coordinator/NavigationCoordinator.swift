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
		self.didShowController(viewController)
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
	public func top(_ vc: UIViewController) {
		if viewControllers.count == 0 {
			root(vc)
			return
		}
		viewControllers.removeLast()
		rootViewController.viewControllers.removeLast()
		show(vc)
	}

	///	Pops back to the given instance, removing one or more UIVCs from the navigation stack.
	public func pop(to vc: UIViewController, animated: Bool = true) {
		guard let index = viewControllers.firstIndex(of: vc) else { return  }

		let lastPosition = viewControllers.count - 1
		if lastPosition > 0 {
			viewControllers = Array(viewControllers.dropLast(lastPosition - index))
		}

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

	open override func activate() {
		//	take back ownership over root (UINavigationController)
		super.activate()
		//	assign itself again as `UINavigationControllerDelegate`
		rootViewController.delegate = self
		//	re-assign own content View Controllers
		rootViewController.viewControllers = viewControllers
	}
}

private extension NavigationCoordinator {
	func didShowController(_ viewController: UIViewController) {
		//	Note: various sanity checks are done below, explained in comments.
		//	You would want to add some log calls for each one
		//	(or at least add a breakpoint so you know when it happens)
		//	since those checks point to logical errors in the app's architecture flows.


		//	If VC, which was just shown, is the last in this Coordinator's stack,
		//	then just bail out, because popped VC was not in this Coordinator's domain.
		//		| If this actually happens, it likely points to a mistake somewhere else.
		//		| (It means we had some `show(vc)` happen that _did not_ update this Coordinator's viewControllers,
		//		|  nor it switched to some other Coordinator which should have become UINC.delegate)
		if viewController === viewControllers.last {
			return
		}
		
		//	Check: just shown VC should be present in Coordinator's viewControllers sequence.
		//	If it's not there, then bail out.
		//		| Again, this should not happen,
		//		| since this Coordinator should then not be UINCDelegate.
		guard let index = viewControllers.firstIndex(of: viewController) else {
			return
		}

		//	Note: using firstIndex(of:) and not .last nicely
		//	handles if you programatically pop more than one UIVC.


		let lastIndex = viewControllers.count - 1
		if lastIndex <= index {
			return
		}
		viewControllers = Array(viewControllers.dropLast(lastIndex - index))
		handlePopBack(to: viewController)



		//	is there any controller left shown in this Coordinator?
		if viewControllers.count == 0 {
			//	inform the parent Coordinator that this child Coordinator has no more VCs
			parent?.coordinatorDidFinish(self, completion: {})
		}
	}
}
