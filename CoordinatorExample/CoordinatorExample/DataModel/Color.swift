//
//  Color.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 15.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation

struct Color {
	var name: String
	var code: Int
}

extension Color {
	static let c18: Color = {
		return Color(name: "Black", code: 18)
	}()
}
