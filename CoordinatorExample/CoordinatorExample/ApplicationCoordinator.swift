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



}
