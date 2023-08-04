//
//  ProfileViewModel.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 04/08/23.
//

import Foundation
import CoreData

class ProfileViewModel: ObservableObject {
    
    @Published var profile: [Profile] = []
    
    let container: NSPersistentCloudKitContainer
    
    init() {
        container = NSPersistentCloudKitContainer(name: "Profile")
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        fetchProfileRequest()
    }

    func fetchProfileRequest() {
        let request = NSFetchRequest<Profile>(entityName: "Profile")
        
        do {
            profile = try container.viewContext.fetch(request)
            print("Fetch Success")
        } catch let error {
            print("Fetch Error: \(error)")
        }
    }
    
    func save() {
        do {
            try container.viewContext.save()
            fetchProfileRequest()
            print("Data Saved")
        } catch {
            print("Could not save the data")
        }
    }
    
    func addProfile(minCalories: Double, minCarbs: Double, minFat: Double, minProtein: Double, weight: Double, height: Double, dateOfBirth: Date) {
        let profile = Profile(context: container.viewContext)
        profile.minCalories = minCalories
        profile.minCarbs = minCarbs
        profile.minFat = minFat
        profile.minProtein = minProtein
        profile.weight = weight
        profile.height = height
        profile.dateOfBirth = dateOfBirth
        
        save()
    }
    
    func editProfile(profile: Profile, minCalories: Double, minCarbs: Double, minFat: Double, minProtein: Double, weight: Double, height: Double, dateOfBirth: Date) {
        profile.minCalories = minCalories
        profile.minCarbs = minCarbs
        profile.minFat = minFat
        profile.minProtein = minProtein
        profile.weight = weight
        profile.height = height
        profile.dateOfBirth = dateOfBirth
        
        save()
    }
}
