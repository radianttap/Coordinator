//
//  UIKit-CoordinatingExtensions.swift
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




/**
Driving engine of the message passing through the app, with no need for Delegate pattern nor Singletons.

It piggy-backs on the UIResponder.next? in order to pass the message through UIView/UIVC hierarchy of any depth and complexity.
However, it does not interfere with the regular UIResponder functionality.

At the UIViewController level (see below), it‘s intercepted to switch up to the coordinator, if the UIVC has one.
Once that happens, it stays in the Coordinator hierarchy, since coordinator can be nested only inside other coordinators.
*/
public extension UIResponder {
	@objc public var coordinatingResponder: UIResponder? {
		return next
	}

	/*
	// sort-of implementation of the custom message/command to put into your Coordinable extension

	func messageTemplate(args: Whatever, sender: Any?) {
	coordinatingResponder?.messageTemplate(args: args, sender: sender)
	}
	*/
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
				return view.superview
			}
			return parentController as UIResponder
		}
		return parentCoordinator as? UIResponder
	}
}

