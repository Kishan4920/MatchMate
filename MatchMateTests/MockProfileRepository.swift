//
//  MockProfileRepository.swift
//  MatchMateTests
//
//  Created by Kishan Patel on 24/08/26.
//

@testable import MatchMate

final class MockProfileRepository: ProfileRepository {
    var profiles: [Profile]
    private(set) var updatedProfileID: String?
    private(set) var updatedStatus: ProfileStatus?
    var fetchError: Error?

    init(profiles: [Profile] = [Profile.sample]) {
        self.profiles = profiles
    }

    func loadCachedProfiles() async throws -> [Profile] {
        profiles
    }

    func fetchNextPage() async throws -> [Profile] {
        if let fetchError { throw fetchError }
        return profiles
    }

    func updateStatus(profileID: String, status: ProfileStatus) async throws {
        updatedProfileID = profileID
        updatedStatus = status
        guard let index = profiles.firstIndex(where: { $0.id == profileID }) else { return }
        profiles[index].status = status
    }
}

extension Profile {
    static let sample = Profile(
        id: "profile-1",
        title: "Ms",
        firstName: "Ada",
        lastName: "Lovelace",
        gender: "female",
        email: "ada@example.com",
        phone: "+44 0000 000000",
        age: 36,
        dateOfBirth: nil,
        registeredDate: nil,
        city: "London",
        state: "England",
        country: "United Kingdom",
        nationality: "GB",
        largeImageURL: "https://example.com/large.jpg",
        mediumImageURL: "https://example.com/medium.jpg",
        thumbnailImageURL: "https://example.com/thumb.jpg",
        status: .pending
    )
}
