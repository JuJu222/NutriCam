//
//  OnBoardingProfileView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 06/08/23.
//

import SwiftUI
import Combine

struct OnBoardingProfileView: View {
    @AppStorage("currentPage") var currentPage = 4
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var vm: ProfileViewModel
    
    let genderOptions = ["Male", "Female"]
    
    @State var weight = ""
    @State var height = ""
    @State var gender = ""
    @State var dateOfBirth = Date()
    
    var body: some View {
        VStack {
            Text("Please fill in the data below so we can determine your minimum daily nutrition")
                .foregroundColor(.secondary)
                .font(.subheadline)
                .padding([.horizontal, .top])
            
            List {
                Section {
                    HStack {
                        Text("Weight (kg)")
                        Spacer()
                        TextField("50", text: $weight)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .onReceive(Just(weight)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.weight = filtered
                                }
                            }
                    }
                    HStack {
                        Text("Height (cm)")
                        Spacer()
                        TextField("160", text: $height)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .onReceive(Just(weight)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.weight = filtered
                                }
                            }
                    }
                    Picker("Gender", selection: $gender) {
                        ForEach(genderOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                }
            }
        }
        .background(colorScheme == .dark ? .black : Color(UIColor.systemGray6))
        .onDisappear {
            let age = Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year

            let nutrition = vm.countRecommendNutrition(gender: gender, age: Double(age ?? 1), weight: Double(weight) ?? 50, height: Double(height) ?? 160)

            vm.addProfile(minCalories: nutrition.calories, minCarbs: nutrition.carbs, minFat: nutrition.fat, minProtein: nutrition.protein, weight: Double(weight) ?? 50, height: Double(height) ?? 160, dateOfBirth: dateOfBirth, gender: gender, recommendCalories: nutrition.calories, recommendProtein: nutrition.protein, recommendFat: nutrition.fat, recommendCarbs: nutrition.carbs)
        }
    }
}

struct OnBoardingProfileView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingProfileView(vm: ProfileViewModel())
    }
}
