//
//  Collection.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 13.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation

final class Theme: NSObject {
	var name: String

	var product: [Product] = []

	init(name: String) {
		self.name = name
	}
}
