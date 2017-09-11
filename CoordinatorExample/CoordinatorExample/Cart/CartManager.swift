//
//  CartManager.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 20.8.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation


final class CartManager {
	fileprivate var dataManager: DataManager

	init(dataManager: DataManager) {
		self.dataManager = dataManager
	}

	//	Local stuff

	fileprivate(set) var items: [CartItem] = []

	func add(product: Product, color: Color) {
		let item = CartItem(product: product, color: color)
		items.append(item)
	}

	func remove(product: Product, color: Color) {
		guard let index = items.index(where: { $0.product == product && $0.color == color }) else { return }
		items.remove(at: index)
	}

	func clear() {
		items.removeAll()
	}
}
