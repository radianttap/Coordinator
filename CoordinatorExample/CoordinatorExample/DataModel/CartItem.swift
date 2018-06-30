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
