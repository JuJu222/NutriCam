//
//  AddMealCardView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 05/08/23.
//

import SwiftUI

struct AddMealCardView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Binding var showAddSheet: Bool
    @ObservedObject var vm: NutritionViewModel
    
    let meal: String
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Image(systemName: meal == "Breakfast" ? "sun.and.horizon" : meal == "Lunch" ? "cloud.sun" : meal == "Dinner" ? "moon" : "takeoutbag.and.cup.and.straw")
                        .font(.title2)
                    Text(meal)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Spacer()
                    Button {
                        vm.selectedMeal = meal
                        showAddSheet.toggle()
                    } label: {
                        Label("Add", systemImage: "camera")
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(100)
                }
                .padding([.horizontal, .top])
                
                Divider()
                
                HStack(spacing: 12) {
                    VStack {
                        Text("Calories")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(meal == "Breakfast" ? "\(vm.breakfastNutrition.calories, specifier: "%.0f") kcal" : meal == "Lunch" ? "\(vm.lunchNutrition.calories, specifier: "%.0f") kcal" : meal == "Dinner" ? "\(vm.dinnerNutrition.calories, specifier: "%.0f") kcal" : "\(vm.snackNutrition.calories, specifier: "%.0f") kcal")
                    }
                    .frame(width: UIScreen.main.bounds.width / 4.5)
                    
                    VStack {
                        Text("Protein")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(meal == "Breakfast" ? "\(vm.breakfastNutrition.protein, specifier: "%.1f") g" : meal == "Lunch" ? "\(vm.lunchNutrition.protein, specifier: "%.1f") g" : meal == "Dinner" ? "\(vm.dinnerNutrition.protein, specifier: "%.1f") g" : "\(vm.snackNutrition.protein, specifier: "%.1f") g")
                    }
                    .frame(width: UIScreen.main.bounds.width / 5.7)
                    
                    VStack {
                        Text("Fat")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(meal == "Breakfast" ? "\(vm.breakfastNutrition.fat, specifier: "%.1f") g" : meal == "Lunch" ? "\(vm.lunchNutrition.fat, specifier: "%.1f") g" : meal == "Dinner" ? "\(vm.dinnerNutrition.fat, specifier: "%.1f") g" : "\(vm.snackNutrition.fat, specifier: "%.1f") g")
                    }
                    .frame(width: UIScreen.main.bounds.width / 5.7)
                    
                    VStack {
                        Text("Carbs")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(meal == "Breakfast" ? "\(vm.breakfastNutrition.carbs, specifier: "%.1f") g" : meal == "Lunch" ? "\(vm.lunchNutrition.carbs, specifier: "%.1f") g" : meal == "Dinner" ? "\(vm.dinnerNutrition.carbs, specifier: "%.1f") g" : "\(vm.snackNutrition.carbs, specifier: "%.1f") g")
                    }
                    .frame(width: UIScreen.main.bounds.width / 5.7)
                }
                .padding(.horizontal)
                
                Divider()
                
                ForEach(meal == "Breakfast" ? vm.breakfastFoods : meal == "Lunch" ? vm.lunchFoods : meal == "Dinner" ? vm.dinnerFoods : vm.snackFoods, id: \.self) { food in
                    if vm.isToday(date: food.date ?? Date())  {
                        HStack(alignment: .center, spacing: 2) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("**\(food.name ?? "")** - \(food.weight, specifier: "%.1f") \(food.measure ?? "Serving")")
                                    .font(.body)
                                    .fixedSize(horizontal: false, vertical: true)
                                HStack (spacing: 16) {
                                    VStack (alignment: .leading) {
                                        Text("Calories: \(food.calories, specifier: "%.0f") kcal")
                                        Text("Protein: \(food.protein, specifier: "%.1f") g")
                                    }
                                    
                                    Divider()
                                        .frame(height: 20)
                                        .background(.secondary)
                                    
                                    VStack (alignment: .leading) {
                                        Text("Fat: \(food.fat, specifier: "%.1f") g")
                                        Text("Carbs: \(food.carbs, specifier: "%.1f") g")
                                    }
                                }
                                .foregroundColor(.secondary)
                                .font(.footnote)
                            }
                            
                            Spacer()
                            
                            Button {
                                vm.selectedDeleteFood = food
                                vm.showDeleteAlert = true
                            } label: {
                                Image(systemName: "x.circle")
                                    .foregroundColor(.accentColor)
                                    .font(.headline)
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                }
                .padding([.horizontal, .bottom])
            }
        }
        .background(colorScheme == .light ? .white : Color(UIColor.systemGray6))
        .cornerRadius(16)
        .padding([.horizontal, .bottom])
    }
}

struct AddMealCardView_Previews: PreviewProvider {
    static var previews: some View {
        AddMealCardView(showAddSheet: .constant(false), vm: NutritionViewModel(), meal: "Breakfast")
    }
}
