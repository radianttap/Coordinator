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

	@IBOutlet fileprivate weak var mainPhotoView: UIImageView!
	@IBOutlet fileprivate weak var titleLabel: UILabel!

	//	Local data model

	var product: Product? {
		didSet {
			if !self.isViewLoaded { return }
			self.populate()
		}
	}
}


//	MARK: View lifecycle
extension ProductViewController {
	override func viewDidLoad() {
		super.viewDidLoad()

		populate()
	}
}


fileprivate extension ProductViewController {
	func populate() {
		guard let product = product else { return }

		titleLabel.text = product.name

		if let path = product.imagePaths.first {
			mainPhotoView.image = UIImage(named: path)
		}
	}
}
