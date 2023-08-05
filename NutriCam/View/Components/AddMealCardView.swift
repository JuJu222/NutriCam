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
                        Label("Add", systemImage: "plus.circle")
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
                        Text("10000 kcal")
                    }
                    .frame(width: UIScreen.main.bounds.width / 4.7)
                    
                    VStack {
                        Text("Protein")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("100 g")
                    }
                    .frame(width: UIScreen.main.bounds.width / 5.5)
                    
                    VStack {
                        Text("Carbs")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("200 g")
                    }
                    .frame(width: UIScreen.main.bounds.width / 5.5)
                    
                    VStack {
                        Text("Fat")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("300 g")
                    }
                    .frame(width: UIScreen.main.bounds.width / 5.5)
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
