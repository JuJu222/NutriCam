//
//  NutritionView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 04/08/23.
//

import SwiftUI

struct NutritionView: View {
    
    @StateObject var vm: NutritionViewModel = NutritionViewModel()
    var meals = ["Breakfast", "Lunch", "Dinner", "Snacks"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack (spacing: 8) {
                            ForEach(vm.currentWeek, id: \.self) { day in
                                VStack (spacing: 8) {
                                    Text(vm.extractDate(date: day, format: "EEE"))
                                        .font(.system(size: 14))
                                        .foregroundColor(vm.isToday(date: day) ? Color.accentColor : .secondary)
                                    
                                    Text(vm.extractDate(date: day, format: "dd"))
                                        .font(.system(size: 16))
                                        .foregroundColor(vm.isToday(date: day) ? .white : .secondary)
                                        .bold()
                                        .padding(8)
                                        .background(
                                            ZStack {
                                                if vm.isToday(date: day) {
                                                    Circle()
                                                        .fill(Color.accentColor)
                                                }
                                            }
                                        )
                                }
                                .foregroundStyle(vm.isToday(date: day) ? .primary : .secondary)
                                .frame(width: 45, height: 60)
                                .onTapGesture {
                                    vm.currentDay = day
                                }
                            }
                        }
                        .padding()
                    }
                    
                    HStack(spacing: 12) {
                        VStack(spacing: 12) {
                            ZStack {
                                CircularProgressView(progress: 0.5)
                                    .frame(width: UIScreen.main.bounds.width / 2.5)
                                
                                VStack {
                                    Image(systemName: "flame.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 40)
                                        .foregroundColor(Color.accentColor)
                                    
                                    Text("2000")
                                        .font(.title)
                                        .bold()
                                    
                                    Text("/ 4000 kcal")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Text("Calories")
                                .font(.subheadline)
                                .bold()
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 24) {
                            ProgressView(value: 7, total: 10) {
                                HStack {
                                    Text("Protein")
                                        .font(.subheadline)
                                        .bold()
                                    Spacer()
                                    Text("7 / 10 g")
                                        .font(.subheadline)
//                                    Text("\(content.nutrientConsumed, specifier: "%.2f") / \(content.nutrientTarget, specifier: "%.2f") g")
                                }
                            }
                            ProgressView(value: 4, total: 10) {
                                HStack {
                                    Text("Carbs")
                                        .font(.subheadline)
                                        .bold()
                                    Spacer()
                                    Text("4 / 10 g")
                                        .font(.subheadline)
                                }
                            }
                            ProgressView(value: 5, total: 10) {
                                HStack {
                                    Text("Fat")
                                        .font(.subheadline)
                                        .bold()
                                    Spacer()
                                    Text("5 / 10 g")
                                        .font(.subheadline)
                                }
                            }
                        }
                    }
//                    .padding()
//                    .background(.white)
//                    .cornerRadius(16)
                    .padding([.horizontal, .bottom])
                    
                    ForEach(meals, id: \.self) { meal in
                        AddMealCardView(meal: meal)
                    }
                    
                    Spacer()
                }
            }
            .background(Color("Background"))
            .navigationTitle("Nutrition")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    DatePicker("", selection: $vm.currentDay, displayedComponents: .date)
                }
            }
            .onChange(of: vm.currentDay) { _ in
                vm.fetchCurrentWeek()
            }
        }
        
//        VStack {
//            HStack {
//                Button("Add Examples") {
//                    vm.addFood(calories: 400, carbs: 20, fat: 10, protein: 5, name: "Rendang", meal: "Breakfast", date: Date())
//                    print("Tes add \(vm.foods)")
//                }
//
//                Spacer()
//
//                Button("Delete All") {
//                    vm.deleteAll()
//                }
//                .foregroundColor(.red)
//            }
//
//            List {
//                ForEach(vm.foods) { food in
//                    Section(vm.extractDate(date: food.date ?? Date(), format: "E, dd MMM yyyy")) {
//                        VStack(spacing: 10) {
//                            Text("\(food.calories)")
//                            Text("\(food.fat)")
//                            Text("\(food.protein)")
//                            Text("\(food.carbs)")
//                        }
//                    }
//                }
//            }
//        }
//        .padding()
    }
}

struct NutritionView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionView()
//            .preferredColorScheme(.dark)
    }
}
