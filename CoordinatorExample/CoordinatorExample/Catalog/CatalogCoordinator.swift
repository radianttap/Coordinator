//
//  CatalogCoordinator.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 16.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation
import Coordinator

final class CatalogCoordinator: NavigationCoordinator, NeedsDependency {
	var dependencies: AppDependency? {
		didSet { updateChildCoordinatorDependencies() }
	}

	//	Declaration of all local pages (ViewControllers)

	enum Page {
		case home
//		case categories
		case product(Product)
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
	//	must be placed here, due to current Swift/ObjC limitations

	override func showProduct(_ product: Product, sender: Any?) {
		setupActivePage( .product(product) )
	}

	override func fetchPromotedProducts(sender: Any?, completion: @escaping ([Product], Error?) -> Void) {
		guard let manager = dependencies?.catalogManager else {
			completion( [], nil )
			return
		}
		manager.promotedProducts(callback: completion)
	}

	override func fetchProductCategories(season: Season?, sender: Any?, completion: @escaping ([Category], Error?) -> Void) {
		guard let manager = dependencies?.catalogManager else {
			completion( [], nil )
			return
		}
		manager.categories(for: season, callback: completion)
	}

	override func fetchActiveSeason(sender: Any?, completion: @escaping (Season?, Error?) -> Void) {
		guard let manager = dependencies?.catalogManager else {
			completion( nil, nil )
			return
		}
		completion(manager.activeSeason, nil)
	}
}

fileprivate extension CatalogCoordinator {
	func setupActivePage(_ enforcedPage: Page? = nil) {
		let p = enforcedPage ?? page

		switch p {
		case .home:
			let vc = HomeController.instantiate(fromStoryboardNamed: UIStoryboard.Name.app)
			vc.season = dependencies?.catalogManager?.activeSeason
			root(vc)

		case .product(let product):
			let vc = ProductViewController.instantiate(fromStoryboardNamed: UIStoryboard.Name.app)
			vc.product = product
			show(vc)
		}
	}
}
