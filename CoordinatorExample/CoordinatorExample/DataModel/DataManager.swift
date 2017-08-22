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
	func fetchProducts(callback: @escaping (Set<Season>, DataError?) -> Void) {
		let path = IvkoService.Path.products
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
				let products: Set<Product> = try result.value(for: "products")
				let seasons: Set<Season> = try result.value(for: "products")
				let themes: Set<Theme> = try result.value(for: "products")
				let categories: Set<Category> = try result.value(for: "products")

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

				callback( seasons, nil )
			} catch let marshalErr {
				callback( [], DataError.marshalError(marshalErr as! MarshalError) )
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

