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

	var products: Set<Product> = []
	weak var season: Season?

	init(name: String, id: String) {
		self.name = name
		self.id = id
	}

	init(object: MarshaledObject) throws {
		name = try object.value(for: "theme")
		if let styleCode: String = try? object.value(for: "style") {
			self.id = styleCode.substring(to: String.Index(encodedOffset: 3) )
		} else {
			throw MarshalError.keyNotFound(key: "id|styleCode")
		}
	}
}

extension Theme: Unmarshaling {}

extension Theme {
	static var styleCodeIndex: String.Index { return String.Index(encodedOffset: 3) }

	var seasonCode: String {
		return id.substring(to: Season.styleCodeIndex)
	}

	var orderedProducts: [Product] {
		return products.sorted(by: { $0.styleCode < $1.styleCode })
	}
}
