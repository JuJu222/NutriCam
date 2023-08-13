//
//  MediumSizeView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 06/08/23.
//

import SwiftUI
import WidgetKit

struct MediumSizeView: View {
    
    var entry: SimpleEntry
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 12) {
                VStack {
                    ZStack {
                        CircularProgressView(progress: entry.nutrition.calories / entry.profile.minCalories)

                        VStack {
                            Image(systemName: "flame.fill")
                                .foregroundColor(Color("AccentColor"))
                                .font(.title2)
                            
                            Text("\(entry.nutrition.calories, specifier: "%.0f")")
                                .font(.title)
                                .bold()
                            Text("/ \(entry.profile.minCalories, specifier: "%.0f")\nkcal")
                                .font(.footnote)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(2)
                }
                
                VStack(spacing: 16) {
                    ProgressView(value: entry.nutrition.protein, total: entry.profile.minProtein) {
                        HStack {
                            Text("Protein")
                                .font(.footnote)
                                .bold()
                            Spacer()
                            Text("\(entry.nutrition.protein, specifier: "%.1f") / \(entry.profile.minProtein, specifier: "%.1f") g")
                                .font(.footnote)
                        }
                    }
                    .tint(Color("AccentColor"))
                    
                    ProgressView(value: entry.nutrition.fat, total: entry.profile.minFat) {
                        HStack {
                            Text("Fat")
                                .font(.footnote)
                                .bold()
                            Spacer()
                            Text("\(entry.nutrition.fat, specifier: "%.1f") / \(entry.profile.minFat, specifier: "%.1f") g")
                                .font(.footnote)
                        }
                    }
                    .tint(Color("AccentColor"))
                    
                    ProgressView(value: entry.nutrition.carbs, total: entry.profile.minCarbs) {
                        HStack {
                            Text("Carbs")
                                .font(.footnote)
                                .bold()
                            Spacer()
                            Text("\(entry.nutrition.carbs, specifier: "%.1f") / \(entry.profile.minCarbs, specifier: "%.1f") g")
                                .font(.footnote)
                        }
                    }
                    .tint(Color("AccentColor"))
                }
                .padding(.bottom, 2)
            }
            .padding()
        }
    }
}

//struct MediumSizeView_Previews: PreviewProvider {
//    static var previews: some View {
//        MediumSizeView()
//    }
//}
