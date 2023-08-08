//
//  FoodPersistenceController.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 07/08/23.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentCloudKitContainer
    
    init() {
        container = NSPersistentCloudKitContainer(name: "NutriCamData")
        
        let url = URL.storeURL(for: "group.NutriCam", databaseName: "NutriCamData")
        let storeDescription = NSPersistentStoreDescription(url: url)
        container.persistentStoreDescriptions = [storeDescription]
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
