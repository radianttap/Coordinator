//
//  CartItem.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 11.9.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation

struct CartItem {
	var product: Product
	var color: Color
	var size: Size = .m
}

extension CartItem {
	init(product: Product, color: Color) {
		self.product = product
		self.color = color
	}

	var cartDescription: String {
		return "\( product.name ) · \( color.name ), size \( size )"
	}
}


//	Boxing pure Swift type into Objective-C friendly form

class CartItemBox: NSObject {
	let unbox: CartItem
	init(_ value: CartItem) {
		self.unbox = value
	}
}

extension CartItem {
	var boxed: CartItemBox { return CartItemBox(self) }
}
