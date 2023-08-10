//
//  ProfileView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 04/08/23.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var vm: ProfileViewModel = ProfileViewModel()
    @State var showEditProfileSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack {
                    Text("Height: \(vm.profile.first?.height ?? 0, specifier: "%.0f")")
                    Text("Weight: \(vm.profile.first?.weight ?? 0, specifier: "%.0f")")
                    Text("Gender: \(vm.profile.first?.gender ?? "")")
                    Text("Date of Birth: \(vm.extractDate(date: vm.profile.first?.dateOfBirth ?? Date(), format: "dd MMM yyyy"))")
                }
                
                VStack {
                    Text("Min Calories: \(vm.profile.first?.minCalories ?? 0, specifier: "%.0f")")
                    Text("Min Protein: \(vm.profile.first?.minProtein ?? 0, specifier: "%.1f")")
                    Text("Min Fat: \(vm.profile.first?.minFat ?? 0, specifier: "%.1f")")
                    Text("Min Carbs: \(vm.profile.first?.minCarbs ?? 0, specifier: "%.1f")")
                }
                
                VStack {
                    Text("Recommended Calories: \(vm.profile.first?.recommendCalories ?? 0, specifier: "%.0f")")
                    Text("Recommended Protein: \(vm.profile.first?.recommendProtein ?? 0, specifier: "%.1f")")
                    Text("Recommended Fat: \(vm.profile.first?.recommendFat ?? 0, specifier: "%.1f")")
                    Text("Recommended Carbs: \(vm.profile.first?.recommendCarbs ?? 0, specifier: "%.1f")")
                }
            }
            .background(Color("Background"))
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
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
