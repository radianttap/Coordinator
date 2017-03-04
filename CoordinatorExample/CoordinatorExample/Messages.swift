//
//  Messages.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 4.3.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation
import Coordinator

extension UIResponder {

	func greet(_ p: Person) {
		print("\n\( String(describing: self) )")

		coordinatingResponder?.greet(p)
	}

	func find(_ p: Place) {
		print("\n\( String(describing: self) )")

		coordinatingResponder?.find(p)
	}

	func go(_ d: Direction) {
		print("\n\( String(describing: self) )")

		coordinatingResponder?.go(d)
	}


	func greet2(_ p: PersonObjc) {
		print("\n\( String(describing: self) )")

		coordinatingResponder?.greet2(p)
	}
	
	func greet3(_ p: PersonBox) {
		print("\n\( String(describing: self) )")

		coordinatingResponder?.greet3(p)
	}
	
}

