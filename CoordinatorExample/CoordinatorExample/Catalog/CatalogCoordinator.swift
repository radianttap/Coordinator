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

	override init(rootViewController: UINavigationController?) {
		guard let nc = rootViewController else { fatalError("Must supply root VC") }
		super.init(rootViewController: nc)

		nc.parentCoordinator = self
		nc.delegate = self
	}

	override func start(with completion: @escaping (Coordinator<UINavigationController>) -> Void = {_ in}) {
		//	here comes the logic what's the
		//	initial VC to display for the Catalog

		loadHome()

		super.start(with: completion)
	}

	//	UIResponder actions
	//	must be placed here, due to current Swift/ObjC limitations

	override func showProduct(_ product: Product, sender: Any?) {
		loadProduct(product)
	}

	override func fetchPromotedProducts(sender: Any?, completion: @escaping ([Product], Error?) -> Void) {
		guard let dataManager = dependencies?.dataManager else { fatalError("Missing DataManager instance") }

		completion( dataManager.promotedProducts, nil )
	}

	override func fetchProductCategories(season: Season, sender: Any?, completion: @escaping ([Category], Error?) -> Void) {
		guard let dataManager = dependencies?.dataManager else { fatalError("Missing DataManager instance") }

		completion( dataManager.productCategories(season: season), nil )
	}

	//	UINavigationControllerDelegate
	//	must be here, due to current Swift/ObjC limitations

	func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
		//	check if customer has pop-ed back
		//	so update your internal state, if needed
		//	like an array of controllers this Coordinator keeps
	}
}

fileprivate extension CatalogCoordinator {
	///	Shows Home VC
	func loadHome() {
		guard let dataManager = dependencies?.dataManager else { fatalError("Missing DataManager instance") }

		let vc = HomeController.instantiate(fromStoryboardNamed: UIStoryboard.Name.app)
		vc.season = dataManager.activeSeason
		rootViewController.show(vc, sender: self)
	}

	///	Shows Detail Product VC, for provided product
	func loadProduct(_ product: Product) {
		let vc = ProductViewController.instantiate(fromStoryboardNamed: UIStoryboard.Name.app)
		vc.product = product
		rootViewController.show(vc, sender: self)
	}
}
