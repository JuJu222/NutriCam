//
//  NutritionViewModel.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 04/08/23.
//

import Foundation
import CoreData

class NutritionViewModel: ObservableObject {
    
    @Published var foods: [FoodNutrition] = []
    
    @Published var currentWeek: [Date] = []
    @Published var currentDay: Date = Date()
    
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
        
        fetchFoodNutritionRequest()
        
        fetchCurrentWeek()
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
    
//    func editFood(food: FoodNutrition, calories: Double, carbs: Double, fat: Double, protein: Double, name: String, meal: String, date: Date) {
//        food.calories = calories
//        food.carbs = carbs
//        food.fat = fat
//        food.protein = protein
//        food.name = name
//        food.meal = meal
//        food.date = date
//
//        save()
//    }
    
    func deleteFood(food: FoodNutrition) {
        container.viewContext.delete(food)
        
        save()
    }
    
    func fetchCurrentWeek() {
        self.currentWeek = []
        
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: self.currentDay)
        
        guard let firstWeekDay = week?.start else {
            return
        }
        
        (0...6).forEach { day in
            if var weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                weekday = calendar.date(byAdding: .hour, value: 7, to: weekday) ?? Date()
                currentWeek.append(weekday)
            }
        }
    }
    
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current

        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    // Dummy Function
    func deleteAll() {
        foods.forEach { food in
            container.viewContext.delete(food)
        }
        
        save()
    }
}
