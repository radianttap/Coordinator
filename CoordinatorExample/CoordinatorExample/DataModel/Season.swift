//
//  Season.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 13.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation
import Marshal

final class Season: NSObject {
	let id: String
	let name: String

	var themes: [Theme] = []
	var categories: [Category] = []

	init(name: String, id: String) {
		self.name = name
		self.id = id
	}

	init(object: MarshaledObject) throws {
		id = try object.value(for: "id")
		name = try object.value(for: "name")

		categories = try object.value(for: "categories")
		themes = try object.value(for: "themes")
	}
}

extension Season: Unmarshaling {}
