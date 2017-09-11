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
	init(colorCode: Int) throws {
		switch colorCode {
		case 11: self = Color.c11
		case 18: self = Color.c18
		case 19: self = Color.c19
		case 25: self = Color.c25
		case 29: self = Color.c29
		case 35: self = Color.c35
		case 39: self = Color.c39
		case 40: self = Color.c40
		case 69: self = Color.c69
		case 72: self = Color.c72
		default:
			throw DataError.unknownColorCode(colorCode)
		}
	}


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

extension Color: Equatable {
	static func ==(lhs: Color, rhs: Color) -> Bool {
		return lhs.code == rhs.code
	}
}




//	Boxing pure Swift type into Objective-C friendly form

class ColorBox: NSObject {
	let unbox: Color
	init(_ value: Color) {
		self.unbox = value
	}
}

extension Color {
	var boxed: ColorBox { return ColorBox(self) }
}
