//
//  Season.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 13.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation
import Marshal

final class Season: NSObject {
	let id: String
	let name: String

	var themes: Set<Theme> = []

	init(name: String, id: String) {
		self.name = name
		self.id = id
	}

	init(object: MarshaledObject) throws {
		name = try object.value(for: "season")

		if let styleCode: String = try? object.value(for: "style") {
			self.id = styleCode.substring(to: String.Index(encodedOffset: 2) )
		} else {
			throw MarshalError.keyNotFound(key: "id|styleCode")
		}
	}
}

extension Season: Unmarshaling {}

extension Season {
	static var styleCodeIndex: String.Index { return String.Index(encodedOffset: 2) }

	var orderedThemes: [Theme] {
		return themes.sorted(by: { $0.id < $1.id })
	}

	var categories: Set<Category> {
		return Set(products.flatMap({ $0.category }))
	}

	var orderedCategories: [Category] {
		return categories.sorted(by: { $0.name < $1.name })
	}

	var products: [Product] {
		return themes.flatMap({ $0.products })
	}

	var orderedProducts: [Product] {
		return products.sorted(by: { $0.styleCode < $1.styleCode })
	}
}
