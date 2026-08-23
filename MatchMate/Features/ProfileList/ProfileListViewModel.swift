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

    // MARK: - Initial Load

    func loadProfiles() async {

        guard !hasLoadedInitialData else {
            return
        }

        hasLoadedInitialData = true

        // First show cached profiles.
        do {

            profiles =
                try await repository.loadCachedProfiles()

        } catch {

            errorMessage =
                error.localizedDescription
        }

        // Then fetch latest page.
        await loadNextPage()
    }

    // MARK: - Pagination

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
                where: {
                    $0.id == currentItem.id
                }
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

    // MARK: - Status

    func updateStatus(
        profileID: String,
        status: ProfileStatus
    ) async {

        do {
            // Persist first.
            try await repository.updateStatus(
                profileID: profileID,
                status: status
            )
            // Update UI only after persistence succeeds.
            guard let index =
                    profiles.firstIndex(
                        where: {
                            $0.id == profileID
                        }
                    )
            else {
                return
            }

            profiles[index].status = status

        } catch {

            errorMessage =
                error.localizedDescription
        }
    }
}
