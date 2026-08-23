//
//  ProfileListViewModelTests.swift
//  MatchMate
//
//  Created by Kishan Patel on 24/08/26.
//

import XCTest
@testable import MatchMate

@MainActor
final class ProfileListViewModelTests: XCTestCase {

    func testLoadProfilesLoadsCachedProfiles() async {

        let repository = MockProfileRepository(
            profiles: [Profile.sample]
        )

        let viewModel = ProfileListViewModel(
            repository: repository
        )

        await viewModel.loadProfiles()

        XCTAssertEqual(
            viewModel.profiles.count,
            1
        )

        XCTAssertEqual(
            viewModel.profiles.first?.id,
            "profile-1"
        )
    }

    func testAcceptProfileUpdatesStatus() async {

        let repository = MockProfileRepository(
            profiles: [Profile.sample]
        )

        let viewModel = ProfileListViewModel(
            repository: repository
        )

        await viewModel.loadProfiles()

        await viewModel.updateStatus(
            profileID: "profile-1",
            status: .accepted
        )

        XCTAssertEqual(
            viewModel.profiles.first?.status,
            .accepted
        )

        XCTAssertEqual(
            repository.updatedProfileID,
            "profile-1"
        )

        XCTAssertEqual(
            repository.updatedStatus,
            .accepted
        )
    }

    func testDeclineProfileUpdatesStatus() async {

        let repository = MockProfileRepository(
            profiles: [Profile.sample]
        )

        let viewModel = ProfileListViewModel(
            repository: repository
        )

        await viewModel.loadProfiles()

        await viewModel.updateStatus(
            profileID: "profile-1",
            status: .declined
        )

        XCTAssertEqual(
            viewModel.profiles.first?.status,
            .declined
        )

        XCTAssertEqual(
            repository.updatedProfileID,
            "profile-1"
        )

        XCTAssertEqual(
            repository.updatedStatus,
            .declined
        )
    }

    func testLoadNextPageHandlesError() async {

        let repository = MockProfileRepository()

        repository.fetchError = TestError.networkError

        let viewModel = ProfileListViewModel(
            repository: repository
        )

        await viewModel.loadNextPage()

        XCTAssertNotNil(
            viewModel.errorMessage
        )
    }
}

private enum TestError: Error {
    case networkError
}
