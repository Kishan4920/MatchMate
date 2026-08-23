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
        let acceptButton = app.buttons["accept-button"].firstMatch

        XCTAssertTrue(acceptButton.waitForExistence(timeout: 5))
        acceptButton.tap()

        XCTAssertTrue(status(in: app).waitForExistence(timeout: 3))
        XCTAssertFalse(app.navigationBars["Profile"].exists)
        XCTAssertFalse(app.buttons["accept-button"].exists)
        XCTAssertFalse(app.buttons["decline-button"].exists)
    }

    @MainActor
    func testDeclineFromListChangesStatusWithoutOpeningDetail() {
        let app = launchApp()
        let declineButton = app.buttons["decline-button"].firstMatch

        XCTAssertTrue(declineButton.waitForExistence(timeout: 5))
        declineButton.tap()

        XCTAssertTrue(status(in: app).waitForExistence(timeout: 3))
        XCTAssertFalse(app.navigationBars["Profile"].exists)
        XCTAssertFalse(app.buttons["accept-button"].exists)
        XCTAssertFalse(app.buttons["decline-button"].exists)
    }

    @MainActor
    func testProfileContentOpensDetail() {
        let app = launchApp()
        let profileContent = app.links["profile-content"].firstMatch

        XCTAssertTrue(profileContent.waitForExistence(timeout: 5))
        profileContent.tap()

        XCTAssertTrue(app.navigationBars["Profile"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["ada@example.com"].exists)
    }

    @MainActor
    func testAcceptFromDetailChangesStatus() {
        let app = launchDetail()
        let acceptButton = app.buttons["detail-accept-button"]

        XCTAssertTrue(acceptButton.waitForExistence(timeout: 3))
        acceptButton.tap()

        XCTAssertTrue(status(in: app).waitForExistence(timeout: 3))
        XCTAssertFalse(app.buttons["detail-accept-button"].exists)
        XCTAssertFalse(app.buttons["detail-decline-button"].exists)
    }

    @MainActor
    func testDeclineFromDetailChangesStatus() {
        let app = launchDetail()
        let declineButton = app.buttons["detail-decline-button"]

        XCTAssertTrue(declineButton.waitForExistence(timeout: 3))
        declineButton.tap()

        XCTAssertTrue(status(in: app).waitForExistence(timeout: 3))
        XCTAssertFalse(app.buttons["detail-accept-button"].exists)
        XCTAssertFalse(app.buttons["detail-decline-button"].exists)
    }

    private func launchDetail() -> XCUIApplication {
        let app = launchApp()
        let profileContent = app.links["profile-content"].firstMatch
        XCTAssertTrue(profileContent.waitForExistence(timeout: 5))
        profileContent.tap()
        XCTAssertTrue(app.navigationBars["Profile"].waitForExistence(timeout: 3))
        return app
    }

    private func launchApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launch()
        return app
    }

    private func status(in app: XCUIApplication) -> XCUIElement {
        app.descendants(matching: .any)["status"].firstMatch
    }
}
