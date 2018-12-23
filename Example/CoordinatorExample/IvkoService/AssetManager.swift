//
//  AssetManager.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 20.8.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation


final class AssetManager: NetworkSession {
	static let shared = AssetManager()

	private init() {
		queue = {
			let oq = OperationQueue()
			oq.qualityOfService = .userInitiated
			return oq
		}()

		let urlSessionConfiguration: URLSessionConfiguration = {
			let c = URLSessionConfiguration.default
			c.allowsCellularAccess = true
			c.httpCookieAcceptPolicy = .never
			c.httpShouldSetCookies = false
			return c
		}()
		super.init(urlSessionConfiguration: urlSessionConfiguration)
	}

	//	Local stuff

	private var queue: OperationQueue
}

extension AssetManager {
	func url(forProductPath path: String) -> URL? {
		return baseURL.appendingPathComponent("products", isDirectory: true).appendingPathComponent(path)
	}

	func url(forPromoPath path: String) -> URL? {
		return baseURL.appendingPathComponent("slides", isDirectory: true).appendingPathComponent(path)
	}
}

private extension AssetManager {
	//	MARK:- Common params and types

	var baseURL : URL {
		guard let url = URL(string: "https://t1.aplus.rs/coordinator/assets") else { fatalError("Can't create base URL!") }
		return url
	}
}
