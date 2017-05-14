//
//  Manager.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 10.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation

//	Mock-up high-level objects in the app

//	Network handler, wrapper for URLSession
final class Network {}

protocol UsesNetwork {
	var networkProvider: Network { get }
}

//	Web service API wrapper
final class WebService {}

protocol UsesWebService {
	var apiProvider: WebService { get }
}

//	KeychainAccess: https://github.com/kishikawakatsumi/KeychainAccess
final class Keychain {}

protocol UsesKeychain {
	var keychainProvider: Keychain { get }
}

//	CoreData stack, provider of MOCs
//	https://github.com/radianttap/RTSwiftCoreDataStack
final class RTCoreDataStack {
	typealias Callback = () -> Void

	init(withDataModelNamed dataModel: String? = nil, storeURL: URL? = nil, callback: @escaping Callback = {_ in}) {
	}
}

protocol UsesPersistance {
	var persistanceProvider: RTCoreDataStack { get }
}

//	Keeper of UserAccount related stuff
final class AccountManager {}

protocol UsesAccountManager {
	var accountManager: AccountManager { get }
}

//	Tracks what items are added to ShopppingCart
final class CartManager {}

protocol UsesCartManager {
	var cartManager: CartManager { get }
}


