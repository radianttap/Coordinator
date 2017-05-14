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
	var desc: String?
	var imagePath: String?
	var price: Price?

	var materials: [String] = []

	weak var category: Category?
	weak var collection: Collection?

	init(name: String) {
		self.name = name
	}
}
