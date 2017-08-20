//
//  CatalogManager.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 20.8.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation

final class CatalogManager {
	private var dataManager: DataManager

	init(dataManager: DataManager) {
		self.dataManager = dataManager
	}

	fileprivate(set) var seasons: [Season] = []
	fileprivate(set) var themes: [Theme] = []
	fileprivate(set) var categories: [Category] = []
	fileprivate(set) var promotedProducts: [Product] = []
}

extension CatalogManager {
	func fetchProducts(for season: Season?, callback: @escaping ([Product], DataError?) -> Void) {

	}

	func fetchPromotedProducts(callback: @escaping ([Product], DataError?) -> Void) {

	}
}
