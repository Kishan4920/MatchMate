//
//  AppContainer.swift
//  MatchMate
//
//  Created by Kishan Patel on 23/08/26.
//

import CoreData

struct AppContainer {

    let persistenceController: PersistenceController
    let repository: ProfileRepository

    init(
        apiClient: APIClient,
        persistenceController: PersistenceController
    ) {
        self.persistenceController = persistenceController
        self.repository = DefaultProfileRepository(
            apiClient: apiClient,
            persistenceController: persistenceController
        )
    }

    static func live() -> AppContainer {
        if ProcessInfo.processInfo.arguments.contains(
            AccessibilityIdentifiers.uiTestingLaunchArgument
        ) {
            return AppContainer(
                repository: UITestProfileRepository(),
                persistenceController: PersistenceController(inMemory: true)
            )
        }

        return AppContainer(
            apiClient: URLSessionAPIClient(),
            persistenceController: PersistenceController()
        )
    }

    private init(
        repository: ProfileRepository,
        persistenceController: PersistenceController
    ) {
        self.repository = repository
        self.persistenceController = persistenceController
    }
}
