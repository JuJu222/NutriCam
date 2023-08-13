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
    
    @Published var chartDatas: [ChartData] = []
    
    @Published var startDate = Date().midnight()
    @Published var endDate = Date().midnight()
    
    init() {
        countSevenDays(type: "End")
        fetchWeeklyNutritionDataRequest()
    }

    func fetchWeeklyNutritionDataRequest() {
        let request = NSFetchRequest<FoodNutrition>(entityName: "FoodNutrition")
        
        request.predicate = NSPredicate(format: "date >= %@ && date <= %@", startDate as CVarArg, Calendar.current.startOfDay(for: endDate + 86400) as CVarArg)
        
        let sort = NSSortDescriptor(key: "date", ascending: true)
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
    
    func countSevenDays(type: String) {
        if type == "Start" {
            let tempDate = Calendar.current.date(byAdding: .day, value: 6, to: startDate) ?? Date()
            if tempDate > Date() {
                startDate = Date()
                startDate = Calendar.current.date(byAdding: .day, value: -6, to: startDate) ?? Date()
            }
            
            endDate = startDate
            endDate = Calendar.current.date(byAdding: .day, value: 6, to: endDate) ?? Date()
        } else {
            startDate = endDate
            startDate = Calendar.current.date(byAdding: .day, value: -6, to: startDate) ?? Date()
        }
    }
    
    func countAverageNutrition() -> Nutrition {
        var avgNutrition = Nutrition()
        
        foods.forEach { food in
            avgNutrition.calories += food.calories
            avgNutrition.protein += food.protein
            avgNutrition.fat += food.fat
            avgNutrition.carbs += food.carbs
        }
        
        avgNutrition.calories = avgNutrition.calories / 7
        avgNutrition.protein = avgNutrition.protein / 7
        avgNutrition.fat = avgNutrition.fat / 7
        avgNutrition.carbs = avgNutrition.carbs / 7
        
        return avgNutrition
    }
    
    func makeChartData() {
        chartDatas = []
        var tempDate = startDate
        
        while tempDate <= endDate {
            var nutrition = Nutrition()
            foods.forEach { food in
                if isSameDate(tempDate: tempDate, foodDate: food.date ?? Date()) {
                    nutrition.calories += food.calories
                    nutrition.protein += food.protein
                    nutrition.fat += food.fat
                    nutrition.carbs += food.carbs
                }
            }
            chartDatas.append(ChartData(date: tempDate, nutritions: nutrition))
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate) ?? Date()
        }
        print(chartDatas.last?.date)
        print(chartDatas.last?.nutritions)
    }
    
    func isSameDate(tempDate: Date, foodDate: Date) -> Bool {
        let calendar = Calendar.current

        return calendar.isDate(tempDate, inSameDayAs: foodDate)
    }
    
    // Dummy Function
    func save() {
        do {
            try PersistenceController.shared.container.viewContext.save()
            fetchWeeklyNutritionDataRequest()
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

    func deleteAll() {
        foods.forEach { food in
            PersistenceController.shared.container.viewContext.delete(food)
        }
        
        save()
    }
}
