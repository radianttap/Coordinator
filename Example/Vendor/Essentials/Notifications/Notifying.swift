//
//  Notifying.swift
//  Radiant Tap Essentials
//	https://github.com/radianttap/swift-essentials
//
//  Copyright © 2016 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

/*
	Credits:
	https://talk.objc.io/episodes/S01E27-typed-notifications-part-1
	https://talk.objc.io/episodes/S01E28-typed-notifications-part-2
 */

import Foundation

public class NotificationToken {
	public let token: NSObjectProtocol
	public let center: NotificationCenter

	public init(token: NSObjectProtocol, center: NotificationCenter? = nil) {
		self.token = token
		self.center = center ?? NotificationCenter.default
	}

	deinit {
		center.removeObserver(token)
	}
}

public struct NotificationDescriptor<A> {
	public let name: Notification.Name
}

extension NotificationCenter {
	public func addObserver<A>(for descriptor: NotificationDescriptor<A>,
	                 queue: OperationQueue? = nil,
	                 using block: @escaping (A) -> ()) -> NotificationToken {

		return NotificationToken(token: addObserver(forName: descriptor.name, object: nil, queue: queue, using: {
			note in
			guard let object = note.object as? A else { return }
			block(object)
		}), center: self)
	}

	public func post<A>(_ descriptor: NotificationDescriptor<A>,
	          value: A) {

		post(name: descriptor.name, object: value)
	}
}

