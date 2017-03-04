//
//  Helpers.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 4.3.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import UIKit


extension UIViewController {
	func embed<T>(controller vc: T, into parentView: UIView?)
		where T: UIViewController
	{
		let container = parentView ?? self.view!

		addChildViewController(vc)
		container.addSubview(vc.view)
			vc.view.translatesAutoresizingMaskIntoConstraints = false
			vc.view.edges(to: container)
		vc.didMove(toParentViewController: self)
	}

	func unembed(controller: UIViewController?) {
		guard let controller = controller else { return }

		controller.willMove(toParentViewController: nil)
		if controller.isViewLoaded {
			controller.view.removeFromSuperview()
		}
		controller.removeFromParentViewController()
	}
}

