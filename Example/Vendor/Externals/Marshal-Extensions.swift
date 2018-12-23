//
//  Marshal-Extensions.swift
//
//  Created by Aleksandar Vacić on 28.6.17..
//  Copyright © 2017. Aleksandar Vacić. All rights reserved.

import Foundation
import Marshal

extension Date : ValueType {
	///	As generic as possible Date handling, for Marshal library.
	///
	///	More details here: http://aplus.rs/2018/extending-marshal-for-dates/
	public static func value(from object: Any) throws -> Date {
		switch object {
		case let date as Date:
			return date

		case let dateString as String:
			if let date = DateFormatter.iso8601Formatter.date(from: dateString) {
				return date
			} else if let date = DateFormatter.iso8601FractionalSecondsFormatter.date(from: dateString) {
				return date
			}
			throw MarshalError.typeMismatch(expected: "ISO8601 date string", actual: dateString)

		case let dateNum as Int64:
			return Date(timeIntervalSince1970: TimeInterval(integerLiteral: dateNum) )

		case let dateNum as Double:
			return Date(timeIntervalSince1970: dateNum)

		default:
			throw MarshalError.typeMismatch(expected: "Date", actual: type(of: object))
		}
	}
}

extension Decimal: ValueType {
	///	As generic as possible Decimal handling, for Marshal library.
	public static func value(from object: Any) throws -> Decimal {
		switch object {
		case let object as String:
			if let decimal = NumberFormatter.moneyFormatter.number(from: object)?.decimalValue {
				return decimal
			}
			throw MarshalError.typeMismatch(expected: "String(DecimalNumber)", actual: object)

		case let object as NSDecimalNumber:
			return object.decimalValue

		case let object as NSNumber:
			return object.decimalValue

		case let object as Decimal:
			return object

		default:
			throw MarshalError.typeMismatch(expected: "Decimal", actual: type(of: object))
		}
	}
}

extension NSDecimalNumber: ValueType {
	///	As generic as possible NSDecimalNumber handling, for Marshal library.
	public static func value(from object: Any) throws -> NSDecimalNumber {
		switch object {
		case let object as String:
			if let number = NumberFormatter.moneyFormatter.number(from: object) {
				switch number {
				case let number as NSDecimalNumber:
					return number
				default:
					return NSDecimalNumber(decimal: number.decimalValue)
				}
			}
			throw MarshalError.typeMismatch(expected: "String(DecimalNumber)", actual: object)

		case let object as NSDecimalNumber:
			return object

		case let object as NSNumber:
			return NSDecimalNumber(decimal: object.decimalValue)

		case let object as Decimal:
			return NSDecimalNumber(decimal: object)

		default:
			throw MarshalError.typeMismatch(expected: "NSDecimalNumber", actual: type(of: object))
		}
	}
}


