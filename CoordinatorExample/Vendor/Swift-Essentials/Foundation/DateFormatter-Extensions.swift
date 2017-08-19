//
//  DateFormatter-Extensions.swift
//  Radiant Tap Essentials
//
//  Copyright © 2016 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

public extension DateFormatter {
	public static let iso8601Formatter: DateFormatter = {
		let df = DateFormatter()
		df.locale = Locale(identifier: "en_US_POSIX")
		df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"		// "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
		return df
	}()

	public static let iso8601FractionalSecondsFormatter: DateFormatter = {
		let df = DateFormatter()
		df.locale = Locale(identifier: "en_US_POSIX")
		df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"		// also test with "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
		return df
	}()
}
