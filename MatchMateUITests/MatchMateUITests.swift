//
//  MatchMateUITests.swift
//  MatchMateUITests
//
//  Created by Kishan Patel on 23/08/26.
//

import XCTest

final class MatchMateUITests: XCTestCase {
    @MainActor
    func testAppLaunchesWithDeterministicProfile() {
        let app = launchApp()

        XCTAssertTrue(app.navigationBars["MatchMate"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Ada Lovelace"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testAcceptFromListChangesStatusWithoutOpeningDetail() {
        let app = launchApp()
        let acceptButton = app.buttons[AccessibilityIdentifiers.acceptButton].firstMatch

        XCTAssertTrue(acceptButton.waitForExistence(timeout: 5))
        acceptButton.tap()

        XCTAssertTrue(status(in: app).waitForExistence(timeout: 3))
        XCTAssertFalse(app.navigationBars["Profile"].exists)
        XCTAssertFalse(app.buttons[AccessibilityIdentifiers.acceptButton].exists)
        XCTAssertFalse(app.buttons[AccessibilityIdentifiers.declineButton].exists)
    }

    @MainActor
    func testDeclineFromListChangesStatusWithoutOpeningDetail() {
        let app = launchApp()
        let declineButton = app.buttons[AccessibilityIdentifiers.declineButton].firstMatch

        XCTAssertTrue(declineButton.waitForExistence(timeout: 5))
        declineButton.tap()

        XCTAssertTrue(status(in: app).waitForExistence(timeout: 3))
        XCTAssertFalse(app.navigationBars["Profile"].exists)
        XCTAssertFalse(app.buttons[AccessibilityIdentifiers.acceptButton].exists)
        XCTAssertFalse(app.buttons[AccessibilityIdentifiers.declineButton].exists)
    }

    @MainActor
    func testProfileContentOpensDetail() {
        let app = launchApp()
        let profileContent = app.links[AccessibilityIdentifiers.profileContent].firstMatch

        XCTAssertTrue(profileContent.waitForExistence(timeout: 5))
        profileContent.tap()

        XCTAssertTrue(app.navigationBars["Profile"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["ada@example.com"].exists)
    }

    @MainActor
    func testAcceptFromDetailChangesStatus() {
        let app = launchDetail()
        let acceptButton = app.buttons[AccessibilityIdentifiers.detailAcceptButton]

        XCTAssertTrue(acceptButton.waitForExistence(timeout: 3))
        acceptButton.tap()

        XCTAssertTrue(status(in: app).waitForExistence(timeout: 3))
        XCTAssertFalse(app.buttons[AccessibilityIdentifiers.detailAcceptButton].exists)
        XCTAssertFalse(app.buttons[AccessibilityIdentifiers.detailDeclineButton].exists)
    }

    @MainActor
    func testDeclineFromDetailChangesStatus() {
        let app = launchDetail()
        let declineButton = app.buttons[AccessibilityIdentifiers.detailDeclineButton]

        XCTAssertTrue(declineButton.waitForExistence(timeout: 3))
        declineButton.tap()

        XCTAssertTrue(status(in: app).waitForExistence(timeout: 3))
        XCTAssertFalse(app.buttons[AccessibilityIdentifiers.detailAcceptButton].exists)
        XCTAssertFalse(app.buttons[AccessibilityIdentifiers.detailDeclineButton].exists)
    }

    private func launchDetail() -> XCUIApplication {
        let app = launchApp()
        let profileContent = app.links[AccessibilityIdentifiers.profileContent].firstMatch
        XCTAssertTrue(profileContent.waitForExistence(timeout: 5))
        profileContent.tap()
        XCTAssertTrue(app.navigationBars["Profile"].waitForExistence(timeout: 3))
        return app
    }

    private func launchApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = [AccessibilityIdentifiers.uiTestingLaunchArgument]
        app.launch()
        return app
    }

    private func status(in app: XCUIApplication) -> XCUIElement {
        app.descendants(matching: .any)[AccessibilityIdentifiers.status].firstMatch
    }
}
