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
    
    @Published var weight = ""
    @Published var height = ""
    @Published var gender = ""
    @Published var dateOfBirth = Date()
    @Published var calories = 0.0
    @Published var protein = 0.0
    @Published var fat = 0.0
    @Published var carbs = 0.0
    
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
    
    func addProfile(minCalories: Double, minCarbs: Double, minFat: Double, minProtein: Double, weight: Double, height: Double, dateOfBirth: Date, gender: String, recommendCalories: Double, recommendProtein: Double, recommendFat: Double, recommendCarbs: Double) {
        let profile = Profile(context: PersistenceController.shared.container.viewContext)
        profile.minCalories = minCalories
        profile.minCarbs = minCarbs
        profile.minFat = minFat
        profile.minProtein = minProtein
        profile.weight = weight
        profile.height = height
        profile.dateOfBirth = dateOfBirth
        profile.gender = gender
        profile.recommendCalories = recommendCalories
        profile.recommendProtein = recommendProtein
        profile.recommendFat = recommendFat
        profile.recommendCarbs = recommendCarbs
        
        save()
    }
    
    func editProfile(profile: Profile, minCalories: Double, minCarbs: Double, minFat: Double, minProtein: Double, weight: Double, height: Double, dateOfBirth: Date, gender: String, recommendCalories: Double, recommendProtein: Double, recommendFat: Double, recommendCarbs: Double) {
        profile.minCalories = minCalories
        profile.minCarbs = minCarbs
        profile.minFat = minFat
        profile.minProtein = minProtein
        profile.weight = weight
        profile.height = height
        profile.dateOfBirth = dateOfBirth
        profile.gender = gender
        profile.recommendCalories = recommendCalories
        profile.recommendProtein = recommendProtein
        profile.recommendFat = recommendFat
        profile.recommendCarbs = recommendCarbs
        
        save()
    }
    
    func countRecommendNutrition(gender: String, age: Double, weight: Double, height: Double) -> Nutrition {
        var calories = 0.0
        
        if gender == "Male" {
            calories = (88.4 + 13.4 * weight) + (4.8 * height) - (5.68 * age)
        } else {
            calories = (447.6 + 9.25 * weight) + (3.1 * height) - (4.33 * age)
        }
        
        let protein = (calories * 0.15) / 4.0
        let fat = (calories * 0.2) / 4.0
        let carbs = (calories * 0.65) / 4.0
        
        return Nutrition(calories: calories, protein: protein, fat: fat, carbs: carbs)
    }
    
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
}
