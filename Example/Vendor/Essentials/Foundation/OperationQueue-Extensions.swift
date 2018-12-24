//
//  OperationQueue-Extensions.swift
//  Radiant Tap Essentials
//	https://github.com/radianttap/swift-essentials
//
//  Copyright © 2017 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

extension OperationQueue {
	///	Performs the given `block` on the `queue` if it‘s supplied
	///	or the current queue (whatever it is) if not.
	public static func perform(_ block: @autoclosure @escaping () -> Void, onQueue queue: OperationQueue?) {
		if let queue = queue {
			queue.addOperation { block() }
			return
		}
		block()
	}
}
