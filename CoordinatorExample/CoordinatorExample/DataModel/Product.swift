//
//  Product.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 13.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation

class Product {
	var name: String
	var styleCode: String
	var desc: String?
	var price: Price?

	var materials: [String] = []
	var colors: [Color] = []

	var gridImagePath: String?
	var promoImagePath: String?
	var imagePaths : [String] = []

	weak var category: Category?
	weak var theme: Theme?

	init(name: String, styleCode: String) {
		self.name = name
		self.styleCode = styleCode
	}
}
