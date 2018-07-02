//
//  PromoCell.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 14.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import UIKit
import Kingfisher

final class PromoCell: UICollectionViewCell, NibReusableView {

	@IBOutlet private weak var photoView: UIImageView!
	@IBOutlet private weak var nameLabel: UILabel!
	@IBOutlet private weak var categoryLabel: UILabel!
	@IBOutlet private weak var descLabel: UILabel!

	private var product: Product?
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

		if let url = product.promoImageURL {
			photoView.kf.setImage(with: url)
		}

		nameLabel.text = product.name
		categoryLabel.text = product.category?.name.localizedUppercase
		descLabel.text = product.desc
	}
}

private extension PromoCell {
	@IBAction func didTapBuyNow(_ sender: UIButton) {
		guard let product = product else { return }

		cartBuyNow(product, sender: self)
	}
}
