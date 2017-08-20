//
//  IvkoService.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 20.8.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation
import Marshal


public typealias JSON = [String: Any]

final class IvkoService {
	static let shared = IvkoService()

	private init() {
		urlSessionConfiguration = {
			let c = URLSessionConfiguration.default
			c.allowsCellularAccess = true
			c.httpCookieAcceptPolicy = .never
			c.httpShouldSetCookies = false
			c.httpAdditionalHeaders = IvkoService.commonHeaders
			return c
		}()

		queue = {
			let oq = OperationQueue()
			oq.qualityOfService = .userInitiated
			return oq
		}()
	}

	fileprivate var urlSessionConfiguration: URLSessionConfiguration
	fileprivate var queue: OperationQueue
}





extension IvkoService {
	//	MARK:- Endpoint wrappers
	enum Path {
		case promotions
		case seasons
		case products
		case details(styleCode: String)


		fileprivate var method: IvkoService.Method {
			return .GET
		}

		private var headers: [String: String] {
			var h: [String: String] = [:]

			switch self {
			default:
				h["Accept"] = "application/json"
			}

			return h
		}

		private var fullURL: URL {
			var url = IvkoService.shared.baseURL

			switch self {
			case .promotions:
				url.appendPathComponent("slides.json")
			case .seasons:
				url.appendPathComponent("seasons.json")
			case .products:
				url.appendPathComponent("products.json")
			case .details:
				url.appendPathComponent("details")
			}

			return url
		}

		private var params: [String: String] {
			var p : [String: String] = [:]

			switch self {
			case .details(let styleCode):
				p["style"] = styleCode
			default:
				break
			}

			return p
		}

		private var encodedParams: String {
			switch self {
			case .details:
				return queryEncoded(params: params)
			default:
				return ""
			}
		}

		private func queryEncoded(params: [String: String]) -> String {
			if params.count == 0 { return "" }

			var arr = [String]()
			for (key, value) in params {
				let s = "\(key)=\(value)"
				arr.append(s)
			}

			return arr.joined(separator: "&")
		}

		private func jsonEncoded(params: JSON) -> Data? {
			return try? JSONSerialization.data(withJSONObject: params)
		}

		fileprivate var urlRequest: URLRequest {
			guard var components = URLComponents(url: fullURL, resolvingAgainstBaseURL: false) else { fatalError("Invalid URL") }

			switch method {
			case .GET:
				components.query = queryEncoded(params: params)
			default:
				break
			}

			guard let url = components.url else { fatalError("Invalid URL") }
			var r = URLRequest(url: url)
			r.httpMethod = method.rawValue
			r.allHTTPHeaderFields = headers

			switch method {
			case .POST:
				r.httpBody = jsonEncoded(params: params)
				break
			default:
				break
			}

			return r
		}
	}
}


extension IvkoService {
	typealias ServiceCallback = ( JSON?, IvkoServiceError? ) -> Void

	func call(path: Path, callback: @escaping ServiceCallback) {
		let urlRequest = path.urlRequest
		execute(urlRequest, path: path, callback: callback)
	}
}



fileprivate extension IvkoService {
	//	MARK:- Common params and types

	var baseURL : URL {
		guard let url = URL(string: "https://t1.aplus.rs/coordinator/api") else { fatalError("Can't create base URL!") }
		return url
	}

	static let commonHeaders: [String: String] = {
		return [
			"User-Agent": userAgent,
			"Accept-Charset": "utf-8",
			"Accept-Encoding": "gzip, deflate"
		]
	}()

	static var userAgent: String = {
		let osName = UIDevice.current.systemName
		let osVersion = UIDevice.current.systemVersion
		let deviceVersion = UIDevice.current.model
		let locale = Locale.current.identifier
		return "\( Bundle.appName ) \( Bundle.appVersion ) (\( Bundle.appBuild )); \( deviceVersion ); \( osName ) \( osVersion ); \( locale )"
	}()

	enum Method: String {
		case GET, POST, PUT, DELETE
	}

	//	MARK:- Execution

	func execute(_ urlRequest: URLRequest, path: Path, callback: @escaping ServiceCallback) {
		let op = NetworkOperation(urlRequest: urlRequest, urlSessionConfiguration: urlSessionConfiguration) {
//			[unowned self]
			payload in

			//	process the returned stuff, now
			if let error = payload.error {
				callback(nil, IvkoServiceError.network(error) )
				return
			}

			guard let httpURLResponse = payload.response else {
				callback(nil, IvkoServiceError.invalidResponseType)
				return
			}

			if !(200...299).contains(httpURLResponse.statusCode) {
				switch httpURLResponse.statusCode {
				default:
					callback(nil, IvkoServiceError.invalidResponseType)
				}
				return
			}

			guard let data = payload.data else {
				callback(nil, IvkoServiceError.emptyResponse)
				return
			}

			switch path {
			default:
				guard
					let obj = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]),
					let json = obj as? JSON
				else {
					//	convert to string, so it‘ logged what‘s actually returned
					let str = String(data: data, encoding: .utf8)
					callback(nil, IvkoServiceError.unexpectedResponse(httpURLResponse, str))
					return
				}

				callback(json, nil)
			}
		}

		queue.addOperation(op)
	}
}

