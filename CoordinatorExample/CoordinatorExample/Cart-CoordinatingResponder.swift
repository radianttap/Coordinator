//
//  Cart-CoordinatingResponder.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 17.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import UIKit


extension UIResponder {
	///	Adds given Product to the temporary cart and immediatelly shows Payment screen 
	func cartBuyNow(_ product: Product, sender: Any?) {
		coordinatingResponder?.cartBuyNow(product, sender: sender)
	}

	///	Adds given Product to the cart
	func cartAdd(product: Product, color: ColorBox, sender: Any?, completion: (Bool) -> Void) {
		coordinatingResponder?.cartAdd(product: product, color: color, sender: sender, completion: completion)
	}

	///	show/hide the cart
	func cartToggle(sender: Any?) {
		coordinatingResponder?.cartToggle(sender: sender)
	}
}
