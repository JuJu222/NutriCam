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
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some Scene {
        WindowGroup {
            if currentPage > 4 {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                OnBoardingView()
            }
        }
    }
}
