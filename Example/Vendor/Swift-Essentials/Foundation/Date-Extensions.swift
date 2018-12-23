//
//  Date-Extensions.swift
//  Radiant Tap Essentials
//
//  Copyright © 2016 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation


public extension Date {

	public init(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) {

		if let year = year, let month = month, let day = day, let hour = hour, let minute = minute, let second=second, year <= 0, month <= 0, day <= 0, hour < 0, minute < 0, second < 0 {
			fatalError("Can not create date with negative values")
		}

		let calendar = Calendar.current
		var components = DateComponents()

		components.year = year
		components.month = month
		components.day = day
		components.hour = hour
		components.minute = minute
		components.second = second

		guard let date = calendar.date(from: components) else {
			fatalError("Could not create date")
		}

		self = date
	}



	public func beginningOfDay() -> Date {

		let calendar = Calendar.current
		let components = calendar.dateComponents(Set(arrayLiteral: Calendar.Component.year, Calendar.Component.month, Calendar.Component.day), from: self)

		guard let newDate = calendar.date(from: components) else { return self }

		return newDate
	}



	public func endOfDay() -> Date {

		let calendar = Calendar.current
		var components = DateComponents()
		components.day = 1

		guard let newDate = calendar.date(byAdding: components, to: self.beginningOfDay()) else { return self }

		return newDate.addingTimeInterval(-1)
	}



	public func beginningOfMonth() -> Date {

		let calendar = Calendar.current
		let components = calendar.dateComponents(Set(arrayLiteral: Calendar.Component.year, Calendar.Component.month), from: self)

		guard let newDate = calendar.date(from: components) else { return self }

		return newDate
	}



	public func endOfMonth() -> Date {

		let calendar = Calendar.current
		var components = DateComponents()
		components.month = 1

		guard let newDate = calendar.date(byAdding: components, to: self.beginningOfMonth()) else { return self }

		return newDate.addingTimeInterval(-1)
	}

}

public extension Date {

	public func day() -> Int {

		let calendar = Calendar.current
		let components = calendar.dateComponents(Set(arrayLiteral: Calendar.Component.day), from: self)

		guard let day = components.day else { return 0 }

		return day
	}



	public func weekday() -> Int {

		let calendar = Calendar.current
		let components = calendar.dateComponents(Set(arrayLiteral: Calendar.Component.weekday), from: self)

		guard let weekDay = components.weekday else { return 0 }

		return weekDay
	}



	public func month() -> Int {

		let calendar = Calendar.current
		let components = calendar.dateComponents(Set(arrayLiteral: Calendar.Component.month), from: self)

		guard let month = components.month else { return 0 }

		return month
	}



	public func year() -> Int {

		let calendar = Calendar.current
		let components = calendar.dateComponents(Set(arrayLiteral: Calendar.Component.year), from: self)

		guard let year = components.year else { return 0 }

		return year
	}


	public var isToday: Bool {

		if self > Date().endOfDay() {
			return false
		}
		if self < Date().beginningOfDay() {
			return false
		}

		return true
	}


	public func isEarlierThan(date: Date) -> Bool {

		if self.timeIntervalSince1970 < date.timeIntervalSince1970 {
			return true
		}

		return false
	}



	public func isLaterThan(date: Date) -> Bool {

		if self.timeIntervalSince1970 > date.timeIntervalSince1970 {
			return true
		}

		return false
	}



	public func isEarlierThanOrEqualTo(date: Date) -> Bool {

		if self.timeIntervalSince1970 <= date.timeIntervalSince1970 {
			return true
		}

		return false
	}



	public func isLaterThanOrEqualTo(date: Date) -> Bool {

		if self.timeIntervalSince1970 >= date.timeIntervalSince1970 {
			return true
		}

		return false
	}



	public func add(minutes: Int) -> Date {

		let calendar = Calendar.current
		var components = DateComponents()
		components.minute = minutes

		guard let newDate = calendar.date(byAdding: components, to: self) else { return self }

		return newDate
	}



	public func subtract(minutes: Int) -> Date {

		let calendar = Calendar.current
		var components = DateComponents()
		components.minute = -1 * minutes

		guard let newDate = calendar.date(byAdding: components, to:self) else { return self }

		return newDate
	}



	public func add(hours: Int) -> Date {

		let calendar = Calendar.current
		var components = DateComponents()
		components.hour = hours

		guard let newDate = calendar.date(byAdding: components, to: self) else { return self }

		return newDate
	}



	public func subtract(hours: Int) -> Date {

		let calendar = Calendar.current
		var components = DateComponents()
		components.hour = -1 * hours

		guard let newDate = calendar.date(byAdding: components, to:self) else { return self }

		return newDate
	}



	public func add(days: Int) -> Date {

		let calendar = Calendar.current
		var components = DateComponents()
		components.day = days

		guard let newDate = calendar.date(byAdding: components, to: self) else { return self }

		return newDate
	}



	public func subtract(days: Int) -> Date {

		let calendar = Calendar.current
		var components = DateComponents()
		components.day = -1 * days

		guard let newDate = calendar.date(byAdding: components, to:self) else { return self }

		return newDate
	}



	public func add(months: Int) -> Date {

		let calendar = Calendar.current
		var components = DateComponents()
		components.month = months
		guard let newDate = calendar.date(byAdding: components, to: self) else { return self }

		return newDate
	}



	public func subtract(months: Int) -> Date {

		let calendar = Calendar.current
		var components = DateComponents()
		components.month = -1 * months

		guard let newDate = calendar.date(byAdding: components, to:self) else { return self }

		return newDate
	}



	public func add(years: Int) -> Date {

		let calendar = Calendar.current
		var components = DateComponents()
		components.year = years
		guard let newDate = calendar.date(byAdding: components, to: self) else { return self }

		return newDate
	}



	public func subtract(years: Int) -> Date {

		let calendar = Calendar.current
		var components = DateComponents()
		components.year = -1 * years

		guard let newDate = calendar.date(byAdding: components, to:self) else { return self }

		return newDate
	}



	public func daysFrom(date: Date) -> Int {

		let calendar = Calendar.current
		let earliest = (self as NSDate).earlierDate(date)
		let latest = (earliest == self) ? date : self
		let multiplier = (earliest == self) ? -1 : 1

		guard let day = calendar.dateComponents(Set(arrayLiteral: Calendar.Component.day), from: earliest, to: latest).day else { return 0 }

		return multiplier * day
	}



	public func minutesFrom(date: Date) -> Int {

		let calendar = Calendar.current
		let earliest = (self as NSDate).earlierDate(date)
		let latest = (earliest == self) ? date : self
		let multiplier = (earliest == self) ? -1 : 1

		guard let minute = calendar.dateComponents(Set(arrayLiteral: Calendar.Component.minute), from: earliest, to: latest).minute else { return 0 }

		return multiplier * minute
	}
}
