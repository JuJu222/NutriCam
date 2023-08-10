//
//  EditProfileView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 05/08/23.
//

import SwiftUI
import Combine

struct EditProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var vm: ProfileViewModel
    
    let genderOptions = ["Male", "Female"]
    
    @State var recommendNutrition: Nutrition = Nutrition()
    
    @State var weight = ""
    @State var height = ""
    @State var gender = ""
    @State var dateOfBirth = Date()
    @State var calories = 0.0
    @State var protein = 0.0
    @State var fat = 0.0
    @State var carbs = 0.0
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        HStack {
                            Text("Weight (kg)")
                            Spacer()
                            TextField("50", text: $weight)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.numberPad)
//                                .onReceive(Just(weight)) { newValue in
//                                    let filtered = newValue.filter { "0123456789".contains($0) }
//                                    if filtered != newValue {
//                                        self.weight = filtered
//                                    }
//                                }
                        }
                        HStack {
                            Text("Height (cm)")
                            Spacer()
                            TextField("160", text: $height)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.numberPad)
//                                .onReceive(Just(weight)) { newValue in
//                                    let filtered = newValue.filter { "0123456789".contains($0) }
//                                    if filtered != newValue {
//                                        self.weight = filtered
//                                    }
//                                }
                        }
                        Picker("Gender", selection: $gender) {
                            ForEach(genderOptions, id: \.self) { option in
                                Text(option)
                            }
                        }
                        DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                    } header: {
                        Text("Personal Data")
                    }
                    
                    Section {
                        VStack {
                            HStack {
                                Text("Calories")
                                Spacer()
                                Text("\(calories, specifier: "%.0f")")
                            }
                            Slider(value: $calories, in: 0...5000)
                        }
                        VStack {
                            HStack {
                                Text("Protein")
                                Spacer()
                                Text("\(protein, specifier: "%.1f")")
                            }
                            Slider(value: $protein, in: 0...500)
                        }
                        VStack {
                            HStack {
                                Text("Fat")
                                Spacer()
                                Text("\(fat, specifier: "%.1f")")
                            }
                            Slider(value: $fat, in: 0...500)
                        }
                        VStack {
                            HStack {
                                Text("Carbs")
                                Spacer()
                                Text("\(carbs, specifier: "%.1f")")
                            }
                            Slider(value: $carbs, in: 0...1000)
                        }
                        Button {
                            calories = vm.profile.first?.recommendCalories ?? 0
                            protein = vm.profile.first?.recommendProtein ?? 0
                            fat = vm.profile.first?.recommendFat ?? 0
                            carbs = vm.profile.first?.recommendCarbs ?? 0
                        } label: {
                            HStack {
                                Spacer()
                                Text("Reset minimum nutrients based on personal data")
                                    .multilineTextAlignment(.center)
                                    .font(.subheadline)
                                    .underline()
                                Spacer()
                            }
                        }
                    } header: {
                        Text("Minimum Nutrient Consumed Per Day")
                    }
                }
                .padding(.top, 1)
                
                Button {
                    vm.editProfile(profile: vm.profile.first ?? Profile(), minCalories: calories, minCarbs: carbs, minFat: fat, minProtein: protein, weight: Double(weight) ?? 50, height: Double(height) ?? 160, dateOfBirth: dateOfBirth, gender: gender, recommendCalories: recommendNutrition.calories, recommendProtein: recommendNutrition.protein, recommendFat: recommendNutrition.fat, recommendCarbs: recommendNutrition.carbs)
                    
                    dismiss()
                } label: {
                    HStack {
                        Spacer()
                        Text("Save")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .padding(.vertical, 12)
                        Spacer()
                    }
                    .background(Color.accentColor)
                    .clipShape(Capsule())
                }
                .padding(.horizontal)
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("cancel")
                        .foregroundColor(.accentColor)
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
            .onAppear {
                weight = String(Int(vm.profile.first?.weight ?? 0))
                height = String(Int(vm.profile.first?.height ?? 0))
                gender = vm.profile.first?.gender ?? ""
                dateOfBirth = vm.profile.first?.dateOfBirth ?? Date()
                calories = vm.profile.first?.minCalories ?? 0
                protein = vm.profile.first?.minProtein ?? 0
                fat = vm.profile.first?.minFat ?? 0
                carbs = vm.profile.first?.minCarbs ?? 0
            }
            .onChange(of: weight, perform: { newValue in
                let age = Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year
                
                recommendNutrition = vm.countRecommendNutrition(gender: gender, age: Double(age ?? 1), weight: Double(weight) ?? 50, height: Double(height) ?? 160)
                
                calories = recommendNutrition.calories
                protein = recommendNutrition.protein
                fat = recommendNutrition.fat
                carbs = recommendNutrition.carbs
            })
            .onChange(of: height, perform: { newValue in
                let age = Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year
                
                recommendNutrition = vm.countRecommendNutrition(gender: gender, age: Double(age ?? 1), weight: Double(weight) ?? 50, height: Double(height) ?? 160)
                
                calories = recommendNutrition.calories
                protein = recommendNutrition.protein
                fat = recommendNutrition.fat
                carbs = recommendNutrition.carbs
            })
            .onChange(of: gender, perform: { newValue in
                let age = Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year
                
                recommendNutrition = vm.countRecommendNutrition(gender: gender, age: Double(age ?? 1), weight: Double(weight) ?? 50, height: Double(height) ?? 160)
                
                calories = recommendNutrition.calories
                protein = recommendNutrition.protein
                fat = recommendNutrition.fat
                carbs = recommendNutrition.carbs
            })
            .onChange(of: dateOfBirth, perform: { newValue in
                let age = Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year
                
                recommendNutrition = vm.countRecommendNutrition(gender: gender, age: Double(age ?? 1), weight: Double(weight) ?? 50, height: Double(height) ?? 160)
                
                calories = recommendNutrition.calories
                protein = recommendNutrition.protein
                fat = recommendNutrition.fat
                carbs = recommendNutrition.carbs
            })
            .background(Color(UIColor.systemGray6))
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(vm: ProfileViewModel())
//            .preferredColorScheme(.dark)
    }
}
