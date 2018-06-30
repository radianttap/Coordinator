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

	@IBOutlet private weak var catalogItem: UIBarButtonItem!

	var cartItems: [CartItem] = [] {
		didSet {
			if !isViewLoaded { return }
			processContentUpdate()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		processContentUpdate()
	}
}

private extension CartController {

	@IBAction func catalogItemTapped(_ sender: UIBarButtonItem) {
		catalogShowPage( CatalogCoordinator.Page.home.boxed, sender: self)
	}

	func processContentUpdate() {
		
	}
}
