//
//  ApplicationCoordinator.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 4.3.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import UIKit
import Coordinator

final class ApplicationCoordinator: Coordinator<UINavigationController> {

	required init(rootViewController: UINavigationController?) {
		guard let nc = rootViewController else { fatalError("Must supply root VC") }

		super.init(rootViewController: nc)
		nc.parentCoordinator = self
	}




	//	this does not work, since it's pure Swift class
//	override func greet(_ p: Person) {
//		let ac = UIAlertController(title: nil, message: p.name, preferredStyle: .alert)
//		ac.addAction(UIAlertAction(title: "OK", style: .default))
//		rootViewController.present(ac, animated: true)
//	}

	
	//	this works, because it subclasses NSObject
	override func greet2(_ p: PersonObjc) {
		let ac = UIAlertController(title: nil, message: p.name, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		rootViewController.present(ac, animated: true)
	}
}
