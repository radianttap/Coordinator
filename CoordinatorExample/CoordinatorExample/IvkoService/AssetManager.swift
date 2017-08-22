//
//  AssetManager.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 20.8.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation


final class AssetManager {
	static let shared = AssetManager()

	private init() {}
}

extension AssetManager {
	func url(forProductPath path: String) -> URL? {
		return baseURL.appendingPathComponent("products", isDirectory: true).appendingPathComponent(path)
	}

	func url(forPromoPath path: String) -> URL? {
		return baseURL.appendingPathComponent("slides", isDirectory: true).appendingPathComponent(path)
	}
}

fileprivate extension AssetManager {
	//	MARK:- Common params and types

	var baseURL : URL {
		guard let url = URL(string: "https://t1.aplus.rs/coordinator/assets") else { fatalError("Can't create base URL!") }
		return url
	}
}
