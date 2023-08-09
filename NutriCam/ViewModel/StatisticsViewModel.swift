//
//  StatisticsViewModel.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 04/08/23.
//

import Foundation
import CoreData
import WidgetKit

class StatisticsViewModel: ObservableObject {
    @Published var foods: [FoodNutrition] = []
    
    init() {

    }

    func fetchFoodNutritionRequest() {
        let request = NSFetchRequest<FoodNutrition>(entityName: "FoodNutrition")
        let sort = NSSortDescriptor(key: "name", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            foods = try PersistenceController.shared.container.viewContext.fetch(request)
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
            try PersistenceController.shared.container.viewContext.save()
            fetchFoodNutritionRequest()
            WidgetCenter.shared.reloadAllTimelines()
            print("Data Saved")
        } catch {
            print("Could not save the data")
        }
    }
    
    func addFood(calories: Double, carbs: Double, fat: Double, protein: Double, name: String, meal: String, date: Date, weight: Double, measure: String) {
        let food = FoodNutrition(context: PersistenceController.shared.container.viewContext)
        food.id = UUID()
        food.calories = calories
        food.carbs = carbs
        food.fat = fat
        food.protein = protein
        food.name = name
        food.meal = meal
        food.date = date
        food.weight = weight
        food.measure = measure
        
        save()
    }
    
    // Dummy Function
    func deleteAll() {
        foods.forEach { food in
            PersistenceController.shared.container.viewContext.delete(food)
        }
        
        save()
    }
}
