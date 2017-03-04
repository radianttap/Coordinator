//
//  DataModel.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 4.3.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation


class Person {
	let name: String
	init(name: String) {
		self.name = name
	}
}

struct Place {
	let name: String
}

enum Direction {
	case south
	case north
}

class PersonObjc: NSObject {
	let name: String
	init(name: String) {
		self.name = name
	}
}

class PersonBox: NSObject {
	let unbox: Person
	init(_ value: Person) {
		self.unbox = value
	}
}

