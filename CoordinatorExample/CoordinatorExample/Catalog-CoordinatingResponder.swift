//
//  Catalog-CoordinatingResponder.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 17.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import UIKit

extension UIResponder {

	func showProduct(_ product: Product, sender: Any?) {
		coordinatingResponder?.showProduct(product, sender: sender)
	}

}
