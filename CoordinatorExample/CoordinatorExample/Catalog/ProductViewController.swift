//
//  ProductViewController.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 17.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import UIKit

final class ProductViewController: UIViewController, StoryboardLoadable {

	//	UI Outlets

	@IBOutlet private weak var mainPhotoView: UIImageView!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var cartBarItem: UIBarButtonItem!

	//	Local data model

	var product: Product? {
		didSet {
			if !self.isViewLoaded { return }
			self.populate()
		}
	}

	var color: Color?

	var numberOfCartItems: Int? {
		didSet {
			if !self.isViewLoaded { return }
			renderCartStatus()
		}
	}
}


extension ProductViewController {
	//	MARK: Actions

	@IBAction func cartTapped(_ sender: UIBarButtonItem) {
		cartToggle(sender: self)
	}

	@IBAction func addTapped(_ sender: UIButton) {
		guard let product = product, let color = color else { return }
		cartAdd(product: product, color: color.boxed, sender: sender) {
			[weak self] _, num in
			guard let self = self else { return }
			self.numberOfCartItems = num
		}
	}

	//	MARK: View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		populate()
		renderCartStatus()

		//	HACK: setup default color
		//	for the demos to work.
		//	TODO: add UI to choose colors
		color = Color.c18
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		updateCartStatus()
	}
}


private extension ProductViewController {
	//	MARK: Data updates

	func updateCartStatus() {
		cartStatus(sender: self) {
			[weak self] num in
			guard let self = self else { return }

			DispatchQueue.main.async {
				self.numberOfCartItems = num
			}
		}
	}


	//	MARK: Internal

	func populate() {
		guard let product = product else { return }

		titleLabel.text = product.name

		if let url = product.heroURL {
			mainPhotoView.kf.setImage(with: url)
		}
	}

	func renderCartStatus() {
		guard let numberOfCartItems = numberOfCartItems, numberOfCartItems > 0 else {
			self.cartBarItem.setBadge(text: nil)
			return
		}
		self.cartBarItem.setBadge(text: "\( numberOfCartItems )")
	}
}
