//
//  PersistenceController.swift
//  MatchMate
//
//  Created by Kishan Patel on 23/08/26.
//

import CoreData

final class PersistenceController {

    static let shared = PersistenceController()

    let container: NSPersistentContainer

    var context: NSManagedObjectContext {
        container.viewContext
    }

    init(inMemory: Bool = false) {

        container = NSPersistentContainer(
            name: "MatchMateModel"
        )

        if inMemory {
            container.persistentStoreDescriptions.first?
                .url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in

            if let error = error {
                print("❌ Core Data failed:")
                print(error)
                print(error.localizedDescription)
                return
            }

            print("✅ Core Data loaded successfully")
            print("Store:", description.url?.absoluteString ?? "")
        }

        container.viewContext
            .automaticallyMergesChangesFromParent = true

        container.viewContext.mergePolicy =
            NSMergeByPropertyObjectTrumpMergePolicy
    }
}
