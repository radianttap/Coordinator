//
//  HomeController.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 14.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import UIKit

final class HomeController: UIViewController, StoryboardLoadable {
	//	Dependencies

	typealias Dependencies = UsesDataManager
	var dependencies: Dependencies? {
		didSet {
			if !self.isViewLoaded { return }
			self.collectionView.reloadData()
		}
	}

	//	UI Outlets

	@IBOutlet fileprivate weak var collectionView: UICollectionView!
	@IBOutlet fileprivate weak var notificationContainer: UIView!

	//	Local data model

	fileprivate var promotedProducts: [Product] {
		guard let dataManager = dependencies?.dataManager else { return [] }

		return dataManager.promotedProducts
	}
	fileprivate var categories: [Category] {
		guard
			let dataManager = dependencies?.dataManager,
			let season = dataManager.seasons.first
		else { return [] }

		return season.categories
	}
}

//	MARK: View lifecycle
extension HomeController {
	override func viewDidLoad() {
		super.viewDidLoad()

		self.collectionView.register(PromoContainerCell.self)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		if self.automaticallyAdjustsScrollViewInsets {
			collectionView.contentInset.top = self.topLayoutGuide.length
		}
	}
}

//	MARK: UICollectionViewDataSource
extension HomeController: UICollectionViewDataSource {
	fileprivate enum LayoutSection: Int {
		case promotions
		case categories
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 2
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let ls = LayoutSection(rawValue: section)!
		switch ls {
		case .promotions:
			return promotedProducts.count == 0 ? 0 : 1
		case .categories:
			return categories.count
		}
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let ls = LayoutSection(rawValue: indexPath.section)!
		switch ls {
		case .promotions:
			let cell: PromoContainerCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
			cell.dependencies = dependencies
			return cell

		case .categories:
			let cell: CategoryCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
			let category = categories[indexPath.item]
			cell.configure(with: category)
			return cell
		}
	}
}


//	MARK: UICollectionViewDelegateFlowLayout
extension HomeController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let layout = collectionViewLayout as! UICollectionViewFlowLayout
		var size = layout.itemSize

		let ls = LayoutSection(rawValue: indexPath.section)!
		switch ls {
		case .promotions:
			if promotedProducts.count == 0 { return .zero }
			let w2h: CGFloat = 1.8
			size.width = collectionView.bounds.size.width
			size.height = size.width / w2h

		case .categories:
			if categories.count == 0 { return .zero }
			let w2h = size.width / size.height
			size.width = collectionView.bounds.size.width / 3
			size.height = size.width / w2h
		}

		return size
	}
}
