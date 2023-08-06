//
//  StatisticsViewModel.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 04/08/23.
//

import Foundation
import CoreData

class StatisticsViewModel: ObservableObject {
    @Published var foods: [FoodNutrition] = []
    
    let container: NSPersistentCloudKitContainer
    
    init() {
        container = NSPersistentCloudKitContainer(name: "NutriCamData")
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
//        fetchFoodNutritionRequest()
    }

    func fetchFoodNutritionRequest() {
        let request = NSFetchRequest<FoodNutrition>(entityName: "FoodNutrition")
        let sort = NSSortDescriptor(key: "name", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            foods = try container.viewContext.fetch(request)
            print("Fetch Success")
        } catch let error {
            print("Fetch Error: \(error)")
        }
    }
    
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    func save() {
        do {
            try container.viewContext.save()
            fetchFoodNutritionRequest()
            print("Data Saved")
        } catch {
            print("Could not save the data")
        }
    }
    
    func addFood(calories: Double, carbs: Double, fat: Double, protein: Double, name: String, meal: String, date: Date) {
        let food = FoodNutrition(context: container.viewContext)
        food.id = UUID()
        food.calories = calories
        food.carbs = carbs
        food.fat = fat
        food.protein = protein
        food.name = name
        food.meal = meal
        food.date = date
        
        save()
    }
    
    // Dummy Function
    func deleteAll() {
        foods.forEach { food in
            container.viewContext.delete(food)
        }
        
        save()
    }
}
