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
    
    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(Color("AccentColor"))
    }
    
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
                                    }
                                }
                            }
                        }
                        .padding()
                        .frame(width: UIScreen.main.bounds.width)
                    }
                    
                    HStack(spacing: 8) {
                        ZStack {
                            CircularProgressView(progress: vm.dailyNutrition.calories / (vm.profile.first?.minCalories ?? 0))
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
                                
                                Text("/ \(vm.profile.first?.minCalories ?? 0, specifier: "%.0f") kcal")
                                    .font(.subheadline)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 24) {
                            ProgressView(value: vm.dailyNutrition.protein <= vm.profile.first?.minProtein ?? 300 ? vm.dailyNutrition.protein : vm.profile.first?.minProtein ?? 0, total: vm.profile.first?.minProtein ?? 0) {
                                HStack {
                                    Text("Protein")
                                        .font(.subheadline)
                                        .bold()
                                    Spacer()
                                    Text("\(vm.dailyNutrition.protein, specifier: "%.1f") / \(vm.profile.first?.minProtein ?? 0, specifier: "%.1f") g")
                                        .font(.subheadline)
                                }
                            }
                            ProgressView(value: vm.dailyNutrition.fat <= vm.profile.first?.minFat ?? 300 ? vm.dailyNutrition.fat : vm.profile.first?.minFat ?? 0, total: vm.profile.first?.minFat ?? 0) {
                                HStack {
                                    Text("Fat")
                                        .font(.subheadline)
                                        .bold()
                                    Spacer()
                                    Text("\(vm.dailyNutrition.fat, specifier: "%.1f") / \(vm.profile.first?.minFat ?? 0, specifier: "%.1f") g")
                                        .font(.subheadline)
                                }
                            }
                            ProgressView(value: vm.dailyNutrition.carbs <= vm.profile.first?.minCarbs ?? 300 ? vm.dailyNutrition.carbs : vm.profile.first?.minCarbs ?? 0, total: vm.profile.first?.minCarbs ?? 0) {
                                HStack {
                                    Text("Carbs")
                                        .font(.subheadline)
                                        .bold()
                                    Spacer()
                                    Text("\(vm.dailyNutrition.carbs, specifier: "%.1f") / \(vm.profile.first?.minCarbs ?? 0, specifier: "%.1f") g")
                                        .font(.subheadline)
                                }
                            }
                        }
                        .padding(.bottom, 12)
                    }
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(vm.extractDate(date: vm.currentDay, format: "dd MMM yyyy"))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "calendar")
                      .font(.headline)
                      .foregroundColor(.accentColor)
                      .overlay{
                         DatePicker(
                             "Select Date",
                             selection: $vm.currentDay,
                             in: ...Date(),
                             displayedComponents: .date
                         )
                          .blendMode(.destinationOver)
                      }
                }
            }
            .onChange(of: vm.currentDay) { _ in
                vm.fetchCurrentWeek()
                withAnimation {
                    vm.fetchDailyNutrition()
                }
            }
            .fullScreenCover(isPresented: $vm.showAddSheet) {
                AddFoodCameraView(vm: vm)
            }
            .onAppear {
                vm.fetchProfileRequest()
            }
            .alert(isPresented: $vm.showDeleteAlert) {
                Alert(title: Text("Delete food?"), message: Text("This will affect your total daily nutrition"), primaryButton: .destructive(Text("Delete")) {
                    vm.deleteFood(food: vm.selectedDeleteFood)
                },
                secondaryButton: .cancel(Text("Cancel")))
            }
        }
    }
}

struct NutritionView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionView()
    }
}
