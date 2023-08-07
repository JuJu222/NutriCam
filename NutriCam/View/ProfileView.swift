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
            VStack {
                
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
            .fullScreenCover(isPresented: $showEditProfileSheet) {
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
