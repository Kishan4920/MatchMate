//
//  ProfileRepository.swift
//  MatchMate
//
//  Created by Kishan Patel on 23/08/26.
//

protocol ProfileRepository {

    func loadCachedProfiles() async throws -> [Profile]

    func fetchNextPage() async throws -> [Profile]

    func updateStatus(
        profileID: String,
        status: ProfileStatus
    ) async throws
}
