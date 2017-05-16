//
//  ContainerCell.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 14.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import UIKit
import TinyConstraints

final class PromoContainerCell: UICollectionViewCell, ReusableView {
	typealias Dependencies = UsesDataManager
	var dependencies: Dependencies? {
		didSet {
			collectionView.reloadData()
		}
	}

	fileprivate lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal

		let cv = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
		cv.translatesAutoresizingMaskIntoConstraints = false

		cv.dataSource = self
		cv.delegate = self
		cv.register(PromoCell.self)

		self.addSubview(cv)
		cv.edges(to: self)

		return cv
	}()

	fileprivate var promotedProducts: [Product] {
		guard let dataManager = dependencies?.dataManager else { return [] }

		return dataManager.promotedProducts
	}

	override func awakeFromNib() {
		super.awakeFromNib()

		collectionView.reloadData()
	}
}

//	MARK: UICollectionViewDataSource
extension PromoContainerCell: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return promotedProducts.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: PromoCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
		let promo = promotedProducts[indexPath.item]
		cell.configure(with: promo)
		return cell
	}
}


//	MARK: UICollectionViewDelegateFlowLayout
extension PromoContainerCell: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if promotedProducts.count == 0 { return .zero }
		return collectionView.bounds.size
	}
}
