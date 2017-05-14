//
//  NibLoadable.swift
//  Radiant Tap Essentials
//
//  Created by Aleksandar Vacić on 14.8.16.
//  Copyright © 2016. Radiant Tap. All rights reserved.
//

import UIKit

//	dealing with nib-based cells
protocol NibLoadableView {
	static var nibName: String { get }
	static var nib: UINib { get }
}

extension NibLoadableView where Self: UIView {
	//	make sure that you name the .xib file identical to class name (this is Xcode default behavior)
	static var nibName: String {
		return String(describing: self)
	}
	static var nib: UINib {
		return UINib(nibName: self.nibName, bundle: nil)
	}

	static var nibInstance : Self {
		guard let nibObject = self.nib.instantiate(withOwner: nil, options: nil).last as? Self else {
			fatalError("Failed to create an instance of \(self) from \(self.nibName) nib.")
		}
		return nibObject
	}
}
