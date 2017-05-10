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

final class Network {}

protocol UsesNetwork {
	var networkProvider: Network { get }
}

final class WebService {}

final class Keychain {}

final class DataManager {}

final class AccountManager {}

final class RTCoreDataStack {}

final class CartManager {}


//	dependency carrier through the app, 
//	injected into every Coordinator and UIViewController

struct AppDependency {
	let networkProvider: Network
	let keychainProvider: Keychain
	let persistanceProvider: RTCoreDataStack
	let apiProvider: WebService

	let dataManager: DataManager
	let accountManager: AccountManager
	let cartManager: CartManager
}
