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
    var newSearch: Bool
    
    var searchResults: [Hint] {
        if newSearch {
            return vm.searchFoods
        } else {
            if searchText.isEmpty {
                return vm.hintFoods
            } else {
                return vm.hintFoods.filter { $0.food?.label?.contains(searchText) ?? false }
            }
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

                                if let brand = food.food?.brand {
                                    Text("\(food.food?.category ?? ""), \(brand), \(food.food?.nutrients?.ENERC_KCAL ?? 0, specifier: "%.0f") kcal")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.leading)
                                } else {
                                    Text("\(food.food?.category ?? ""), \(food.food?.nutrients?.ENERC_KCAL ?? 0, specifier: "%.0f") kcal")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.leading)
                                }
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
            if newSearch {
                if vm.searchFoods.count == 0 {
                    vm.fetchEdamamFoods(newSearch: true)
                }
            }
        }
        .navigationTitle("Select Food")
        .searchable(text: $searchText, prompt: newSearch ? "Look for your food" : "Look for your \(vm.foodName)")
        .onSubmit(of: .search) {
            vm.searchFoodName = searchText
            vm.fetchEdamamFoods(newSearch: true)
          }
    }
}

struct SelectFoodView_Previews: PreviewProvider {
    static var previews: some View {
        SelectFoodView(vm: NutritionViewModel(), newSearch: false)
    }
}
