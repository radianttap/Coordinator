//
//  EmbeddedController.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 4.3.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import UIKit

final class EmbeddedController: UIViewController {

	@IBAction func tapped(_ sender: UIButton) {
//		let p = Person(name: "Bella")
//		coordinatingResponder?.greet(p)
		let p = Person(name: "Bella")
		coordinatingResponder?.greet3(p.boxed)
	}

	@IBAction func tapped2(_ sender: UIButton) {
		let p = PersonObjc(name: "Oldie")
		coordinatingResponder?.greet2(p)
	}
}
