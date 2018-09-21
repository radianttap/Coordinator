//
//  ContainerCell.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 14.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import UIKit
import TinyConstraints
import SwiftyTimer

final class PromoContainerCell: UICollectionViewCell, ReusableView {
	//	UI outlets

	private lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0

		let cv = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
		cv.translatesAutoresizingMaskIntoConstraints = false
		cv.isPagingEnabled = true
		cv.backgroundColor = self.backgroundColor

		cv.dataSource = self
		cv.delegate = self
		cv.register(PromoCell.self)

		self.addSubview(cv)
		cv.edges(to: self)

		return cv
	}()

	//	Local data model

	var promotedProducts: [Product] = [] {
		didSet {
			collectionView.reloadData()
			setup()
		}
	}

	//	Timers

	var timer: Timer?
}

extension PromoContainerCell {
	override func prepareForReuse() {
		super.prepareForReuse()

		timer?.invalidate()
	}

	private func setup() {
		timer = Timer.every(3) {
			[weak self] in
			guard let self = self else { return }
			self.slide()
		}
	}

	private func slide() {
		let cv = self.collectionView

		let pagesCount = Int(cv.contentSize.width / cv.bounds.width)
		var page = Int(abs(cv.contentOffset.x / cv.bounds.width))
		page += 1
		if page >= pagesCount { page = 0 }

		let indexPath = IndexPath(item: page, section: 0)
		cv.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
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

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let promo = promotedProducts[indexPath.item]

		showProduct(promo, sender: self)
	}
}
