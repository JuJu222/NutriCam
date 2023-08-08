//
//  FoodNutritionResultView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 05/08/23.
//

import SwiftUI

struct FoodNutritionResultView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var vm: NutritionViewModel
    let food: Hint
    
    @State var weightPer: Double = 0
    
    @State var weight: Double = 0
    @State var selectedMeasure: String = ""
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: food.food?.image ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(16)

            } placeholder: {
                Color.gray
                    .frame(height: 200)
            }
            .padding(.horizontal)
            
            HStack(spacing: 8) {
                TextField("Weight", value: $weight, format: .number)
                    .frame(width: UIScreen.main.bounds.width / 5)
                    .padding(14)
                    .background(colorScheme == .dark ? Color(UIColor.systemGray6) : .white)
                    .cornerRadius(8)
                
                Picker("Measure", selection: $selectedMeasure) {
                    ForEach(food.measures ?? [], id: \.self) { measure in
                        Text(measure.label ?? "")
                    }
                }
                .padding(8)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(8)
            }
            .padding()
            
            List {
                Section(header: Text("Nutrients")) {
                    HStack {
                        Text("Calories")
                        
                        Spacer()
                        
                        Text("\(String(format: "%.0f", food.food?.nutrients?.ENERC_KCAL ?? 0)) kcal")
                    }
                    
                    HStack {
                        Text("Protein")
                        
                        Spacer()
                        
                        Text("\(String(format: "%.2f", food.food?.nutrients?.PROCNT ?? 0)) g")
                    }
                    
                    HStack {
                        Text("Fat")
                        
                        Spacer()
                        
                        Text("\(String(format: "%.2f", food.food?.nutrients?.FAT ?? 0)) g")
                    }
                    
                    HStack {
                        Text("Carbohydrates")
                        
                        Spacer()
                        
                        Text("\(String(format: "%.2f", food.food?.nutrients?.CHOCDF ?? 0)) g")
                    }
                }
            }
            .scrollContentBackground(.hidden)
            
            Spacer()
            
            Button {
                vm.addFood(calories: food.food?.nutrients?.ENERC_KCAL ?? 0, carbs: food.food?.nutrients?.CHOCDF ?? 0, fat: food.food?.nutrients?.FAT ?? 0, protein: food.food?.nutrients?.PROCNT ?? 0, name: food.food?.label ?? "Food Name", meal: vm.selectedMeal, date: Date())
                
                vm.showAddSheet.toggle()
            } label: {
                HStack {
                    Spacer()
                    Text("Add to My Nutrition")
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                }
                .padding()
                .background(Color.accentColor)
                .cornerRadius(100)
                .padding()
            }
        }
        .background(Color("Background"))
        .navigationTitle(food.food?.label ?? "Food Name")
        .onAppear {
            food.measures?.forEach({ measure in
                weightPer = measure.weight ?? 0
            })
        }
    }
}

struct FoodNutritionResultView_Previews: PreviewProvider {
    static var previews: some View {
        FoodNutritionResultView(vm: NutritionViewModel(), food: Hint())
    }
}
