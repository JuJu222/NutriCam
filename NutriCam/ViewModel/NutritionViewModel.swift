//
//  NutritionViewModel.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 04/08/23.
//

import Foundation
import CoreData
import WidgetKit

class NutritionViewModel: ObservableObject {
    @Published var showAddSheet: Bool = false
    @Published var selectedMeal: String = ""
    
    @Published var foods: [FoodNutrition] = []
    @Published var dailyFoods: [FoodNutrition] = []
    @Published var breakfastFoods: [FoodNutrition] = []
    @Published var lunchFoods: [FoodNutrition] = []
    @Published var dinnerFoods: [FoodNutrition] = []
    @Published var snackFoods: [FoodNutrition] = []
    
    @Published var currentWeek: [Date] = []
    @Published var currentDay: Date = Date().midnight()
    
    @Published var foodName: String = ""
    @Published var hintFoods: [Hint] = []
    
    @Published var dailyNutrition: Nutrition = Nutrition()
    @Published var breakfastNutrition: Nutrition = Nutrition()
    @Published var lunchNutrition: Nutrition = Nutrition()
    @Published var dinnerNutrition: Nutrition = Nutrition()
    @Published var snackNutrition: Nutrition = Nutrition()
    
    init() {
        fetchFoodNutritionRequest()
        
        fetchCurrentWeek()
        
        fetchDailyNutrition()
    }

    func fetchFoodNutritionRequest() {
        let request = NSFetchRequest<FoodNutrition>(entityName: "FoodNutrition")
        let sort = NSSortDescriptor(key: "name", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            foods = try PersistenceController.shared.container.viewContext.fetch(request)
            print("Daily Foods: \(foods)")
        } catch let error {
            print("Fetch Error: \(error)")
        }
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
    
    func addFood(calories: Double, carbs: Double, fat: Double, protein: Double, name: String, meal: String, date: Date) {
        let food = FoodNutrition(context: PersistenceController.shared.container.viewContext)
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
    
    func deleteFood(food: FoodNutrition) {
        PersistenceController.shared.container.viewContext.delete(food)
        
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
    
    func fetchEdamamFoods() {
        guard let url = URL(string: "https://api.edamam.com/api/food-database/v2/parser?app_id=\(appId)&app_key=\(appKey)&ingr=\(foodName)&nutrition-type=cooking") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let food = try JSONDecoder().decode(Food.self, from: data)
                DispatchQueue.main.async {
                    self?.hintFoods = food.hints ?? []
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    func fetchDailyNutrition() {
        let request = NSFetchRequest<FoodNutrition>(entityName: "FoodNutrition")
        request.predicate = NSPredicate(format: "date >= %@", currentDay as CVarArg)
        
        do {
            dailyFoods = try PersistenceController.shared.container.viewContext.fetch(request)
            print("Daily Nutritions: \(dailyFoods)")
            
            countNutrition()
        } catch let error {
            print("Fetch Error: \(error)")
        }
    }
    
    func countNutrition() {
        breakfastFoods = []
        lunchFoods = []
        dinnerFoods = []
        snackFoods = []
        
        dailyNutrition = Nutrition()
        breakfastNutrition = Nutrition()
        lunchNutrition = Nutrition()
        dinnerNutrition = Nutrition()
        snackNutrition = Nutrition()

        dailyFoods.forEach { food in
            dailyNutrition.calories += food.calories
            dailyNutrition.protein += food.protein
            dailyNutrition.fat += food.fat
            dailyNutrition.carbs += food.carbs
            
            if food.meal == "Breakfast" {
                breakfastFoods.append(food)
                breakfastNutrition.calories += food.calories
                breakfastNutrition.protein += food.protein
                breakfastNutrition.fat += food.fat
                breakfastNutrition.carbs += food.carbs
            } else if food.meal == "Lunch" {
                lunchFoods.append(food)
                lunchNutrition.calories += food.calories
                lunchNutrition.protein += food.protein
                lunchNutrition.fat += food.fat
                lunchNutrition.carbs += food.carbs
            } else if food.meal == "Dinner" {
                dinnerFoods.append(food)
                dinnerNutrition.calories += food.calories
                dinnerNutrition.protein += food.protein
                dinnerNutrition.fat += food.fat
                dinnerNutrition.carbs += food.carbs
            } else {
                snackFoods.append(food)
                snackNutrition.calories += food.calories
                snackNutrition.protein += food.protein
                snackNutrition.fat += food.fat
                snackNutrition.carbs += food.carbs
            }
        }
    }
}
