//
//  DataManager.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 14.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation
import Marshal

final class DataManager {
	let apiManager: IvkoService

	init(apiManager: IvkoService) {
		self.apiManager = apiManager

		//	apply configuration
		//	setup in-memory data cache
		//	cleanup stale data
	}
}


extension DataManager {
	func fetchProducts(callback: @escaping (Set<Season>, Set<Category>, DataError?) -> Void) {
		let path = IvkoService.Path.products
		apiManager.call(path: path) {
			json, serviceError in

			if let serviceError = serviceError {
				callback( [], [], DataError.ivkoServiceError(serviceError) )
				return
			}
			guard let result = json else {
				callback( [], [], DataError.missingData )
				return
			}

			do {
				let products: Set<Product> = try result.value(for: "products")

				let jsonObjects: [JSON] = try result.value(for: "products")

				var seasonNames: Set<String> = Set(jsonObjects.flatMap({ try? $0.value(for: "season") }))
				let jsonSeasons: [JSON] = jsonObjects.reduce([], { cur, obj in
					guard let s: String = try? obj.value(for: "season") else { return cur }
					if !seasonNames.contains(s) { return cur }
					seasonNames.remove(s)
					return cur + [obj]
				})
				let seasons: Set<Season> = try ["wrap": jsonSeasons].value(for: "wrap")

				var themeNames: Set<String> = Set(jsonObjects.flatMap({ try? $0.value(for: "theme") }))
				let jsonThemes: [JSON] = jsonObjects.reduce([], { cur, obj in
					guard let s: String = try? obj.value(for: "theme") else { return cur }
					if !themeNames.contains(s) { return cur }
					themeNames.remove(s)
					return cur + [obj]
				})
				let themes: Set<Theme> = try ["wrap": jsonThemes].value(for: "wrap")

				var categoryNames: Set<String> = Set(jsonObjects.flatMap({ try? $0.value(for: "category") }))
				let jsonCategories: [JSON] = jsonObjects.reduce([], { cur, obj in
					guard let s: String = try? obj.value(for: "category") else { return cur }
					if !categoryNames.contains(s) { return cur }
					categoryNames.remove(s)
					return cur + [obj]
				})
				let categories: Set<Category> = try ["wrap": jsonCategories].value(for: "wrap")

				categories.forEach({ c in
					c.products = Set(products.filter({ $0.categoryName == c.name }))
					c.products.forEach({ $0.category = c })
				})

				themes.forEach({ t in
					t.products = Set(products.filter({ $0.themeCode == t.id }))
					t.products.forEach({ $0.theme = t })
				})

				seasons.forEach({ s in
					s.themes = Set(themes.filter({ $0.seasonCode == s.id }))
					s.themes.forEach({ $0.season = s })
				})

				callback( seasons, categories, nil )
			} catch let marshalErr {
				callback( [], [], DataError.marshalError(marshalErr as! MarshalError) )
			}
		}
	}

	func fetchPromotedProducts(callback: @escaping ([Product], DataError?) -> Void) {
		let path = IvkoService.Path.promotions
		apiManager.call(path: path) {
			json, serviceError in

			if let serviceError = serviceError {
				callback( [], DataError.ivkoServiceError(serviceError) )
				return
			}
			guard let result = json else {
				callback( [], DataError.missingData )
				return
			}

			do {
				let wrapper = ["wrap": result]
				let products: [Product] = try wrapper.value(for: "wrap")
				callback( products, nil )
			} catch let marshalErr {
				callback( [], DataError.marshalError(marshalErr as! MarshalError) )
			}
		}
	}
}

