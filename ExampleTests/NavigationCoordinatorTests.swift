//
//  NavigationCoordinatorTests.swift
//  Tests
//
//  Created by Krin-San on 1/22/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import XCTest
import Coordinator

class ReportingNavigationCoordinator: NavigationCoordinator {

    var navigationChangeExpectation: XCTestExpectation?

    override func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        super.navigationController(navigationController, didShow: viewController, animated: animated)

        navigationChangeExpectation?.fulfill()
        navigationChangeExpectation = nil
    }

}

class NavigationCoordinatorTests: XCTestCase {

    let toPush = 3
    let navigationController = UINavigationController()
    var coordinator: ReportingNavigationCoordinator!

    override func setUp() {
        super.setUp()

        continueAfterFailure = false

        coordinator = ReportingNavigationCoordinator(rootViewController: navigationController)
        UIApplication.shared.keyWindow?.rootViewController = navigationController
        coordinator.start {}
    }

    func testPopAnimated() {
        pushInitialControllers()
        pop(animated: true)
    }

    func testPopNotAnimated() {
        pushInitialControllers()
        pop(animated: false)
    }

    func testPopToRootAnimated() {
        pushInitialControllers()
        popToRoot(animated: true)
    }

    func testPopToRootNotAnimated() {
        pushInitialControllers()
        popToRoot(animated: false)
    }

    func pushInitialControllers() {
        for i in 0..<toPush {
            coordinator.navigationChangeExpectation = expectation(description: "Controller #\(i) is shown")

            let viewController = UIViewController()
            viewController.title = "#\(i)"
            coordinator.show(viewController)

            waitForExpectations(timeout: 1)
        }

        XCTAssertEqual(coordinator.viewControllers, navigationController.viewControllers)
        XCTAssertEqual(coordinator.viewControllers.count, toPush)
        XCTAssertEqual(navigationController.viewControllers.count, toPush)
    }

    func pop(animated: Bool) {
        coordinator.navigationChangeExpectation = expectation(description: "Controllers popped")
        navigationController.popViewController(animated: animated)

        waitForExpectations(timeout: 1)

        XCTAssertEqual(coordinator.viewControllers, navigationController.viewControllers)
        XCTAssertEqual(coordinator.viewControllers.count, toPush - 1)
        XCTAssertEqual(navigationController.viewControllers.count, toPush - 1)
    }

    func popToRoot(animated: Bool) {
        coordinator.navigationChangeExpectation = expectation(description: "Controllers popped")
        let popped = navigationController.popToRootViewController(animated: animated)

        waitForExpectations(timeout: 1)

        XCTAssertEqual(coordinator.viewControllers, navigationController.viewControllers)
        XCTAssertEqual(coordinator.viewControllers.count, 1)
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(popped?.count == (toPush - 1))
    }

}
