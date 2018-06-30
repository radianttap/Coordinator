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
	@objc dynamic func cartBuyNow(_ product: Product, sender: Any?) {
		coordinatingResponder?.cartBuyNow(product, sender: sender)
	}

	///	Adds given Product to the cart
	@objc dynamic func cartAdd(product: Product, color: ColorBox, sender: Any?, completion: @escaping (Bool, Int) -> Void) {
		coordinatingResponder?.cartAdd(product: product, color: color, sender: sender, completion: completion)
	}

	///	Removes a particular CartItem from the shopping cart
	@objc dynamic func cartRemove(item: CartItemBox, sender: Any?, completion: @escaping (Bool) -> Void) {
		coordinatingResponder?.cartRemove(item: item, sender: sender, completion: completion)
	}

	///	show/hide the cart
	@objc dynamic func cartToggle(sender: Any?) {
		coordinatingResponder?.cartToggle(sender: sender)
	}

	@objc dynamic func cartStatus(sender: Any?, completion: @escaping (Int) -> Void) {
		coordinatingResponder?.cartStatus(sender: sender, completion: completion)
	}
}
