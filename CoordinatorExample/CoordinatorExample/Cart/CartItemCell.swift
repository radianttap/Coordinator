//
//  CartItemCell.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 6/30/18.
//  Copyright © 2018 Radiant Tap. All rights reserved.
//

import UIKit

final class CartItemCell: UITableViewCell, ReusableView {
	@IBOutlet private weak var label: UILabel!
}

extension CartItemCell {
	override func awakeFromNib() {
		super.awakeFromNib()

		cleanup()
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		cleanup()
	}

	private func cleanup() {
		label.text = nil
	}

	func configure(with cartItem: CartItem) {
		label.text = cartItem.cartDescription
	}

}
