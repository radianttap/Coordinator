//
//  StoryboardLoadable.swift
//  Radiant Tap Essentials
//
//  Copyright © 2016 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit


protocol StoryboardLoadable {
	static var storyboardName: String { get }
	static var storyboardIdentifier: String { get }
}


extension StoryboardLoadable where Self: UIViewController {

	static var storyboardName: String {
		return String(describing: self)
	}

	static var storyboardIdentifier: String {
		return String(describing: self)
	}

	static func instantiate(fromStoryboardNamed name: String? = nil) -> Self {
		let sb = name ?? self.storyboardName
		let storyboard = UIStoryboard(name: sb, bundle: nil)
		return instantiate(fromStoryboard: storyboard)
	}

	static func instantiate(fromStoryboard storyboard: UIStoryboard) -> Self {
		let identifier = self.storyboardIdentifier
		guard let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else {
			fatalError("Failed to instantiate view controller with identifier=\(identifier) from storyboard \( storyboard )")
		}
		return vc

	}
	
	static func initial(fromStoryboardNamed name: String? = nil) -> Self {
		let sb = name ?? self.storyboardName
		let storyboard = UIStoryboard(name: sb, bundle: nil)
		return initial(fromStoryboard: storyboard)
	}

	static func initial(fromStoryboard storyboard: UIStoryboard) -> Self {
		guard let vc = storyboard.instantiateInitialViewController() as? Self else {
			fatalError("Failed to instantiate initial view controller from storyboard named \( storyboard )")
		}
		return vc
	}
}


extension UINavigationController: StoryboardLoadable {}
extension UITabBarController: StoryboardLoadable {}
extension UISplitViewController: StoryboardLoadable {}
extension UIPageViewController: StoryboardLoadable {}
