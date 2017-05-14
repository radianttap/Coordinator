//
//  StoryboardLoadable.swift
//  Radiant Tap Essentials
//
//  Created by Aleksandar Vacić on 14.8.16.
//  Copyright © 2016. Radiant Tap. All rights reserved.
//

import UIKit


protocol StoryboardLoadable {
	static var storyboardName: String { get }
	static var storyboardIdentifier: String { get }
}


extension StoryboardLoadable where Self:UIViewController {

	static var storyboardName: String {
		return String(describing: self)
	}

	static var storyboardIdentifier: String {
		return String(describing: self)
	}

	static func instantiate(fromStoryboard storyboardName: String? = nil) -> Self {
		let sb = storyboardName ?? self.storyboardName
		let storyboard = UIStoryboard(name: sb, bundle: nil)
		let identifier = self.storyboardIdentifier
		guard let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else {
			fatalError("Failed to instantiate view controller with identifier=\(identifier) from storyboard named \(sb)")
		}
		return vc

	}

	static func initial(fromStoryboard storyboardName: String? = nil) -> Self {
		let sb = storyboardName ?? self.storyboardName
		let storyboard = UIStoryboard(name: sb, bundle: nil)
		guard let vc = storyboard.instantiateInitialViewController() as? Self else {
			fatalError("Failed to instantiate initial view controller from storyboard named \(sb)")
		}
		return vc
	}
}


extension UINavigationController: StoryboardLoadable {}
extension UITabBarController: StoryboardLoadable {}
extension UISplitViewController: StoryboardLoadable {}
extension UIPageViewController: StoryboardLoadable {}
