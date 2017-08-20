//
//  IvkoServiceError.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 20.8.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation


enum IvkoServiceError: Error {
	case network(NetworkError?)
	case invalidResponseType
	case emptyResponse
	case unexpectedResponse(HTTPURLResponse, String?)
}
