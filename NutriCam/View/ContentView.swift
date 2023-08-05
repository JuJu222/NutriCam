//
//  ContentView.swift
//  NutriCam
//
//  Created by Yap Justin on 28/07/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NutritionView()
                .tabItem {
                    Label("My Nutrition", systemImage: "fork.knife")
                }

            StatisticsView()
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
