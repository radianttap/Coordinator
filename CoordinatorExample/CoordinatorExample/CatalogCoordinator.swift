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

	//	UINavigationControllerDelegate
	//	must be here, due to current Swift/ObjC limitations

	func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
		//	check if customer has pop-ed back
		//	so update your internal state, if needed
	}
}

fileprivate extension CatalogCoordinator {
	func loadHome() {
		let vc = HomeController.instantiate(fromStoryboardNamed: UIStoryboard.Name.app)
		vc.dependencies = dependencies
		rootViewController.show(vc, sender: self)
	}
}
