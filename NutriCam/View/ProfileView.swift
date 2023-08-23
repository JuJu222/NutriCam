//
//  ProfileView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 04/08/23.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var vm: ProfileViewModel = ProfileViewModel()
    @State var showEditProfileSheet: Bool = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 16) {
                VStack (alignment: .leading) {
                    Text("PERSONAL DATA")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.leading, 40)
                    
                    LazyVGrid(columns: columns, spacing: 8) {
                        HStack {
                            Image(colorScheme == .light ? "height" : "heightWhite")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40)
                            VStack (alignment: .leading, spacing: 1) {
                                Text("Height")
                                    .font(.subheadline)
                                Text("\(vm.profile.first?.height ?? 0, specifier: "%.0f") cm")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(colorScheme == .light ? .white : Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .padding(.leading, 20)
                        .padding(.bottom, 2)
                        
                        HStack {
                            Image(colorScheme == .light ? "weight" : "weightWhite")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40)
                            VStack (alignment: .leading, spacing: 1) {
                                Text("Weight")
                                    .font(.subheadline)
                                Text("\(vm.profile.first?.weight ?? 0, specifier: "%.0f") kg")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(colorScheme == .light ? .white : Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .padding(.trailing, 20)
                        .padding(.bottom, 1)
                        
                        HStack {
                            Image(colorScheme == .light ? "gender" : "genderWhite")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40)
                            VStack (alignment: .leading, spacing: 1) {
                                Text("Sex")
                                    .font(.subheadline)
                                Text("\(vm.profile.first?.gender ?? "")")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(colorScheme == .light ? .white : Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .padding(.leading, 20)
                        
                        HStack {
                            Image(colorScheme == .light ? "birthDate" : "birthDateWhite")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40)
                            VStack (alignment: .leading, spacing: 2) {
                                Text("Birth Date")
                                    .font(.subheadline)
                                Text("\(vm.extractDate(date: vm.profile.first?.dateOfBirth ?? Date(), format: "dd/MM/yy"))")
                                    .font(.headline)
                            }
                            .padding(.vertical, 1)
                            Spacer()
                        }
                        .padding()
                        .background(colorScheme == .light ? .white : Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .padding(.trailing, 20)
                    }
                }
                
                List {
                    Section(header: Text("Minimum Nutrition")) {
                        HStack {
                            Image(colorScheme == .light ? "calories" : "caloriesWhite")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 24)
                            Text("Min. Calories")
                            Spacer()
                            Text("\(vm.profile.first?.minCalories ?? 0, specifier: "%.0f") kcal")
                        }
                        HStack {
                            Image(colorScheme == .light ? "protein" : "proteinWhite")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 24)
                            Text("Min. Protein")
                            Spacer()
                            Text("\(vm.profile.first?.minProtein ?? 0, specifier: "%.0f") g")
                        }
                        HStack {
                            Image(colorScheme == .light ? "fat" : "fatWhite")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 24)
                            Text("Min. Fat")
                            Spacer()
                            Text("\(vm.profile.first?.minFat ?? 0, specifier: "%.0f") g")
                        }
                        HStack {
                            Image(colorScheme == .light ? "carbs" : "carbsWhite")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 24)
                            Text("Min. Carbs")
                            Spacer()
                            Text("\(vm.profile.first?.minCarbs ?? 0, specifier: "%.0f") g")
                        }
                    }
                }
            }
            .padding(.top)
            .background(colorScheme == .dark ? .black : Color(UIColor.systemGray6))
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        showEditProfileSheet.toggle()
                    }
                }
            }
            .sheet(isPresented: $showEditProfileSheet) {
                EditProfileView(vm: vm)
            }
        }
        .onChange(of: showEditProfileSheet, perform: { newValue in
            vm.weight = String(Int(vm.profile.first?.weight ?? 0))
            vm.height = String(Int(vm.profile.first?.height ?? 0))
            vm.gender = vm.profile.first?.gender ?? ""
            vm.dateOfBirth = vm.profile.first?.dateOfBirth ?? Date()
            vm.calories = vm.profile.first?.minCalories ?? 0
            vm.protein = vm.profile.first?.minProtein ?? 0
            vm.fat = vm.profile.first?.minFat ?? 0
            vm.carbs = vm.profile.first?.minCarbs ?? 0
        })
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
