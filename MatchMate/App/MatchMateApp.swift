//
//  MatchMateApp.swift
//  MatchMate
//
//  Created by Kishan Patel on 23/08/26.
//

import SwiftUI

@main
struct MatchMateApp: App {

    private let container =
        AppContainer.live()

    var body: some Scene {

        WindowGroup {
            ProfileListView(
                repository: container.repository
            )
        }
    }
}
