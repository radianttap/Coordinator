//
//  String-Extensions.swift
//  Radiant Tap Essentials
//	https://github.com/radianttap/swift-essentials
//
//  Copyright © 2016 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

extension String {
	//	Credits: Leo Dabus
	//	https://stackoverflow.com/questions/32305891/index-of-a-substring-in-a-string-with-swift

	public func index(of string: String, options: CompareOptions = .literal) -> Index? {
		return range(of: string, options: options)?.lowerBound
	}

	public func endIndex(of string: String, options: CompareOptions = .literal) -> Index? {
		return range(of: string, options: options)?.upperBound
	}

	public func indexes(of string: String, options: CompareOptions = .literal) -> [Index] {
		var result: [Index] = []
		var start = startIndex
		while let range = range(of: string, options: options, range: start..<endIndex) {
			result.append(range.lowerBound)
			start = range.upperBound
		}
		return result
	}

	public func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
		var result: [Range<Index>] = []
		var start = startIndex
		while let range = range(of: string, options: options, range: start..<endIndex) {
			result.append(range)
			start = range.upperBound
		}
		return result
	}
}

//	Various other stuff

extension String {
	public static func random(withLength length: Int) -> String {
		let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		let len = UInt32(letters.length)

		var randomString = ""

		for _ in 0 ..< length {
			let rand = arc4random_uniform(len)
			var nextChar = letters.character(at: Int(rand))
			randomString += NSString(characters: &nextChar, length: 1) as String
		}

		return randomString
	}
}
