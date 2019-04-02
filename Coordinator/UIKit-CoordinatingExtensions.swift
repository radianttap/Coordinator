//
//  UIViewControllerExtensions.swift
//  Radiant Tap Essentials
//
//  Copyright © 2016 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

//	Inject parentCoordinator property into all UIViewControllers
extension UIViewController {
	private struct AssociatedKeys {
		static var ParentCoordinator = "ParentCoordinator"
	}

	public weak var parentCoordinator: Coordinating? {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.ParentCoordinator) as? Coordinating
		}
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.ParentCoordinator, newValue, .OBJC_ASSOCIATION_ASSIGN)
		}
	}
}







extension UIViewController {
	/**
	Returns `parentCoordinator` if the current UIViewController has one,
	or its view's `superview` if it doesn‘t.

	---
	(Attention: from UIResponder.next documentation)

	The UIResponder class does not store or set the next responder automatically,
	instead returning nil by default.

	Subclasses must override this method to set the next responder.

	UIViewController implements the method by returning its view’s superview;
	UIWindow returns the application object, and UIApplication returns nil.
	---

	We also check are there maybe `parent` UIViewController before finally
	falling back to `view.superview`
	*/
	override open var coordinatingResponder: UIResponder? {
		guard let parentCoordinator = self.parentCoordinator else {
			guard let parentController = self.parent else {
				guard let presentingController = self.presentingViewController else {
					return view.superview
				}
				return presentingController as UIResponder
			}
			return parentController as UIResponder
		}
		return parentCoordinator as? UIResponder
	}
}

