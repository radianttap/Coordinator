//
//  AsyncOperation.swift
//  Radiant Tap Essentials
//	https://github.com/radianttap/swift-essentials
//
//  Copyright © 2017 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

open class AsyncOperation : Operation {
	private enum State {
		case ready
		case executing
		case finished

		fileprivate var key: String {
			switch self {
			case .ready:
				return "isReady"
			case .executing:
				return "isExecuting"
			case .finished:
				return "isFinished"
			}
		}
	}

	private let queue = DispatchQueue(label: "com.radianttap.Essentials.AsyncOperation")

	/// Private backing store for `state`
	private var _state: Atomic<State> = Atomic(.ready)

	/// The state of the operation
	private var state: State {
		get {
			return _state.atomic
		}
		set {
			// A state mutation should be a single atomic transaction. We can't simply perform
			// everything on the isolation queue for `_state` because the KVO willChange/didChange
			// notifications have to be sent from outside the isolation queue. Otherwise we would
			// deadlock because KVO observers will in turn try to read `state` (by calling
			// `isReady`, `isExecuting`, `isFinished`. Use a second queue to wrap the entire
			// transaction.
			queue.sync {
				// Retrieve the existing value first. Necessary for sending fine-grained KVO
				// willChange/didChange notifications only for the key paths that actually change.
				let oldValue = _state.atomic
				guard newValue != oldValue else {
					return
				}
				willChangeValue(forKey: oldValue.key)
				willChangeValue(forKey: newValue.key)
				_state.mutate {
					$0 = newValue
				}
				didChangeValue(forKey: oldValue.key)
				didChangeValue(forKey: newValue.key)
			}
		}
	}

	final override public var isAsynchronous: Bool {
		return true
	}

	final override public var isExecuting: Bool {
		return state == .executing
	}

	final override public var isFinished: Bool {
		return state == .finished
	}

	final override public var isReady: Bool {
		return state == .ready
	}


	//MARK: Setup

	///	Do not override this method, ever. Call it from `workItem()` instead
	final public func markFinished() {
		state = .finished
	}

	/// You **should** override this method and start and/or do your async work here.
	///	**Must** call `markFinished()` inside your override
	///	when async work is done since operation needs to be mark `finished`.
	open func workItem() {
		markFinished()
	}

	required override public init() {
	}

	//MARK: Control

	final override public func start() {
		if isCancelled {
			state = .finished
			return
		}

		main()
	}

	final override public func main() {
		if isCancelled {
			state = .finished
			return
		}

		state = .executing
		workItem()
	}
}
