//
//  ProfileListViewModel.swift
//  MatchMate
//
//  Created by Kishan Patel on 23/08/26.
//

import Foundation
import Combine
@MainActor
final class ProfileListViewModel: ObservableObject {

    @Published private(set) var profiles: [Profile] = []

    @Published private(set) var isLoading = false

    @Published private(set) var isLoadingMore = false

    @Published var errorMessage: String?

    private let repository: ProfileRepository

    private var hasLoadedInitialData = false

    init(repository: ProfileRepository) {
        self.repository = repository
    }

    func loadProfiles() async {

        guard !hasLoadedInitialData else {
            return
        }

        hasLoadedInitialData = true

        // First show cached data
        do {
            profiles = try await repository.loadCachedProfiles()
        } catch {
            errorMessage = error.localizedDescription
        }

        // Then fetch latest data
        await loadNextPage()
    }

    func loadNextPage() async {

        guard !isLoadingMore else {
            return
        }

        isLoadingMore = true
        defer {
            isLoadingMore = false
        }

        do {

            let updatedProfiles =
                try await repository.fetchNextPage()

            profiles = updatedProfiles

        } catch {

            errorMessage =
                error.localizedDescription
        }
    }

    func loadMoreIfNeeded(
        currentItem: Profile
    ) async {

        guard
            let index = profiles.firstIndex(
                where: { $0.id == currentItem.id }
            )
        else {
            return
        }

        let threshold =
            max(profiles.count - 3, 0)

        if index >= threshold {
            await loadNextPage()
        }
    }

    func updateStatus(
        profileID: String,
        status: ProfileStatus
    ) async {

        do {

            try await repository.updateStatus(
                profileID: profileID,
                status: status
            )

            if let index = profiles.firstIndex(
                where: { $0.id == profileID }
            ) {

                let oldProfile = profiles[index]

                profiles[index] = Profile(
                    id: oldProfile.id,
                    title: oldProfile.title,
                    firstName: oldProfile.firstName,
                    lastName: oldProfile.lastName,
                    gender: oldProfile.gender,
                    email: oldProfile.email,
                    phone: oldProfile.phone,
                    age: oldProfile.age,
                    dateOfBirth: oldProfile.dateOfBirth,
                    registeredDate: oldProfile.registeredDate,
                    city: oldProfile.city,
                    state: oldProfile.state,
                    country: oldProfile.country,
                    nationality: oldProfile.nationality,
                    largeImageURL: oldProfile.largeImageURL,
                    mediumImageURL: oldProfile.mediumImageURL,
                    thumbnailImageURL: oldProfile.thumbnailImageURL,
                    status: status
                )
            }

        } catch {

            errorMessage =
                error.localizedDescription
        }
    }
}
