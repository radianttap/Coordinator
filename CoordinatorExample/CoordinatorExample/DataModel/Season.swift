//
//  Season.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 13.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation

class Season {
	var name: String

	var themes: [Theme] = []
	var categories: [Category] = []

	init(name: String) {
		self.name = name
	}
}
