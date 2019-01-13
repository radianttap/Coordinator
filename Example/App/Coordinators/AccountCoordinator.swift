//
//  AccountCoordinator.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 20.8.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation
import Coordinator

final class AccountCoordinator: NavigationCoordinator, NeedsDependency {
	var dependencies: AppDependency? {
		didSet { updateChildCoordinatorDependencies() }
	}

	override init(rootViewController: UINavigationController? = nil) {
		let nc = rootViewController ?? UINavigationController()
		super.init(rootViewController: nc)

		nc.delegate = self
	}

	//	Declaration of all local pages (ViewControllers)

	enum Page {
		case login
		case register
		case profile
		case orders
	}
	var page: Page = .profile

	func display(page: Page) {
		rootViewController.parentCoordinator = self
		rootViewController.delegate = self

		setupActivePage(page)
	}

	func present(page: Page, from controller: UIViewController) {
		setupActivePage(page)
		controller.present(rootViewController, animated: true, completion: nil)
	}

	//	Coordinator lifecycle

	override func start(with completion: @escaping () -> Void = {}) {
		super.start(with: completion)
	}

	override func stop(with completion: @escaping () -> Void) {
		rootViewController.dismiss(animated: true) {
			completion()
		}
	}



	//	MARK:- Coordinating Messages

//	override func accountDismiss(queue: OperationQueue, sender: Any?) {
//		parent?.coordinatorDidFinish(self)
//	}
}

private extension AccountCoordinator {
	//	MARK:- Internal

	func setupActivePage(_ enforcedPage: Page? = nil) {
		let p = enforcedPage ?? page
		page = p

		switch p {
		default:
			break
		}
	}
}


