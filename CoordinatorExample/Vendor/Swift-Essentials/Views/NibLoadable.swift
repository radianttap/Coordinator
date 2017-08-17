//
//  NibLoadable.swift
//  Radiant Tap Essentials
//
//  Copyright © 2016 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

///	Adopt this protocol on all subclasses of UITableViewCell and UICollectionViewCell
///	that use their own .xib file
protocol NibLoadableView {
	///	By default, it returns the subclass name
	static var nibName: String { get }

	///	Instantiates UINib using `nibName` as the name, from the main bundle
	static var nib: UINib { get }
}

extension NibLoadableView where Self: UIView {
	static var nibName: String {
		return String(describing: self)
	}
	
	static var nib: UINib {
		return UINib(nibName: self.nibName, bundle: nil)
	}
}

protocol NibReusableView : ReusableView, NibLoadableView {}



///	Adopt this in cases where you need to create an ad-hoc instance of the given view
///	Can be adopted only by classes marked as `final`, due to `Self` constraint
protocol NibLoadableFinalView: NibLoadableView {
	///	Creates an instance of the cell from the `nibName`.xib file
	static var nibInstance : Self { get }
}

extension NibLoadableFinalView {
	static var nibInstance : Self {
		guard let nibObject = self.nib.instantiate(withOwner: nil, options: nil).last as? Self else {
			fatalError("Failed to create an instance of \(self) from \(self.nibName) nib.")
		}
		return nibObject
	}
}

