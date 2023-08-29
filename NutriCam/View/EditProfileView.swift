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
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        HStack {
                            Text("Weight (kg)")
                            Spacer()
                            TextField("50", text: $vm.weight)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.numberPad)
                                .onReceive(Just(vm.weight)) { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    if filtered != newValue {
                                        self.vm.weight = filtered
                                    }
                                }
                        }
                        HStack {
                            Text("Height (cm)")
                            Spacer()
                            TextField("160", text: $vm.height)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.numberPad)
                                .onReceive(Just(vm.height)) { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    if filtered != newValue {
                                        self.vm.height = filtered
                                    }
                                }
                        }
                        Picker("Sex", selection: $vm.gender) {
                            ForEach(genderOptions, id: \.self) { option in
                                Text(option)
                            }
                        }
                        DatePicker("Date of Birth", selection: $vm.dateOfBirth, displayedComponents: .date)
                    } header: {
                        Text("Personal Data")
                    }
                    
                    Section {
                        VStack {
                            HStack {
                                Text("Calories")
                                Spacer()
                                Text("\(vm.calories, specifier: "%.0f") Kcal")
                            }
                            Slider(value: $vm.calories, in: 0...5000)
                        }
                        VStack {
                            HStack {
                                Text("Protein")
                                Spacer()
                                Text("\(vm.protein, specifier: "%.1f") g")
                            }
                            Slider(value: $vm.protein, in: 0...300)
                        }
                        VStack {
                            HStack {
                                Text("Fat")
                                Spacer()
                                Text("\(vm.fat, specifier: "%.1f") g")
                            }
                            Slider(value: $vm.fat, in: 0...300)
                        }
                        VStack {
                            HStack {
                                Text("Carbs")
                                Spacer()
                                Text("\(vm.carbs, specifier: "%.1f") g")
                            }
                            Slider(value: $vm.carbs, in: 0...800)
                        }
                        Button {
                            vm.calories = vm.profile.first?.recommendCalories ?? 0
                            vm.protein = vm.profile.first?.recommendProtein ?? 0
                            vm.fat = vm.profile.first?.recommendFat ?? 0
                            vm.carbs = vm.profile.first?.recommendCarbs ?? 0
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
                    vm.editProfile(profile: vm.profile.first ?? Profile(), minCalories: vm.calories, minCarbs: vm.carbs, minFat: vm.fat, minProtein: vm.protein, weight: Double(vm.weight) ?? 50, height: Double(vm.height) ?? 160, dateOfBirth: vm.dateOfBirth, gender: vm.gender, recommendCalories: recommendNutrition.calories, recommendProtein: recommendNutrition.protein, recommendFat: recommendNutrition.fat, recommendCarbs: recommendNutrition.carbs)
                    
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
                .disabled(vm.calories == 0 || vm.carbs == 0 || vm.fat == 0 || vm.protein == 0 || vm.weight.isEmpty || vm.height.isEmpty || vm.gender.isEmpty)
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
                let age = Calendar.current.dateComponents([.year], from: vm.dateOfBirth, to: Date()).year
                
                recommendNutrition = vm.countRecommendNutrition(gender: vm.gender, age: Double(age ?? 1), weight: Double(vm.weight) ?? 50, height: Double(vm.height) ?? 160)
            }
            .onChange(of: vm.weight, perform: { newValue in
                let age = Calendar.current.dateComponents([.year], from: vm.dateOfBirth, to: Date()).year

                recommendNutrition = vm.countRecommendNutrition(gender: vm.gender, age: Double(age ?? 1), weight: Double(vm.weight) ?? 50, height: Double(vm.height) ?? 160)

                vm.calories = recommendNutrition.calories
                vm.protein = recommendNutrition.protein
                vm.fat = recommendNutrition.fat
                vm.carbs = recommendNutrition.carbs
            })
            .onChange(of: vm.height, perform: { newValue in
                let age = Calendar.current.dateComponents([.year], from: vm.dateOfBirth, to: Date()).year

                recommendNutrition = vm.countRecommendNutrition(gender: vm.gender, age: Double(age ?? 1), weight: Double(vm.weight) ?? 50, height: Double(vm.height) ?? 160)

                vm.calories = recommendNutrition.calories
                vm.protein = recommendNutrition.protein
                vm.fat = recommendNutrition.fat
                vm.carbs = recommendNutrition.carbs
            })
            .onChange(of: vm.gender, perform: { newValue in
                let age = Calendar.current.dateComponents([.year], from: vm.dateOfBirth, to: Date()).year

                recommendNutrition = vm.countRecommendNutrition(gender: vm.gender, age: Double(age ?? 1), weight: Double(vm.weight) ?? 50, height: Double(vm.height) ?? 160)

                vm.calories = recommendNutrition.calories
                vm.protein = recommendNutrition.protein
                vm.fat = recommendNutrition.fat
                vm.carbs = recommendNutrition.carbs
            })
            .onChange(of: vm.dateOfBirth, perform: { newValue in
                let age = Calendar.current.dateComponents([.year], from: vm.dateOfBirth, to: Date()).year

                recommendNutrition = vm.countRecommendNutrition(gender: vm.gender, age: Double(age ?? 1), weight: Double(vm.weight) ?? 50, height: Double(vm.height) ?? 160)

                vm.calories = recommendNutrition.calories
                vm.protein = recommendNutrition.protein
                vm.fat = recommendNutrition.fat
                vm.carbs = recommendNutrition.carbs
            })
            .background(Color(UIColor.systemGray6))
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(vm: ProfileViewModel())
    }
}
