//
//  ProfileViewModel.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 04/08/23.
//

import Foundation
import CoreData
import WidgetKit

class ProfileViewModel: ObservableObject {
    
    @Published var profile: [Profile] = []
    
    init() {
        fetchProfileRequest()
    }

    func fetchProfileRequest() {
        let request = NSFetchRequest<Profile>(entityName: "Profile")
        
        do {
            profile = try PersistenceController.shared.container.viewContext.fetch(request)
            print("Fetch Success")
        } catch let error {
            print("Fetch Error: \(error)")
        }
    }
    
    func save() {
        do {
            try PersistenceController.shared.container.viewContext.save()
            fetchProfileRequest()
            WidgetCenter.shared.reloadAllTimelines()
            print("Data Saved")
        } catch {
            print("Could not save the data")
        }
    }
    
    func addProfile(minCalories: Double, minCarbs: Double, minFat: Double, minProtein: Double, weight: Double, height: Double, dateOfBirth: Date) {
        let profile = Profile(context: PersistenceController.shared.container.viewContext)
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
