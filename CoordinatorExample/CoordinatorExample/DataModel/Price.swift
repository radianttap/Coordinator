//
//  Price.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 13.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation

struct Price {
	let currencyCode: String
	var wholesalePrice: Decimal?
	var retailPrice: Decimal?

	init(currencyCode: String = "EUR", wholesalePrice: Decimal? = nil, retailPrice: Decimal? = nil) {
		self.currencyCode = currencyCode
		self.wholesalePrice = wholesalePrice
		self.retailPrice = retailPrice
	}
}
