//
//  NetworkTaskMetric.swift
//  Radiant Tap Essentials
//
//  Copyright © 2017 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

enum NetworkTaskMetric: String {
	case tsStart
	case tsEnd
	case tsResponse
	case tsData
}

extension NetworkTaskMetric {
	static func printout(_ dict: [NetworkTaskMetric: Any]) -> String {
		return "START:\t\( String(describing: dict[.tsStart] ?? "") )\nRESPONSE:\t\( String(describing:dict[.tsResponse] ?? "") )\nDATA:\t\( String(describing:dict[.tsData] ?? "") )\nEND:\t\t\( String(describing:dict[.tsEnd] ?? "") )"
	}
}

