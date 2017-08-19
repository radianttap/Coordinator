//
//  Product.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 13.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation

final class Product: NSObject {
	let name: String
	let styleCode: String

	var desc: String?
	var price: Price?
	var careInstructions: String?

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
