//
//  NetworkError.swift
//  Avenue
//
//  Copyright © 2017 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

///	Various error this library is specifically handling.
///	If you extend the capabilities of the this micro-library, you may add as many cases as you need here
public enum NetworkError: Error {
	case invalidResponse

	case noData

	case cancelled

	case urlError(URLError?)
}
