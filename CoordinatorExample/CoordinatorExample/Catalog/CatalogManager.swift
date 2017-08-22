//
//  CatalogManager.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 20.8.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation

final class CatalogManager {
	fileprivate var dataManager: DataManager

	init(dataManager: DataManager) {
		self.dataManager = dataManager
	}

	fileprivate(set) var activeSeason: Season?
	fileprivate(set) var seasons: [Season] = []
	fileprivate(set) var themes: [Theme] = []
	fileprivate(set) var categories: [Category] = []
	fileprivate(set) var promotedProducts: [Product] = []
}

extension CatalogManager {
	//	MARK:- Public API
	//	These methods should be custom tailored to read specific data subsets,
	//	as required for specific views. These will be called by Coordinators,
	//	then routed into UIViewControllers

	func seasons(callback: @escaping ([Season], DataError?) -> Void) {

	}

	func categories(for season: Season?, callback: @escaping ([Category], DataError?) -> Void) {
		let s = season ?? activeSeason

	}

	func themes(for season: Season?, callback: @escaping ([Theme], DataError?) -> Void) {
		let s = season ?? activeSeason

	}

	func products(for season: Season?, callback: @escaping ([Product], DataError?) -> Void) {
		let s = season ?? activeSeason

	}

	func promotedProducts(callback: @escaping ([Product], DataError?) -> Void) {

	}
}


fileprivate extension CatalogManager {
	//	MARK:- Private API
	//	These are thin wrappers around DataManager‘s similarly named methods.
	//	They are used to process received data and splice and dice them as needed,
	//	into business logic that only CatalogManager knows about


	///	`Product` set comes from API as dense structure with information about the product itself,
	///	but also the season/theme/category it belongs to. Those are all parent relationships.
	///
	///	It‘s identifier is `styleCode`.
	///
	///	First two characters are code for season.
	///	Third character is code for (marketing) theme (or first 3 combined).
	///	The rest of the characters complete the product code.
	func fetchProducts(callback: @escaping ([Product], DataError?) -> Void) {
		dataManager.fetchProducts {
			[unowned self] arr, dataError in
			if let dataError = dataError {
				callback( [], dataError )
				return
			}


		}
	}
}
