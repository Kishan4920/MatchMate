//
//  UITestProfileRepository.swift
//  MatchMate
//
//  Created by Kishan Patel on 24/08/26.
//

import Foundation

@MainActor
final class UITestProfileRepository: ProfileRepository {
    private(set) var profiles: [Profile] = [
        Profile(
            id: "ui-profile-1",
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
    ]

    func loadCachedProfiles() async throws -> [Profile] {
        profiles
    }

    func fetchNextPage() async throws -> [Profile] {
        profiles
    }

    func updateStatus(profileID: String, status: ProfileStatus) async throws {
        guard let index = profiles.firstIndex(where: { $0.id == profileID }) else {
            throw RepositoryError.profileNotFound
        }
        profiles[index].status = status
    }
}
