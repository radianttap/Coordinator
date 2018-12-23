//
//  Network-Extensions.swift
//  Avenue
//
//  Copyright © 2017 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

#if os(iOS)
import WebKit
#endif

extension ServerTrustPolicy {
	///	Default value to use throughout the app, aids consistency.
	///	URLSession and WKWebView‘s `serverTrustPolicy` should use this value.
	///
	///	ATTENTION:
	///	Move this setting to some configuration .swift file, per target.
	///	So you can have diff. setting for development, testing, production build etc.
	static var defaultPolicy: ServerTrustPolicy {
		return ServerTrustPolicy.disableEvaluation
	}
}

//	These below will simply follow what the setting above has
//	(no need to move these anywhere)

extension URLSession {
	var serverTrustPolicy : ServerTrustPolicy {
		return ServerTrustPolicy.defaultPolicy
	}
}


#if os(iOS)
extension WKWebView {
	var serverTrustPolicy : ServerTrustPolicy {
		return ServerTrustPolicy.defaultPolicy
	}
}
#endif

