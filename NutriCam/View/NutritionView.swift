//
//  NutritionView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 04/08/23.
//

import SwiftUI

struct NutritionView: View {
    
    @StateObject var vm: NutritionViewModel = NutritionViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Button("Add Examples") {
                    vm.addFood(calories: 400, carbs: 20, fat: 10, protein: 5, name: "Rendang", meal: "Breakfast", date: Date())
                    print("Tes add \(vm.foods)")
                }
                
                Spacer()
                
                Button("Delete All") {
                    vm.deleteAll()
                }
                .foregroundColor(.red)
            }
            
            List {
                ForEach(vm.foods) { food in
                    Section(vm.extractDate(date: food.date ?? Date(), format: "E, dd MMM yyyy")) {
                        VStack(spacing: 10) {
                            Text("\(food.calories)")
                            Text("\(food.fat)")
                            Text("\(food.protein)")
                            Text("\(food.carbs)")
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct NutritionView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionView()
    }
}
