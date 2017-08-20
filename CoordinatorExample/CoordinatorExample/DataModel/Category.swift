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

	var products: [Product] = []

	init(name: String) {
		self.name = name
	}

	init(object: MarshaledObject) throws {
		name = try object.value(for: "name")

		if let arr: [Product] = try? object.value(for: "products") {
			products = arr
		}
	}
}

extension Category: Unmarshaling {}
