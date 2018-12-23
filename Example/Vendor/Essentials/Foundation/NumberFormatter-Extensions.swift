//
//  NumberFormatter-Extensions.swift
//  Radiant Tap Essentials
//	https://github.com/radianttap/swift-essentials
//
//  Copyright © 2016 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

extension NumberFormatter {

	///	Formatter which creates Decimal numbers format with exactly two decimal places,
	///	uses Locale.current
	public static private(set) var moneyFormatter: NumberFormatter = moneyFormatterBuilder

	private static var moneyFormatterBuilder: NumberFormatter {
		let nf = NumberFormatter()
		nf.locale = Locale.current
		nf.generatesDecimalNumbers = true
		nf.maximumFractionDigits = 2
		nf.minimumFractionDigits = 2
		nf.numberStyle = .decimal
		return nf
	}

	///	Formatter which creates Decimal numbers format with exactly two decimal places,
	///	uses Locale.current + includes the currency symbol / code
	public static private(set) var currencyFormatter: NumberFormatter = currencyFormatterBuilder

	private static var currencyFormatterBuilder : NumberFormatter = {
		let nf = NumberFormatter()
		nf.locale = Locale.current
		nf.generatesDecimalNumbers = true
		nf.maximumFractionDigits = 2
		nf.numberStyle = .currency
		return nf
	}()

	///	Locale aware formatter to output 1st, 2nd etc
	public static private(set) var ordinalFormatter: NumberFormatter = ordinalFormatterBuilder

	private static var ordinalFormatterBuilder : NumberFormatter = {
		let nf = NumberFormatter()
		nf.locale = Locale.current
		nf.numberStyle = .ordinal
		return nf
	}()

	///	Call this function after your in-app Locale changes
	///	see https://github.com/radianttap/LanguageSwitcher/
	public static func resetupEssentialFormatters() {
		moneyFormatter = moneyFormatterBuilder
		currencyFormatter = currencyFormatterBuilder
		ordinalFormatter = ordinalFormatterBuilder
	}
}
