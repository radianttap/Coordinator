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

	func bubbleC(_ c: ClassObject) {
		coordinatingResponder?.bubbleC(c)
	}

	func bubbleS(_ s: StructObject) {
		coordinatingResponder?.bubbleS(s)
	}

	func bubbleE(_ e: SomeEnum) {
		coordinatingResponder?.bubbleE(e)
	}
}

