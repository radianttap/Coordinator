//
//  Price.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 13.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation

class Price {
	let product: Product

	let currencyCode: String
	var wholesalePrice: Decimal?
	var retailPrice: Decimal?

	init(product: Product, currencyCode: String = "EUR", wholesalePrice: Decimal? = nil, retailPrice: Decimal? = nil) {
		self.product = product
		self.currencyCode = currencyCode
		self.wholesalePrice = wholesalePrice
		self.retailPrice = retailPrice
	}
}
