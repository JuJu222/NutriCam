//
//  StatisticsView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 04/08/23.
//

import SwiftUI
import Charts

struct StatisticsView: View {

    @StateObject var vm: StatisticsViewModel = StatisticsViewModel()
    @State var tab = 0
    
    @State var avgNutrition: Nutrition = Nutrition()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    HStack {
                        DatePicker("Start", selection: $vm.startDate, in: ...Date.now, displayedComponents: .date)
                        
                        Spacer()
                        
                        DatePicker(" End", selection: $vm.endDate, in: ...Date.now, displayedComponents: .date)
                    }
                    .padding(.vertical, 8)
                    
                    Picker("", selection: $tab) {
                        Text("Calories").tag(0)
                        Text("Protein").tag(1)
                        Text("Fat").tag(2)
                        Text("Carbs").tag(3)
                    }
                    .pickerStyle(.segmented)
                    
                    if tab == 0 {
                        HStack {
                            Text("Avg. Calories: **\(avgNutrition.calories, specifier: "%.0f") Kcal**")
                                .padding(.vertical, 12)
                            Spacer()
                        }
                        Chart(vm.foods) {
                            BarMark(x: .value("Date", vm.extractDate(date: $0.date ?? Date(), format: "dd MM yyyy")), y: .value("Calories (Kcal)", $0.calories)
                            )
                            .cornerRadius(4)
                        }
                        .frame(height: 200)
                    } else if tab == 1 {
                        HStack {
                            Text("Avg. Protein: **\(avgNutrition.protein, specifier: "%.1f") g**")
                                .padding(.vertical, 12)
                            Spacer()
                        }
                        Chart(vm.foods) {
                            BarMark(x: .value("Date", vm.extractDate(date: $0.date ?? Date(), format: "dd MM yyyy")), y: .value("Protein (g)", $0.protein)
                            )
                            .cornerRadius(4)
                        }
                        .frame(height: 200)
                    } else if tab == 2 {
                        HStack {
                            Text("Avg. Fat: **\(avgNutrition.fat, specifier: "%.1f") g**")
                                .padding(.vertical, 12)
                            Spacer()
                        }
                        Chart(vm.foods) {
                            BarMark(x: .value("Date", vm.extractDate(date: $0.date ?? Date(), format: "dd MM yyyy")), y: .value("Fat (g)", $0.fat)
                            )
                            .cornerRadius(4)
                        }
                        .frame(height: 200)
                    } else {
                        HStack {
                            Text("Avg. Carbs: **\(avgNutrition.carbs, specifier: "%.1f") g**")
                                .padding(.vertical, 12)
                            Spacer()
                        }
                        Chart(vm.foods) {
                            BarMark(x: .value("Date", vm.extractDate(date: $0.date ?? Date(), format: "dd MM yyyy")), y: .value("Carbs (g)", $0.carbs)
                            )
                            .cornerRadius(4)
                        }
                        .frame(height: 200)
                    }
    
                    VStack (alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "fork.knife.circle")
                                .font(.title)
                                .fontWeight(.semibold)
                            Text("Consumed Food")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        Text("Here are some foods that you've eaten during this week.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 4)
                        
                        VStack(spacing: 12) {
                            ForEach(vm.foods.prefix(3)) { food in
                                ConsumedFoodCardView(food: food)
                            }
                            
                            NavigationLink(destination: ConsumedFoodView(vm: vm)) {
                                HStack {
                                    Text("See All Consumed Foods")
                                    Image(systemName: "chevron.right")
                                }
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.vertical, 8)
                            }
                        }
                    }
                    .padding(.vertical, 12)
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            .background(Color("Background"))
            .navigationTitle("Statistics")
            .onAppear {
                vm.fetchWeeklyNutritionDataRequest()
                avgNutrition = vm.countAverageNutrition()
            }
            .onChange(of: vm.startDate) { newValue in
                vm.countSevenDays(type: "Start")
                vm.fetchWeeklyNutritionDataRequest()
            }
            .onChange(of: vm.endDate) { newValue in
                vm.countSevenDays(type: "End")
                vm.fetchWeeklyNutritionDataRequest()
            }
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
