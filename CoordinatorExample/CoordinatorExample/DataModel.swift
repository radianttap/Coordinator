//
//  DataModel.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 4.3.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation

//	pure Swift class
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

//	Objective-C subclass
class PersonObjc: NSObject {
	let name: String
	init(name: String) {
		self.name = name
	}
}


//	SOLUTION:
//	Boxing pure Swift type into Objective-C friendly form

class PersonBox: NSObject {
	let unbox: Person
	init(_ value: Person) {
		self.unbox = value
	}
}

extension Person {
	var boxed: PersonBox { return PersonBox(self) }
}

