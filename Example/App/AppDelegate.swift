//
//  AppDelegate.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 23.11.16..
//  Copyright © 2016. Radiant Tap. All rights reserved.
//

import UIKit
import Coordinator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	var appCoordinator: AppCoordinator = {
		let vc = UINavigationController.initial(fromStoryboardNamed: UIStoryboard.Name.app)
		let c = AppCoordinator(rootViewController: vc)
		return c
	}()

	func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)

		window?.rootViewController = appCoordinator.rootViewController

		return true
	}

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		window?.makeKeyAndVisible()
		appCoordinator.start()

		return true
	}
}

