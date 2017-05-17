//
//  CatalogCoordinator.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 16.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation
import Coordinator

final class CatalogCoordinator: Coordinator<UINavigationController>, Dependable, UINavigationControllerDelegate {
	var dependencies: AppDependency? {
		didSet {
			self.childCoordinators.forEach { (_, coordinator) in
				if let c = coordinator as? Dependable {
					c.dependencies = dependencies
				}
			}
		}
	}

	required init(rootViewController: UINavigationController?) {
		guard let nc = rootViewController else { fatalError("Must supply root VC") }
		super.init(rootViewController: nc)

		nc.parentCoordinator = self
		nc.delegate = self
	}

	override func start(with completion: @escaping Coordinator<Any>.Callback = {_ in}) {
		//	here comes the logic what's the
		//	initial VC to display for the Catalog

		loadHome()

		completion(self)
	}

	//	UIResponder actions
	override func showProduct(_ product: Product, sender: Any?) {
		loadProduct(product)
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
		let vc = HomeController.instantiate(fromStoryboardNamed: UIStoryboard.Name.app)
		vc.dependencies = dependencies
		rootViewController.show(vc, sender: self)
	}

	///	Shows Detail Product VC, for provided product
	func loadProduct(_ product: Product) {
		let vc = ProductViewController.instantiate(fromStoryboardNamed: UIStoryboard.Name.app)
		vc.product = product
		rootViewController.show(vc, sender: self)
	}
}
