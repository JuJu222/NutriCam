//
//  FoodNutritionResultView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 05/08/23.
//

import SwiftUI

struct FoodNutritionResultView: View {
    
    @ObservedObject var vm: NutritionViewModel
    let food: Hint
    
    @State var weight: Double = 0
    
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
            
            Text("\(String(format: "%.0f", weight)) gram per serving")
                .padding()
            
            VStack (alignment: .leading) {
                HStack {
                    Text("Nutrients")
                        .font(.title3)
                        .bold()
                        .padding(.bottom)
                    
                    Spacer()
                }
                
                HStack {
                    Text("Calories")
                    
                    Spacer()
                    
                    Text("\(String(format: "%.0f", food.food?.nutrients?.ENERC_KCAL ?? 0)) kcal")
                }
                Divider()
                    .padding(.bottom, 4)
                
                HStack {
                    Text("Protein")
                    
                    Spacer()
                    
                    Text("\(String(format: "%.2f", food.food?.nutrients?.PROCNT ?? 0)) g")
                }
                Divider()
                    .padding(.bottom, 4)
                
                HStack {
                    Text("Fat")
                    
                    Spacer()
                    
                    Text("\(String(format: "%.2f", food.food?.nutrients?.FAT ?? 0)) g")
                }
                Divider()
                    .padding(.bottom, 4)
                
                HStack {
                    Text("Carbohydrates")
                    
                    Spacer()
                    
                    Text("\(String(format: "%.2f", food.food?.nutrients?.CHOCDF ?? 0)) g")
                }
            }
            
            Spacer()
            
            Button {
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
            }
        }
        .padding()
        .background(Color("Background"))
        .navigationTitle(food.food?.label ?? "Food Name")
        .onAppear {
            food.measures?.forEach({ measure in
                if measure.label == "Serving" {
                    weight = measure.weight ?? 0
                }
            })
//            ForEach(food.measures ?? [], id: \.self) { measure in
//                if measure.label == "Serving" {
//                    weight = measure.weight ?? 0
//                }
//            }
        }
    }
}

struct FoodNutritionResultView_Previews: PreviewProvider {
    static var previews: some View {
        FoodNutritionResultView(vm: NutritionViewModel(), food: Hint())
    }
}
