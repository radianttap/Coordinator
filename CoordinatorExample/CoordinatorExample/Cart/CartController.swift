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
	@IBOutlet private weak var tableView: UITableView!

	//	Local data model

	var cartItems: [CartItem] = [] {
		didSet {
			if !isViewLoaded { return }
			processContentUpdate()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = NSLocalizedString("Cart", comment: "")
	}
}

private extension CartController {

	@IBAction func catalogItemTapped(_ sender: UIBarButtonItem) {
		catalogShowPage( CatalogCoordinator.Page.home.boxed, sender: self)
	}

	func processContentUpdate() {
		tableView.reloadData()
	}
}

extension CartController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cartItems.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: CartItemCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
		let cartItem = cartItems[indexPath.row]
		cell.configure(with: cartItem)
		return cell
	}
}

