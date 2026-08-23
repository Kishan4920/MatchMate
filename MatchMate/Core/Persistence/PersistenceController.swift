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
        
        container.loadPersistentStores { _, error in
            if let error {
                fatalError(
                    "Core Data failed to load: \(error)"
                )
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy =
        NSMergeByPropertyObjectTrumpMergePolicy
    }
}
