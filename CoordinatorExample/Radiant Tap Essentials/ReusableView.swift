//
//  ReusableView.swift
//  Radiant Tap Essentials
//
//  Created by Aleksandar Vacić on 14.8.16.
//  Copyright © 2016. Radiant Tap. All rights reserved.
//

import UIKit

//	reusability
protocol ReusableView {
	//	reusable identifier for UICV and UITV Cell
	static var reuseIdentifier: String { get }
}

//	for the UIViews, reuseIdentifier will be the name of the (sub)class
extension ReusableView where Self: UIView {
	static var reuseIdentifier: String {
		return String(describing: self)
	}
}

//	using this to prevent compiler crash during SIL emitting 
protocol NibReusableView : ReusableView, NibLoadableView {}
