//
//  Marshal-Extensions.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 20.8.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//
//	Note:
//	These are general extensions, tailored for this app

import Foundation
import Marshal

extension Date : ValueType {
	public static func value(from object: Any) throws -> Date {
		guard let dateString = object as? String else {
			throw MarshalError.typeMismatch(expected: String.self, actual: type(of: object))
		}
		if let date = DateFormatter.iso8601Formatter.date(from: dateString) {
			return date
		} else if let date = DateFormatter.iso8601FractionalSecondsFormatter.date(from: dateString) {
			return date
		}
		throw MarshalError.typeMismatch(expected: "ISO8601 date string", actual: dateString)
	}
}

extension Decimal: ValueType {
	public static func value(from object: Any) throws -> Decimal {
		if object is String {
			guard let decimal = NumberFormatter.moneyFormatter.number(from: object as! String)?.decimalValue else {
				throw MarshalError.typeMismatch(expected: "String(DecimalNumber)", actual: object)
			}
			return decimal
		}

		if object is NSDecimalNumber {
			guard let decimalNum = object as? NSDecimalNumber else {
				throw MarshalError.typeMismatch(expected: "DecimalNumber", actual: object)
			}
			return decimalNum.decimalValue
		}

		if object is NSNumber {
			guard let num = object as? NSNumber else {
				throw MarshalError.typeMismatch(expected: "Number", actual: object)
			}
			return num.decimalValue
		}

		guard let decimal = object as? Decimal else {
			throw MarshalError.typeMismatch(expected: "Decimal", actual: object)
		}
		return decimal
	}
}

extension NSDecimalNumber: ValueType {

	public static func value(from object: Any) throws -> NSDecimalNumber {
		if object is String {
			guard let decimal = NumberFormatter.moneyFormatter.number(from: object as! String) as? NSDecimalNumber else {
				throw MarshalError.typeMismatch(expected: "String(NSDecimalNumber)", actual: object)
			}
			return decimal
		}
		if object is NSNumber {
			guard let number = object as? NSNumber else {
				throw MarshalError.typeMismatch(expected: "NSNumber with decimal value", actual: object)
			}
			return NSDecimalNumber(decimal: number.decimalValue)
		}

		guard let decimal = object as? NSDecimalNumber else {
			throw MarshalError.typeMismatch(expected: "NSDecimalNumber", actual: object)
		}
		return decimal
	}
}


