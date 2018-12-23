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

	var cartItems: [CartItem] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		title = NSLocalizedString("Cart", comment: "")
	}
}

private extension CartController {

	@IBAction func catalogItemTapped(_ sender: UIBarButtonItem) {
		catalogShowPage( CatalogCoordinator.Page.home.boxed, sender: self)
	}

	func confirmItemRemoval(_ cartItem: CartItem, atIndexPath indexPath: IndexPath) {
		let m = String(format: NSLocalizedString("Are you sure you want to remove item: %@", comment: ""), cartItem.cartDescription)
		let ac = UIAlertController(title: NSLocalizedString("Confirm item removal", comment: ""),
								   message: m,
								   preferredStyle: .alert)
		let yes = UIAlertAction(title: NSLocalizedString("Yes, remove", comment: ""), style: .destructive) {
			[unowned self] _ in
			self.cartRemove(item: cartItem.boxed, sender: self) {
				_ in
				self.cartItems.remove(at: indexPath.row)
				self.tableView.deleteRows(at: [indexPath], with: .top)
			}
		}
		let no = UIAlertAction(title: NSLocalizedString("Nooooo!", comment: ""), style: .cancel)

		ac.addAction(yes)
		ac.addAction(no)

		present(ac, animated: true)
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

extension CartController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let deleteAction = UITableViewRowAction(style: .destructive, title: NSLocalizedString("Remove", comment: "")) {
			[weak self] action, indexPath in
			guard let self = self else { return }

			let cartItem = self.cartItems[indexPath.row]
			self.confirmItemRemoval(cartItem, atIndexPath: indexPath)
		}
		deleteAction.backgroundColor = .red

		return [deleteAction]
	}
}
