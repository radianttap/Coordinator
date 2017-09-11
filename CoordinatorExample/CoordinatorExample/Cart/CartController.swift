//
//  CartController.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 11.9.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import UIKit

final class CartController: UIViewController, StoryboardLoadable {
	//	UI

	@IBOutlet fileprivate weak var catalogItem: UIBarButtonItem!
}

fileprivate extension CartController {

	@IBAction func catalogItemTapped(_ sender: UIBarButtonItem) {
		catalogShowPage( CatalogCoordinator.Page.home.boxed, sender: self)
	}
}
