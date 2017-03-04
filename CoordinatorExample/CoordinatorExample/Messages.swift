//
//  Messages.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 4.3.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation
import Coordinator

extension Coordinable {

	func greet(_ p: Person) {
		print(String(describing: self))

		coordinatingResponder?.greet(p)
	}

	func find(_ p: Place) {
		print(String(describing: self))

		coordinatingResponder?.find(p)
	}

	func go(_ d: Direction) {
		print(String(describing: self))

		coordinatingResponder?.go(d)
	}
}

