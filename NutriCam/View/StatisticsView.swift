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
    @State var chartOption = 0
    @State var tab = 0
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Picker("", selection: $tab) {
                        Text("Calories").tag(0)
                        Text("Protein").tag(1)
                        Text("Fat").tag(2)
                        Text("Carbs").tag(3)
                    }
                    .pickerStyle(.segmented)
                    .padding(.vertical, 8)
                    //                Chart(contents) { content in
                    //                Chart {
                    //                    if chartOption == 0 {
                    //                        BarMark(x: .value("Date", "01 August"), y: .value("Value", 2000)
                    //                        )
                    //                        .cornerRadius(4)
                    //                        BarMark(x: .value("Date", "02 August"), y: .value("Value", 1000)
                    //                        )
                    //                        .cornerRadius(4)
                    //                    } else {
                    //                        LineMark(x: .value("Date", "01 August"), y: .value("Value", 2000)
                    //                        )
                    //                        PointMark(x: .value("Date", "01 August"), y: .value("Value", 2000)
                    //                        )
                    //                        LineMark(x: .value("Date", "02 August"), y: .value("Value", 1000)
                    //                        )
                    //                        PointMark(x: .value("Date", "02 August"), y: .value("Value", 1000)
                    //                        )
                    //                    }
                    //                }
                    //                .frame(maxHeight: 300)
                    //
                    //                Spacer()
                    
                    VStack {
                        HStack {
                            Button("Add Examples") {
                                vm.addFood(calories: 400, carbs: 20, fat: 10, protein: 5, name: "Rendang", meal: "Breakfast", date: Date(), weight: 1, measure: "Serving")
                                vm.addFood(calories: 400, carbs: 20, fat: 10, protein: 5, name: "Nasi Goreng", meal: "Breakfast", date: Date(), weight: 1, measure: "Serving")
                            }
                            
                            Spacer()
                            
                            Button("Delete All") {
                                vm.deleteAll()
                            }
                            .foregroundColor(.red)
                        }
                        
                        ForEach(vm.foods) { food in
                            Section(vm.extractDate(date: food.date ?? Date(), format: "E, dd MMM yyyy")) {
                                VStack(spacing: 10) {
                                    Text("\(food.calories)")
                                    Text("\(food.fat)")
                                    Text("\(food.protein)")
                                    Text("\(food.carbs)")
                                }
                                Divider()
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .padding()
                }
                .padding(.horizontal)
            }
            .background(Color("Background"))
            .navigationTitle("Statistics")
            .onAppear {
                vm.fetchFoodNutritionRequest()
            }
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
