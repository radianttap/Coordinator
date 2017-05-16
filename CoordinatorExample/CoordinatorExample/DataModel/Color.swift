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
	static let c11: Color = {
		return Color(name: "Off-White", code: 11)
	}()
	static let c18: Color = {
		return Color(name: "Anthracite", code: 18)
	}()
	static let c19: Color = {
		return Color(name: "Black", code: 19)
	}()
	static let c25: Color = {
		return Color(name: "Beige", code: 25)
	}()
	static let c29: Color = {
		return Color(name: "Brown", code: 29)
	}()
	static let c35: Color = {
		return Color(name: "Blue", code: 35)
	}()
	static let c39: Color = {
		return Color(name: "Navy", code: 39)
	}()
	static let c40: Color = {
		return Color(name: "Powder", code: 40)
	}()
	static let c69: Color = {
		return Color(name: "Forest", code: 69)
	}()
	static let c72: Color = {
		return Color(name: "Pink", code: 72)
	}()
}
