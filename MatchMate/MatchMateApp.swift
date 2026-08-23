//
//  MatchMateApp.swift
//  MatchMate
//
//  Created by Kishan Patel on 23/08/26.
//

import SwiftUI
import CoreData

@main
struct MatchMateApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
