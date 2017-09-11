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

		fetchProducts()
		fetchPromotions()
	}

	fileprivate(set) var activeSeason: Season?

	fileprivate(set) var seasons: Set<Season> = [] {
		didSet {
			if activeSeason == nil { activeSeason = orderedSeasons.first }
		}
	}

	fileprivate(set) var categories: Set<Category> = []

	fileprivate(set) var promotedProducts: [Product] = []

	fileprivate var lastUpdatedProducts: Date?
	fileprivate var lastUpdatedPromotions: Date?
}

extension CatalogManager {
	//	MARK:- Public API
	//	These methods should be custom tailored to read specific data subsets,
	//	as required for specific views. These will be called by Coordinators,
	//	then routed into UIViewControllers

	func seasons(callback: @escaping ([Season], CatalogError?) -> Void) {
		callback( orderedSeasons, nil )

		fetchProducts {
			[unowned self] _, catalogError in
			if let catalogError = catalogError {
				callback( self.orderedSeasons, catalogError )
				return
			}
			callback( self.orderedSeasons, nil )
		}
	}

	func categories(for season: Season?, callback: @escaping ([Category], CatalogError?) -> Void) {
		guard let s = season ?? activeSeason else {
			callback( [], .missingSeason )
			return
		}

		callback( s.orderedCategories, nil )

		fetchProducts {
			_, catalogError in
			if let catalogError = catalogError {
				callback( s.orderedCategories, catalogError )
				return
			}
			callback( s.orderedCategories, nil )
		}
	}

	func themes(for season: Season?, callback: @escaping ([Theme], CatalogError?) -> Void) {
		guard let s = season ?? activeSeason else {
			callback( [], .missingSeason )
			return
		}

		callback( s.orderedThemes, nil )

		fetchProducts {
			_, catalogError in
			if let catalogError = catalogError {
				callback( s.orderedThemes, catalogError )
				return
			}
			callback( s.orderedThemes, nil )
		}
	}

	func products(for season: Season?, theme: Theme?, callback: @escaping ([Product], CatalogError?) -> Void) {
		guard let s = season ?? activeSeason else {
			callback( [], .missingSeason )
			return
		}

		let products: [Product]
		if let theme = theme {
			products = theme.orderedProducts
		} else {
			products = s.orderedProducts
		}
		callback( products, nil )

		fetchProducts {
			_, catalogError in
			if let catalogError = catalogError {
				callback( products, catalogError )
				return
			}

			let products: [Product]
			if let theme = theme {
				products = theme.orderedProducts
			} else {
				products = s.orderedProducts
			}
			callback( products, nil )
		}
	}

	func promotedProducts(callback: @escaping ([Product], CatalogError?) -> Void) {
		callback( promotedProducts, nil )

		fetchPromotions {
			[unowned self] hasUpdates, catalogError in
			if !hasUpdates { return }

			if let catalogError = catalogError {
				callback( self.promotedProducts, catalogError )
				return
			}

			callback( self.promotedProducts, nil )
		}
	}
}


fileprivate extension CatalogManager {
	//	MARK:- Private API
	//	These are thin wrappers around DataManager‘s similarly named methods.
	//	They are used to process received data and splice and dice them as needed,
	//	into business logic that only CatalogManager knows about


	var orderedSeasons: [Season] {
		return seasons.sorted(by: { $0.id > $1.id })
	}


	///	`Product` set comes from API as dense structure with information about the product itself,
	///	but also the season/theme/category it belongs to. Those are all parent relationships.
	///
	///	It‘s identifier is `styleCode`.
	///
	///	First two characters are code for season.
	///	Third character is code for (marketing) theme (or first 3 combined).
	///	The rest of the characters complete the product code.
	///
	///	Fetch an update on app start + at least once every day.
	///
	///	Callback first param is `true` if data set is successfully refreshed.
	func fetchProducts(callback: @escaping (Bool, CatalogError?) -> Void = {_, _ in}) {
		if let lastUpdated = lastUpdatedProducts, lastUpdated.isLaterThan(date: Date().subtract(days: 1)) {
			callback(false, nil)
			return
		}

		lastUpdatedProducts = Date()

		dataManager.fetchProducts {
			[unowned self] seasons, cats, dataError in
			if let dataError = dataError {
				callback(false, .dataError(dataError))
				return
			}

			self.categories = cats
			self.seasons = seasons

			callback(true, nil)
		}
	}


	func fetchPromotions(callback: @escaping (Bool, CatalogError?) -> Void = {_, _ in}) {
		if let lastUpdated = lastUpdatedPromotions, lastUpdated.isLaterThan(date: Date().subtract(hours: 2)) {
			callback(false, nil)
			return
		}

		lastUpdatedPromotions = Date()

		dataManager.fetchPromotedProducts {
			[unowned self] arr, dataError in
			if let dataError = dataError {
				callback(false, .dataError(dataError))
				return
			}

			self.promotedProducts = arr
			callback(true, nil)
		}
	}
}
