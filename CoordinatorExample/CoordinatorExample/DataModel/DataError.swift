//
//  DataError.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 18.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation


enum DataError: Error {
	case internalError
	case insufficientInput
	case missingData
}


extension DataError: CustomStringConvertible {
	var description: String {
		switch self {
		case .internalError:
			return "Internal Error"
		case .insufficientInput:
			return "Insufficient input parameters"
		case .missingData:
			return "No data available at the moment"
		}
	}
}
