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
    
    @State var measures: [Measure] = []
    
    @State var weightPerMeasure: Double = 0
    @State var nutritionPerGram: Nutrition = Nutrition()
    
    @State var weight: Double = 1
    @State var selectedMeasure: String = "Serving"
    
    @State var labels: [String] = []
    
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
                    .cornerRadius(16)
            }
            .padding(.horizontal)
            
            HStack(spacing: 8) {
                TextField("Weight", value: $weight, format: .number)
                    .frame(width: UIScreen.main.bounds.width / 5)
                    .padding(14)
                    .background(colorScheme == .dark ? Color(UIColor.systemGray6) : .white)
                    .cornerRadius(8)
                    .keyboardType(.numberPad)
                
                Picker("Measure", selection: $selectedMeasure) {
                    ForEach(labels, id: \.self) { label in
                        Text(label)
                    }
                }
                .padding(8)
                .background(colorScheme == .dark ? Color(UIColor.systemGray6) : .white)
                .cornerRadius(8)
            }
            .padding()
            
            Text("\(weightPerMeasure, specifier: "%.1f") grams per \(selectedMeasure)")
            
            List {
                Section(header: Text("Nutrients")) {
                    HStack {
                        Text("Calories")
                        
                        Spacer()
                        
                        Text("\(String(format: "%.0f", nutritionPerGram.calories * weightPerMeasure * weight)) kcal")
                    }
                    
                    HStack {
                        Text("Protein")
                        
                        Spacer()
                        
                        Text("\(String(format: "%.1f", nutritionPerGram.protein * weightPerMeasure * weight)) g")
                    }
                    
                    HStack {
                        Text("Fat")
                        
                        Spacer()
                        
                        Text("\(String(format: "%.1f", nutritionPerGram.fat * weightPerMeasure * weight)) g")
                    }
                    
                    HStack {
                        Text("Carbohydrates")
                        
                        Spacer()
                        
                        Text("\(String(format: "%.1f", nutritionPerGram.carbs * weightPerMeasure * weight)) g")
                    }
                }
            }
            .scrollContentBackground(.hidden)
            
            Spacer()
            
            Button {
                vm.addFood(
                    calories: nutritionPerGram.calories * weightPerMeasure * weight,
                    carbs: nutritionPerGram.carbs * weightPerMeasure * weight,
                    fat: nutritionPerGram.fat * weightPerMeasure * weight,
                    protein: nutritionPerGram.protein * weightPerMeasure * weight,
                    name: food.food?.label ?? "Food Name",
                    meal: vm.selectedMeal,
                    date: vm.currentDay,
                    weight: weight,
                    measure: selectedMeasure
                )
                
                vm.fetchDailyNutrition()
                
                vm.showAddSheet.toggle()
            } label: {
                HStack {
                    Spacer()
                    Text("Add to My Nutrition")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.vertical, 12)
                    Spacer()
                }
                .background(Color.accentColor)
                .cornerRadius(100)
                .padding()
            }
        }
        .background(Color("Background"))
        .navigationTitle(food.food?.label ?? "Food Name")
        .onAppear {
            measures = food.measures ?? []
            
            measures.forEach { measure in
                if let label = measure.label {
                    labels.append(label)
                }
            }
            
            if !labels.contains("Serving") {
                measures.insert(Measure(label: "Serving", weight: 100), at: 0)
                labels.insert("Serving", at: 0)
            }
            
            nutritionPerGram = vm.countNutritionPerGram(calories: food.food?.nutrients?.ENERC_KCAL ?? 0, protein: food.food?.nutrients?.PROCNT ?? 0, fat: food.food?.nutrients?.FAT ?? 0, carbs: food.food?.nutrients?.CHOCDF ?? 0, weight: measures.first?.weight ?? 100)
            
            weightPerMeasure = measures.first?.weight ?? 100
        }
        .onChange(of: selectedMeasure) { newValue in
            measures.forEach({ measure in
                if measure.label == selectedMeasure {
                    weightPerMeasure = measure.weight ?? 100
                }
            })
        }
    }
}

struct FoodNutritionResultView_Previews: PreviewProvider {
    static var previews: some View {
        FoodNutritionResultView(vm: NutritionViewModel(), food: Hint())
    }
}
