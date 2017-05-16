//
//  ApplicationCoordinator.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 4.3.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import UIKit
import Coordinator

final class ApplicationCoordinator: Coordinator<UINavigationController>, Dependable {
	var dependencies: AppDependency? {
		didSet {
			self.childCoordinators.forEach { (_, coordinator) in
				if let c = coordinator as? Dependable {
					c.dependencies = dependencies
				}
			}
		}
	}

	required init(rootViewController: UINavigationController? = nil) {
		let nc: UINavigationController = rootViewController ?? UINavigationController()
		super.init(rootViewController: nc)

		nc.parentCoordinator = self
	}

	override func start(with completion: @escaping Coordinator<Any>.Callback = {_ in}) {
		//	this is top-level, it should 
		//	keep references to shared objects (Managers)

		dependencies = AppDependency()

		//	now, here comes the logic what 
		//	content Coordinator to load

		loadCatalog()

		completion(self)
	}
}


fileprivate extension ApplicationCoordinator {
	func loadCatalog() {
		let cc = CatalogCoordinator(rootViewController: rootViewController)
		cc.dependencies = dependencies
		startChild(coordinator: cc)
	}
}
