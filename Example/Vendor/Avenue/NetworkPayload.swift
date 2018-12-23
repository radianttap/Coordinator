//
//  NetworkPayload.swift
//  Avenue
//
//  Copyright © 2017 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

/// A simple struct to use as network "result".
///	As `NetworkOperation` is processing, its varuous propertues will be populated along the way.
struct NetworkPayload {
	///	The original value of URLRequest at the start of the operation
	let originalRequest: URLRequest

	///	At the start, this is identical to `originalRequest`.
	///	But, you may need to alter the original as the network processing is ongoing.
	///	i.e. you can pass the original request through OAuth library and thus update it.
	var urlRequest: URLRequest

	init(urlRequest: URLRequest) {
		self.originalRequest = urlRequest
		self.urlRequest = urlRequest
	}

	
	//	MARK: Result properties

	///	Any error that URLSession may populate (timeouts, no connection etc)
	var error: NetworkError?

	///	Received HTTP response. Use it to process status code and headers
	var response: HTTPURLResponse?

	///	Received stream of bytes
	var data: Data?


	//	MARK: Timestamps

	///	Moment when the payload was prepared. May not be the same as `tsStart`
	let tsCreated = Date()

	///	Moment when network task is started (you called `task.resume()` for the first time).
	///	Call `.start()` to set it.
	private(set) var tsStart: Date?

	///	Moment when network task has ended. Used together with `tsStart` makes for simple speed metering.
	///	Call `.end()` to set it.
	private(set) var tsEnd: Date?
}

extension NetworkPayload {
	///	Call this along with `task.resume()`
	mutating func start() {
		self.tsStart = Date()
	}

	///	Called when URLSessionDataTask ends.
	mutating func end() {
		self.tsEnd = Date()
	}
}

