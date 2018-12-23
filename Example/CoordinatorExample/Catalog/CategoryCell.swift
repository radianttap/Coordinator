//
//  CategoryCell.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 14.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import UIKit
import Kingfisher

final class CategoryCell: UICollectionViewCell, ReusableView {
    
	@IBOutlet private weak var photoView: UIImageView!
	@IBOutlet private weak var nameLabel: UILabel!

	private var category: Category?
}


extension CategoryCell {

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
	}

	func configure(with category: Category) {
		self.category = category
		nameLabel.text = category.name

		guard let product = category.products.first else { return }
		if let url = product.gridImageURL {
			photoView.kf.setImage(with: url)
		}
	}
}
