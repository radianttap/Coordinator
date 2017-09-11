//
//  Product.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 13.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation
import Marshal

final class Product: NSObject {
	let name: String
	let styleCode: String

	let categoryName: String

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
	weak var season: Season?
	weak var assetManager: AssetManager?

	init(name: String, styleCode: String, categoryName: String) {
		self.name = name
		self.styleCode = styleCode
		self.categoryName = categoryName
	}

	init(object: MarshaledObject) throws {
		name = try object.value(for: "name")
		styleCode = try object.value(for: "style")
		categoryName = try object.value(for: "category")

		desc = try? object.value(for: "desc")
		price = try? object.value(for: "price")
		careInstructions = try? object.value(for: "care")

		if let arr: [String] = try? object.value(for: "materials") {
			materials = arr
		}
		if let arr: [Int] = try? object.value(for: "colors") {
			colors = try arr.flatMap({ try Color(colorCode: $0) })
		}

		promoImagePath = try? object.value(for: "promoImage")
		gridImagePath = try? object.value(for: "gridImage")
		imagePaths = (try? object.value(for: "images")) ?? []
	}
}

extension Product: Unmarshaling {}

extension Product {
	var seasonCode: String {
		return styleCode.substring(to: Season.styleCodeIndex)
	}

	var themeCode: String {
		return styleCode.substring(to: Theme.styleCodeIndex)
	}

	var promoImageURL: URL? {
		guard let path = promoImagePath else { return nil }
		return assetManager?.url(forPromoPath: path)
	}

	var gridImageURL: URL? {
		guard let path = gridImagePath ?? imagePaths.first else { return nil }
		return assetManager?.url(forProductPath: path)
	}

	var imageURLs: [URL] {
		return imagePaths.flatMap({ assetManager?.url(forProductPath: $0) })
	}

	var heroURL: URL? {
		return imageURLs.first ?? gridImageURL ?? promoImageURL
	}
}

