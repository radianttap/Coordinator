//
//  NumberFormatter-Extensions.swift
//  Radiant Tap Essentials
//
//  Copyright © 2016 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

public extension NumberFormatter {

	///	Formatter which creates Decimal numbers format with exactly two decimal places,
	///	uses Locale.current
	public static let moneyFormatter: NumberFormatter = {
		let nf = NumberFormatter()
		nf.locale = Locale.current
		nf.generatesDecimalNumbers = true
		nf.maximumFractionDigits = 2
		nf.minimumFractionDigits = 2
		nf.numberStyle = .decimal
		return nf
	}()

	///	Formatter which creates Decimal numbers format with exactly two decimal places,
	///	uses Locale.current + includes the currency symbol / code
	public static let currencyFormatter : NumberFormatter = {
		let nf = NumberFormatter()
		nf.locale = Locale.current
		nf.generatesDecimalNumbers = true
		nf.maximumFractionDigits = 2
		nf.numberStyle = .currency
		return nf
	}()

	public static let ordinalFormatter : NumberFormatter = {
		let nf = NumberFormatter()
		nf.locale = Locale.current
		nf.numberStyle = .ordinal
		return nf
	}()
}
