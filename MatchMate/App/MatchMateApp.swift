//
//  MatchMateApp.swift
//  MatchMate
//
//  Created by Kishan Patel on 23/08/26.
//

import SwiftUI

@main
struct MatchMateApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


struct ContentView: View {

    var body: some View {
        Text("Testing API...")
            .task {
                do {
                    let client = URLSessionAPIClient()

                    let response = try await client.fetchProfiles(
                        page: 1,
                        results: 10
                    )

                    print("Profiles:", response.results.count)
                    print("Page:", response.info.page)

                    if let first = response.results.first {
                        print(first.login.uuid)
                        print(first.name.first)
                        print(first.picture.large)
                    }

                } catch {
                    print("API ERROR:", error)
                }
            }
    }
}
