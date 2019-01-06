//
//  CatalogError.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 22.8.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation

// Each layer in the Layers app architecture should have its own Error type.
// It wraps any Error returned by lower-level layers.

enum CatalogError: Error {
	case dataError(DataError)

	case missingSeason
}

