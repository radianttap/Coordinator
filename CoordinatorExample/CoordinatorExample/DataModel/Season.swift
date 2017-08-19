//
//  Season.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 13.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation

final class Season: NSObject {
	let id: String
	let name: String

	var themes: [Theme] = []
	var categories: [Category] = []

	init(name: String, id: String) {
		self.name = name
		self.id = id
	}
}
