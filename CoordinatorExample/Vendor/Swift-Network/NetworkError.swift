//
//  NetworkError.swift
//  Radiant Tap Essentials
//
//  Copyright © 2017 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

enum NetworkError: Error {
	///	Wrapper to handle URLSession errors.
	/// Things like no connection to internet, no route to host, timeout etc
	case urlError(URLError?)

	///	Returned when the NetworkOperation is cancelled when the Task has already started
	case cancelled

	//	You can expand this enum to include additional stuff you may pre-process in `NetworkOperation`.
	//	Some examples:

	///	If you only care about HTTP 2xx, mark anything else as invalid
	case invalidResponse

	///	If your requests must always return some data (i.e. you don't use PUT, DELETE),
	///	then use this report an error is GET, POST return no data
	case noData
}
