//
//  Category.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 13.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation
import Marshal

final class Category: NSObject {
	var name: String

	var products: Set<Product> = []

	init(name: String) {
		self.name = name
	}

	init(object: MarshaledObject) throws {
		name = try object.value(for: "category")

		if let arr: [Product] = try? object.value(for: "products") {
			products = Set(arr)
		}
	}
}

extension Category: Unmarshaling {}

extension Category {
	var orderedProducts: [Product] {
		return products.sorted(by: { $0.styleCode < $1.styleCode })
	}
}
