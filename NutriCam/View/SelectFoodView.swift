//
//  SelectFoodView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 05/08/23.
//

import SwiftUI

struct SelectFoodView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var vm: NutritionViewModel
    @State private var searchText = ""
    
    var searchResults: [Hint] {
        if searchText.isEmpty {
            return vm.hintFoods
        } else {
            return vm.hintFoods.filter { $0.food?.label?.contains(searchText) ?? false }
        }
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(searchResults, id: \.self) { food in
                    NavigationLink(destination: FoodNutritionResultView(vm: vm, food: food)) {
                        HStack (spacing: 16) {
                            AsyncImage(url: URL(string: food.food?.image ?? "")) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45)
                                    .cornerRadius(8)
                                    
                            } placeholder: {
                                Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45)
                            }
                            
                            VStack (alignment: .leading, spacing: 2) {
                                Text(food.food?.label ?? "Label")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(Color(UIColor.label))
                                    .multilineTextAlignment(.leading)

                                Text("\(food.food?.category ?? ""), \(food.food?.nutrients?.ENERC_KCAL ?? 0, specifier: "%.0f") kcal")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                            }

                            Spacer()
                        }
                        .padding()
                        .background(colorScheme == .dark ? Color(UIColor.systemGray6) : .white)
                        .cornerRadius(16)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .background(Color("Background"))
        .onAppear {
            vm.fetchEdamamFoods()
        }
        .navigationTitle("Select Food")
        .searchable(text: $searchText, prompt: "Look for your \(vm.foodName)")
    }
}

struct SelectFoodView_Previews: PreviewProvider {
    static var previews: some View {
        SelectFoodView(vm: NutritionViewModel())
    }
}
