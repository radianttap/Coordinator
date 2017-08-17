//
//  Bundle-Extensions.swift
//  Radiant Tap Essentials
//
//  Copyright © 2016 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

extension Bundle {
	static var appName: String {
		guard let str = main.object(forInfoDictionaryKey: "CFBundleName") as? String else { return "" }
		return str
	}

	static var appVersion: String {
		guard let str = main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { return "" }
		return str
	}

	static var appBuild: String {
		guard let str = main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else { return "" }
		return str
	}

	static var identifier: String {
		guard let str = main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String else { return "" }
		return str
	}
}
