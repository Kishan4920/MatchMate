//
//  ProfileDetailViewModelTests.swift
//  MatchMate
//
//  Created by Kishan Patel on 24/08/26.
//

import XCTest
@testable import MatchMate

@MainActor
final class ProfileDetailViewModelTests: XCTestCase {

    func testAcceptProfileUpdatesStatus() async {

        let profile = Profile.sample

        let repository = MockProfileRepository(
            profiles: [profile]
        )

        let viewModel = ProfileDetailViewModel(
            profile: profile,
            repository: repository
        )

        let success = await viewModel.updateStatus(.accepted)

        XCTAssertTrue(success)

        XCTAssertEqual(
            viewModel.profile.status,
            .accepted
        )

        XCTAssertEqual(
            repository.updatedProfileID,
            profile.id
        )

        XCTAssertEqual(
            repository.updatedStatus,
            .accepted
        )
    }

    func testDeclineProfileUpdatesStatus() async {

        let profile = Profile.sample

        let repository = MockProfileRepository(
            profiles: [profile]
        )

        let viewModel = ProfileDetailViewModel(
            profile: profile,
            repository: repository
        )

        let success = await viewModel.updateStatus(.declined)

        XCTAssertTrue(success)

        XCTAssertEqual(
            viewModel.profile.status,
            .declined
        )

        XCTAssertEqual(
            repository.updatedProfileID,
            profile.id
        )

        XCTAssertEqual(
            repository.updatedStatus,
            .declined
        )
    }
}
