//
//  Collection.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 13.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation
import Marshal

final class Theme: NSObject {
	let id: String
	let name: String

	var products: [Product] = []

	init(name: String, id: String) {
		self.name = name
		self.id = id
	}

	init(object: MarshaledObject) throws {
		id = try object.value(for: "id")
		name = try object.value(for: "name")

		if let arr: [Product] = try? object.value(for: "products") {
			products = arr
		}
	}
}

extension Theme: Unmarshaling {}

