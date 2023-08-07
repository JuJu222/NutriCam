//
//  WidgetService.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 06/08/23.
//

import Foundation
import CoreData

final class WidgetService {
    static let shared = WidgetService()
    
    var dailyFoods: [FoodNutrition] = []
    var nutrition: Nutrition = Nutrition()
    
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
    }
    
    func fetchFoodNutritionRequest() {
        let request = NSFetchRequest<FoodNutrition>(entityName: "FoodNutrition")
        request.predicate = NSPredicate(format: "date >= %@", Date().midnight() as CVarArg)
        
        do {
            dailyFoods = try container.viewContext.fetch(request)
            print("Daily Nutritions: \(dailyFoods)")
            
            dailyFoods.forEach { food in
                nutrition.calories += food.calories
                nutrition.protein += food.protein
                nutrition.fat += food.fat
                nutrition.carbs += food.carbs
            }
        } catch let error {
            print("Fetch Error: \(error)")
        }
    }
}
