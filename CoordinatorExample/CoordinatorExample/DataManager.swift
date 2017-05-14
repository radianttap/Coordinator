//
//  DataManager.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 14.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation

protocol UsesDataManager {
	var dataManager: DataManager { get }
}


//	General Data handler
final class DataManager {

	fileprivate(set) var seasons: [Season] = []

	init() {
		loadProducts()
	}
}


fileprivate extension DataManager {
	func loadProducts() {
		//	populate data source, so there's something for the rest of the app to use

		let season = Season(name: "Spring/Summer 2017")

		let categoryNames = ["Coat", "Dress", "Long Jacket", "Blouse/Top", "Pants", "Cardigan", "Skirt", "Pullover", "Jacket", "Top", "Pullwarmer", "Scarf", "Tunic"]
		let categories: [Category] = categoryNames.map({ Category(name: $0) })

		let themeNames = ["Mad Huts", "The Power of Flowers", "Guatemala", "Balkan Fusion"]
		let themes: [Theme] = themeNames.map({ Theme(name: $0) })

		season.categories = categories
		season.themes = themes

		seasons = [season]

		//	products
	}
}
