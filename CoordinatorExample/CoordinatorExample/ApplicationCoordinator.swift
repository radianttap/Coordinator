//
//  ApplicationCoordinator.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 4.3.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import UIKit
import Coordinator

final class AppCoordinator: NavigationCoordinator, NeedsDependency {
	var dependencies: AppDependency? {
		didSet {
			updateChildCoordinatorDependencies()
			processQueuedMessages()
		}
	}



	//	AppCoordinator is root coordinator, top-level object in the UI hierarchy
	//	It keeps references to all the data source objects
	var dataManager: DataManager!
	var catalogManager: CatalogManager!
	var cartManager: CartManager!


	//	Declaration of all possible Coordinators
	//	== sections inside the app

	enum Section {
		case catalog(CatalogCoordinator.Page?)
		case cart(CartCoordinator.Page?)
		case account(AccountCoordinator.Page?)
	}
	var section: Section = .catalog(.home)



	//	Coordinator lifecycle

	override func start(with completion: @escaping () -> Void = {}) {
		//	prepare managers
		let apiManager = IvkoService.shared
		let assetManager = AssetManager.shared
		dataManager = DataManager(apiManager: apiManager, assetManager: assetManager)
		catalogManager = CatalogManager(dataManager: dataManager)
		cartManager = CartManager(dataManager: dataManager)

		dependencies = AppDependency(apiManager: apiManager,
		                             dataManager: dataManager,
		                             assetManager: assetManager,
		                             cartManager: cartManager,
		                             catalogManager: catalogManager)
		//	finally ready
		super.start(with: completion)

		//	now, here comes the logic which 
		//	content Coordinator to load
		setupActiveSection()
	}



	//	MARK:- CoordinatingResponder

	override func cartStatus(sender: Any?, completion: @escaping (Int) -> Void) {
		guard let cartManager = dependencies?.cartManager else {
			enqueueMessage { [unowned self] in
				self.cartStatus(sender: sender, completion: completion)
			}
			return
		}

		completion(cartManager.items.count)
	}

	override func cartBuyNow(_ product: Product, sender: Any?) {
		//	re-route to CartManager and/or CartCoordinator

		let ac = UIAlertController(title: nil, message: "cart-BuyNow", preferredStyle: .alert)
		ac.addAction( UIAlertAction(title: "OK", style: .default) )
		rootViewController.present(ac, animated: true)
	}

	override func cartAdd(product: Product, color: ColorBox, sender: Any?, completion: @escaping (Bool, Int) -> Void) {
		guard let cartManager = dependencies?.cartManager else {
			enqueueMessage { [unowned self] in
				self.cartAdd(product: product, color: color, sender: sender, completion: completion)
			}
			return
		}

		cartManager.add(product: product, color: color.unbox)
		completion(true, cartManager.items.count)
	}

	override func cartToggle(sender: Any?) {
		setupActiveSection( .cart(.home) )
	}

	override func catalogShowPage(_ page: CatalogPageBox, sender: Any?) {
		setupActiveSection( .catalog(page.unbox) )
	}
}


fileprivate extension AppCoordinator {
	//	MARK:- Internal

	func setupActiveSection(_ enforcedSection: Section? = nil) {
		if let enforcedSection = enforcedSection {
			section = enforcedSection
		}
		switch section {
		case .catalog(let page):
			showCatalog(page)
		case .cart(let page):
			showCart(page)
		case .account(let page):
			showAccount(page)
		}
	}

	func showCatalog(_ page: CatalogCoordinator.Page?) {
		let identifier = String(describing: CatalogCoordinator.self)
		//	if Coordinator is already created...
		if let c = childCoordinators[identifier] as? CatalogCoordinator {
			c.dependencies = dependencies
			//	just display this page
			if let page = page {
				c.display(page: page)
			}
			return
		}

		//	otherwise, create the coordinator and start it
		let c = CatalogCoordinator(rootViewController: rootViewController)
		c.dependencies = dependencies
		if let page = page {
			c.page = page
		}
		startChild(coordinator: c)
	}

	func showCart(_ page: CartCoordinator.Page?) {
		let identifier = String(describing: CartCoordinator.self)
		//	if Coordinator is already created...
		if let c = childCoordinators[identifier] as? CartCoordinator {
			c.dependencies = dependencies
			//	just display this page
			if let page = page {
				c.display(page: page)
			}
			return
		}

		//	otherwise, create the coordinator and start it
		let c = CartCoordinator(rootViewController: rootViewController)
		c.dependencies = dependencies
		if let page = page {
			c.page = page
		}
		startChild(coordinator: c)
	}

	func showAccount(_ page: AccountCoordinator.Page?) {
		let identifier = String(describing: AccountCoordinator.self)
		//	if Coordinator is already created...
		if let c = childCoordinators[identifier] as? AccountCoordinator {
			c.dependencies = dependencies
			//	just display this page
			if let page = page {
				c.present(page: page, from: rootViewController)
			}
			return
		}

		//	otherwise, create the coordinator and start it

		let c = AccountCoordinator()
		c.dependencies = dependencies
		startChild(coordinator: c)
		if let page = page {
			c.present(page: page, from: rootViewController)
		}
	}
}
