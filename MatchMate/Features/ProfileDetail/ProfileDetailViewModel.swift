//
//  ProfileDetailViewModel.swift
//  MatchMate
//
//  Created by Kishan Patel on 23/08/26.
//

import Combine
import Foundation

@MainActor
final class ProfileDetailViewModel: ObservableObject {

    @Published private(set) var profile: Profile

    @Published var errorMessage: String?

    private let repository: ProfileRepository

    init(
        profile: Profile,
        repository: ProfileRepository
    ) {
        self.profile = profile
        self.repository = repository
    }

    func updateStatus(
        _ status: ProfileStatus
    ) async -> Bool {

        do {
            try await repository.updateStatus(
                profileID: profile.id,
                status: status
            )
            // Update local UI only after persistence succeeds.
            profile.status = status
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
