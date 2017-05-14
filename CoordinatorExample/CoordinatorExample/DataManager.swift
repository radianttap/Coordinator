//
//  DataManager.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 14.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation

protocol UsesDataManager {
	var dataManager: DataManager { get }
}


//	General Data handler
final class DataManager {

	fileprivate(set) var seasons: [Season] = []
}
