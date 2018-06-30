//
//  CartCoordinator.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 20.8.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation
import Coordinator

final class CartCoordinator: NavigationCoordinator, NeedsDependency {
	var dependencies: AppDependency? {
		didSet { updateChildCoordinatorDependencies() }
	}

	//	Declaration of all local pages (ViewControllers)

	enum Page {
		case home
		case payment
		case shipping
		case confirmation
		case status
	}
	var page: Page = .home

	func display(page: Page) {
		rootViewController.parentCoordinator = self
		rootViewController.delegate = self

		setupActivePage(page)
	}

	//	Coordinator lifecycle

	override func start(with completion: @escaping () -> Void = {}) {
		super.start(with: completion)

		setupActivePage()
	}




	//	MARK:- Coordinating Messages
	//	(must be placed here, due to current Swift/ObjC limitations)

	override func cartRemove(item: CartItemBox, sender: Any?, completion: @escaping (Bool) -> Void) {
		guard let cartManager = dependencies?.cartManager else {
			enqueueMessage {
				[weak self] in
				self?.cartRemove(item: item, sender: sender, completion: completion)
			}
			return
		}

		cartManager.remove(item: item.unbox)
		completion(true)
	}
}

fileprivate extension CartCoordinator {
	func setupActivePage(_ enforcedPage: Page? = nil) {
		let p = enforcedPage ?? page
		page = p

		switch p {
		case .home:
			let vc = CartController.instantiate(fromStoryboardNamed: UIStoryboard.Name.app)
			vc.cartItems = dependencies?.cartManager?.items ?? []
			root(vc)
		default:
			break
		}
	}
}
