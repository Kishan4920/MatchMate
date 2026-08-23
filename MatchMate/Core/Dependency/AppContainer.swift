//
//  AppContainer.swift
//  MatchMate
//
//  Created by Kishan Patel on 23/08/26.
//

import Foundation

struct AppContainer {

    let repository: ProfileRepository

    static func live() -> AppContainer {

        let apiClient =
            URLSessionAPIClient()

        let persistence =
            PersistenceController.shared

        let repository =
            DefaultProfileRepository(
                apiClient: apiClient,
                persistenceController: persistence
            )

        return AppContainer(
            repository: repository
        )
    }
}
