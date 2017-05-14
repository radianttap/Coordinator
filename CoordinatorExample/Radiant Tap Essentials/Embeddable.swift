//
//  Embeddable.swift
//  Radiant Tap Essentials
//
//  Created by Aleksandar Vacić on 11.9.16.
//  Copyright © 2016. Radiant Tap. All rights reserved.
//

import UIKit
import TinyConstraints

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

		//	Note: after this, save the controller reference
		//	somewhere in calling scope
	}

	func unembed(controller: UIViewController?) {
		guard let controller = controller else { return }

		controller.willMove(toParentViewController: nil)
		if controller.isViewLoaded {
			controller.view.removeFromSuperview()
		}
		controller.removeFromParentViewController()

		//	Note: don't forget to nullify your own controller instance
		//	in order to clear it out from memory
	}
}

