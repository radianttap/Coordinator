//
//  String-Extensions.swift
//  Radiant Tap Essentials
//
//  Copyright © 2016 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

public extension String {
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
