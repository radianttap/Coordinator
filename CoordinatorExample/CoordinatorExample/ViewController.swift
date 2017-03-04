//
//  ViewController.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 23.11.16..
//  Copyright © 2016. Radiant Tap. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet fileprivate weak var container: UIView!

	override func viewDidLoad() {
		super.viewDidLoad()

		let vc = EmbeddedController(nibName: nil, bundle: nil)
		embed(controller: vc, into: container)
	}
}

