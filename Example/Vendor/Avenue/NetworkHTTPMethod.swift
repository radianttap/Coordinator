//
//  NetworkHTTPMethod.swift
//  Avenue
//
//  Copyright © 2017 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//
//	For more details and expected behavior, see:
//	https://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html
//

import Foundation

enum NetworkHTTPMethod: String {
	case GET, POST
	case HEAD, PUT, DELETE
	case OPTIONS, TRACE, CONNECT

	var allowsEmptyResponseData: Bool {
		switch self {
		case .GET, .POST:
			return false
		default:
			return true
		}
	}
}

