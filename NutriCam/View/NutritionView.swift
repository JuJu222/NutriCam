//
//  NutritionView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 04/08/23.
//

import SwiftUI

struct NutritionView: View {
    
    @StateObject var vm: NutritionViewModel = NutritionViewModel()
    @State var meal: String = ""
    
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
                                    withAnimation {
                                        vm.currentDay = day
                                        vm.fetchDailyNutrition()
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    
                    HStack(spacing: 12) {
                        VStack(spacing: 12) {
                            ZStack {
                                CircularProgressView(progress: vm.dailyNutrition.calories / 2000)
                                    .frame(width: UIScreen.main.bounds.width / 2.5)
                                
                                VStack {
                                    Image(systemName: "flame.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 40)
                                        .foregroundColor(Color.accentColor)
                                    
                                    Text("\(vm.dailyNutrition.calories, specifier: "%.0f")")
                                        .font(.title)
                                        .bold()
                                    
                                    Text("/ 2000 kcal")
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
                            ProgressView(value: vm.dailyNutrition.protein, total: 60) {
                                HStack {
                                    Text("Protein")
                                        .font(.subheadline)
                                        .bold()
                                    Spacer()
                                    Text("\(vm.dailyNutrition.protein, specifier: "%.1f") / 60 g")
                                        .font(.subheadline)
                                }
                            }
                            ProgressView(value: vm.dailyNutrition.fat, total: 30) {
                                HStack {
                                    Text("Fat")
                                        .font(.subheadline)
                                        .bold()
                                    Spacer()
                                    Text("\(vm.dailyNutrition.fat, specifier: "%.1f") / 30 g")
                                        .font(.subheadline)
                                }
                            }
                            ProgressView(value: vm.dailyNutrition.carbs, total: 70) {
                                HStack {
                                    Text("Carbs")
                                        .font(.subheadline)
                                        .bold()
                                    Spacer()
                                    Text("\(vm.dailyNutrition.carbs, specifier: "%.1f") / 70 g")
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
                        AddMealCardView(showAddSheet: $vm.showAddSheet, vm: vm, meal: meal)
                    }
                    
                    Spacer()
                }
            }
            .background(Color("Background"))
            .navigationTitle("My Nutrition")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    DatePicker("", selection: $vm.currentDay, displayedComponents: .date)
                }
            }
            .onChange(of: vm.currentDay) { _ in
                vm.fetchCurrentWeek()
            }
            .fullScreenCover(isPresented: $vm.showAddSheet) {
                AddFoodCameraView(vm: vm)
            }
        }
    }
}

struct NutritionView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionView()
//            .preferredColorScheme(.dark)
    }
}
