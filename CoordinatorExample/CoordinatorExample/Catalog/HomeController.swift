//
//  HomeController.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 14.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import UIKit
import SwiftyTimer

final class HomeController: UIViewController, StoryboardLoadable {

	//	UI Outlets

	@IBOutlet fileprivate weak var collectionView: UICollectionView!
	@IBOutlet fileprivate weak var notificationContainer: UIView!

	//	Local data model

	var season: Season? {
		didSet {
			if !self.isViewLoaded { return }
			updateData()
		}
	}

	var promotedProducts: [Product] = [] {
		didSet {
			if !self.isViewLoaded { return }
//			collectionView.reloadSections( IndexSet(integer: LayoutSection.promotions.rawValue) )
			collectionView.reloadData()
		}
	}
	var categories: [Category] = [] {
		didSet {
			if !self.isViewLoaded { return }
//			collectionView.reloadSections( IndexSet(integer: LayoutSection.promotions.rawValue) )
			collectionView.reloadData()
		}
	}


	//	Timers

	var timer: Timer?
}

//	MARK: View lifecycle
extension HomeController {
	override func viewDidLoad() {
		super.viewDidLoad()

		setupTitleView()
		collectionView.register(PromoContainerCell.self)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		if automaticallyAdjustsScrollViewInsets {
			collectionView.contentInset.top = topLayoutGuide.length
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		updateData()
	}

	fileprivate func setupTitleView() {
		self.navigationItem.titleView = {
			return UIImageView(image: UIImage(named: "ivko_woman"))
		}()
		self.navigationItem.titleView?.sizeToFit()
	}
}


fileprivate extension HomeController {
	///	This is the heart of the approach that isolates VCs from the rest of the app.
	///
	///	Each VC will always use only its local data model and care about nothing else.
	///	Local model is populated either directly from outside (DI) or
	///	by using `coordinatingResponder` messages with completion handler.
	///
	///	Note the use of `[weak self]`. 
	///	VCs should not care where data come from, thus
	///	they will potentially be fetched from the (slow?) network, meaning
	///	customer can decide to move away from this VC which could then be deallocated.
	///	Hence you need to use `weak self` to avoid crashing your app
	func updateData() {

		fetchPromotedProducts(sender: self) {
			[weak self] arr, _ in
			guard let `self` = self else { return }

			DispatchQueue.main.async {
				self.promotedProducts = arr
			}
		}

		//	this below could probably be done way better

		guard let season = season else {
			self.categories = []

			fetchActiveSeason(sender: self, completion: {
				[weak self] s, error in
				guard let `self` = self else { return }
				DispatchQueue.main.async {
					if let s = s {
						self.season = s
						return
					}

					//	try again in half a sec
					self.timer = Timer.after(0.5, {
						[weak self] in
						self?.updateData()
					})
				}
			})
			return
		}

		fetchProductCategories(season: season, sender: self) {
			[weak self] arr, _ in
			guard let `self` = self else { return }

			DispatchQueue.main.async {
				self.categories = arr
			}
		}
	}

}



//	MARK: UICollectionViewDataSource
extension HomeController: UICollectionViewDataSource {
	fileprivate enum LayoutSection: Int {
		case promotions
		case categories

		static let count = 2
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return LayoutSection.count
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard let ls = LayoutSection(rawValue: section) else { fatalError("Unhandled section") }

		switch ls {
		case .promotions:
			return promotedProducts.count == 0 ? 0 : 1
		case .categories:
			return categories.count
		}
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let ls = LayoutSection(rawValue: indexPath.section) else { fatalError("Unhandled section") }

		switch ls {
		case .promotions:
			let cell: PromoContainerCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
			cell.promotedProducts = promotedProducts
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
		guard let ls = LayoutSection(rawValue: indexPath.section) else { fatalError("Unhandled section") }
		guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { fatalError("Wrong CV Layout") }

		var size = layout.itemSize

		switch ls {
		case .promotions:
			if promotedProducts.count == 0 { return .zero }
			let w2h: CGFloat = 1.8
			size.width = collectionView.bounds.size.width
			size.height = size.width / w2h

		case .categories:
			if categories.count == 0 { return .zero }
			let w2h = size.width / size.height
			size.width = max( (collectionView.bounds.size.width - 2) / 3, 0 )
			size.height = size.width / w2h
		}

		return size
	}
}
