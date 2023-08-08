//
//  NutriCamApp.swift
//  NutriCam
//
//  Created by Yap Justin on 28/07/23.
//

import SwiftUI

@main
struct NutriCamApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
