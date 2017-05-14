//
//  HomeController.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 14.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import UIKit

final class HomeController: UIViewController, StoryboardLoadable {

	@IBOutlet fileprivate weak var collectionView: UICollectionView!
	@IBOutlet fileprivate weak var notificationContainer: UIView!
}

extension HomeController {
	override func viewDidLoad() {
		super.viewDidLoad()

		self.collectionView.register(ContainerCell.self)
	}
}

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
			return 1
		case .categories:
			return 10
		}
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let ls = LayoutSection(rawValue: indexPath.section)!
		switch ls {
		case .promotions:
			let cell: ContainerCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
			return cell

		case .categories:
			let cell: CategoryCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
			return cell
		}
	}
}


extension HomeController: UICollectionViewDelegateFlowLayout {

}
