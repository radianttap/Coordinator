//
//  Network-Extensions.swift
//  Radiant Tap Essentials
//
//  Copyright © 2017 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation
import WebKit

extension ServerTrustPolicy {
	///	Default value to use throughout the app, aids consistency.
	///	URLSession and WKWebView‘s `serverTrustPolicy` should use this value.
	///	Move this extension to some configuration .swift file, per target.
	///	So you have diff. setting for testing, development and/or production build etc.
	static var defaultPolicy: ServerTrustPolicy {
		return ServerTrustPolicy.disableEvaluation
	}
}


extension URLSession {
	var serverTrustPolicy : ServerTrustPolicy {
		return ServerTrustPolicy.defaultPolicy
	}
}


extension WKWebView {
	var serverTrustPolicy : ServerTrustPolicy {
		return ServerTrustPolicy.defaultPolicy
	}
}

