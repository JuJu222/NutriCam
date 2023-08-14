//
//  ConsumedFoodCardView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 11/08/23.
//

import SwiftUI

struct ConsumedFoodCardView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let food: FoodNutrition
    
    var body: some View {
        HStack {
            VStack (alignment: .leading, spacing: 6) {
                HStack {
                    Text("**\(food.name ?? "")** - \(food.weight, specifier: "%.1f") \(food.measure ?? "")")
                        .font(.title3)
                    Spacer()
                }
                
                HStack (spacing: 16) {
                    VStack (alignment: .leading) {
                        Text("Calories: \(food.calories, specifier: "%.0f") kcal")
                        Text("Protein: \(food.protein, specifier: "%.1f") g")
                    }
                    
                    Divider()
                        .frame(height: 28)
                        .background(.secondary)
                    
                    VStack (alignment: .leading) {
                        Text("Fat: \(food.fat, specifier: "%.1f") g")
                        Text("Carbs: \(food.carbs, specifier: "%.1f") g")
                    }
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            Spacer()
        }
        .padding()
        .background(colorScheme == .light ? .white : Color(UIColor.systemGray6))
        .cornerRadius(16)
    }
}

struct ConsumedFoodCardView_Previews: PreviewProvider {
    static var previews: some View {
        ConsumedFoodCardView(food: FoodNutrition())
    }
}
