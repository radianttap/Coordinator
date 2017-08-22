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
	func fetchProducts(callback: @escaping ([Product], DataError?) -> Void) {
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
				let products: [Product] = try result.value(for: "products")
				callback( products, nil )
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

