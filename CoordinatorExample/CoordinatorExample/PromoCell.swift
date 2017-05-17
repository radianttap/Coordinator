//
//  PromoCell.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 14.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import UIKit

final class PromoCell: UICollectionViewCell, NibReusableView {

	@IBOutlet fileprivate weak var photoView: UIImageView!
	@IBOutlet fileprivate weak var nameLabel: UILabel!
	@IBOutlet fileprivate weak var categoryLabel: UILabel!
	@IBOutlet fileprivate weak var descLabel: UILabel!

	fileprivate var product: Product?
}

extension PromoCell {

	override func awakeFromNib() {
		super.awakeFromNib()

		cleanup()
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		cleanup()
	}

	private func cleanup() {
		photoView.image = nil
		nameLabel.text = nil
		categoryLabel.text = nil
		descLabel.text = nil
	}

	func configure(with product: Product) {
		self.product = product

		if let path = product.promoImagePath {
			photoView.image = UIImage(named: path)
		}

		nameLabel.text = product.name
		categoryLabel.text = product.category?.name.localizedUppercase
		descLabel.text = product.desc
	}
}

fileprivate extension PromoCell {
	@IBAction func didTapBuyNow(_ sender: UIButton) {
//		guard let product = product else { return }

		
	}
}
