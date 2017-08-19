//
//  ApplicationCoordinator.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 4.3.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import UIKit
import Coordinator

final class AppCoordinator: NavigationCoordinator {
	var dependencies: AppDependency? {
		didSet { updateChildCoordinatorDependencies() }
	}


	override init(rootViewController: UINavigationController? = nil) {
		let nc: UINavigationController = rootViewController ?? UINavigationController()
		super.init(rootViewController: nc)

		nc.parentCoordinator = self
	}

	override func start(with completion: @escaping (Coordinator<UINavigationController>) -> Void = {_ in}) {
		//	this is top-level, it should 
		//	keep references to shared objects (Managers)

		dependencies = AppDependency()

		//	now, here comes the logic which 
		//	content Coordinator to load

		loadCatalog()

		super.start(with: completion)
	}

	//	UIResponder coordinating messages

	override func cartBuyNow(_ product: Product, sender: Any?) {
		//	re-route to CartManager and/or CartCoordinator

		let ac = UIAlertController(title: nil, message: "cart-BuyNow", preferredStyle: .alert)
		ac.addAction( UIAlertAction(title: "OK", style: .default) )
		rootViewController.present(ac, animated: true)
	}

	override func cartAdd(product: Product, color: ColorBox, sender: Any?, completion: (Bool) -> Void) {
		//	re-route to CartManager and/or CartCoordinator

		let ac = UIAlertController(title: nil, message: "cart-Add", preferredStyle: .alert)
		ac.addAction( UIAlertAction(title: "OK", style: .default) )
		rootViewController.present(ac, animated: true)
	}

	override func cartToggle(sender: Any?) {

		let ac = UIAlertController(title: nil, message: "cart-Toggle", preferredStyle: .alert)
		ac.addAction( UIAlertAction(title: "OK", style: .default) )
		rootViewController.present(ac, animated: true)
	}
}


fileprivate extension AppCoordinator {
	func loadCatalog() {
		let cc = CatalogCoordinator(rootViewController: rootViewController)
		cc.dependencies = dependencies
		startChild(coordinator: cc)
	}
}
