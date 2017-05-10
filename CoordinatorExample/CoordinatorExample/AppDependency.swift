//
//  AppDependency.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 10.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation
import CoreData

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

//	General Data handler
final class DataManager {}

protocol UsesDataManager {
	var dataManager: DataManager { get }
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


//	Dependency carrier through the app,
//	injected into every Coordinator and UIViewController
//	Protocol composition approach: http://merowing.info/2017/04/using-protocol-compositon-for-dependency-injection/

struct AppDependency: UsesNetwork, UsesKeychain, UsesPersistance, UsesWebService, UsesDataManager, UsesAccountManager, UsesCartManager {
	let networkProvider: Network
	let keychainProvider: Keychain
	let persistanceProvider: RTCoreDataStack
	let apiProvider: WebService

	let dataManager: DataManager
	let accountManager: AccountManager
	let cartManager: CartManager
}
