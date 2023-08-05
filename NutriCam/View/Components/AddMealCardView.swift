//
//  AddMealCardView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 05/08/23.
//

import SwiftUI

struct AddMealCardView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
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
                        
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                                .font(.subheadline)
                            Text("Add")
                                .font(.subheadline)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(100)
                    }
                }
                .padding([.horizontal, .top])
                
                Divider()
                
                HStack(spacing: 12) {
                    VStack {
                        Text("Calories")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("1000 kcal")
                    }
                    .frame(width: UIScreen.main.bounds.width / 5)
                    
                    VStack {
                        Text("Protein")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("10 g")
                    }
                    .frame(width: UIScreen.main.bounds.width / 5.5)
                    
                    VStack {
                        Text("Carbs")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("20 g")
                    }
                    .frame(width: UIScreen.main.bounds.width / 5.5)
                    
                    VStack {
                        Text("Fat")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("30 g")
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
        AddMealCardView(meal: "Breakfast")
    }
}
