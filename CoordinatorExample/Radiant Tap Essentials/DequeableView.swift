//
//  DequeableView.swift
//  Radiant Tap Essentials
//
//  Created by Aleksandar Vacić on 14.8.16.
//  Copyright © 2016. Radiant Tap. All rights reserved.
//

import UIKit


extension UICollectionView {

	//	register for the Class-based cell
	func register<T: UICollectionViewCell>(_: T.Type)
		where T: ReusableView
	{
		register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
	}

	//	register for the Nib-based cell
	func register<T: UICollectionViewCell>(_: T.Type) where
		T:NibReusableView
	{
		register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
	}

	func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T
		where T:ReusableView
	{
		//	this deque and cast can fail if you forget to register the proper cell
		guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
			//	thus crash instantly and nudge the developer
			fatalError("Dequeing a cell with identifier: \(T.reuseIdentifier) failed.\nDid you maybe forget to register it in viewDidLoad?")
		}
		return cell
	}
}


extension UITableView {

	//	register for the Class-based cell
	func register<T: UITableViewCell>(_: T.Type)
		where T: ReusableView
	{
		register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
	}

	//	register for the Nib-based cell
	func register<T: UITableViewCell>(_: T.Type)
		where T:NibReusableView
	{
		register(T.nib, forCellReuseIdentifier: T.reuseIdentifier)
	}

	func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T
		where T:ReusableView
	{
		guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
			fatalError("Dequeing a cell with identifier: \(T.reuseIdentifier) failed.\nDid you maybe forget to register it in viewDidLoad?")
		}
		return cell
	}
}

