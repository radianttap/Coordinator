//
//  EmbeddedController.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 4.3.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import UIKit

class EmbeddedController: UIViewController {

	@IBAction func tapped(_ sender: UIButton) {
		let p = Person(name: "Bella")
		coordinatingResponder?.greet(p)
	}
}
