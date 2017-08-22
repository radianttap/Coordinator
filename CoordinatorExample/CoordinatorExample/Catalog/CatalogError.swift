//
//  CatalogError.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 22.8.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation

enum CatalogError: Error {
	case dataError(DataError)

	case missingSeason
}

