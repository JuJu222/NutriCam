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
            HStack(spacing: 10) {
                VStack {
                    ZStack {
                        CircularProgressView(progress: entry.nutrition.calories / 2000)

                        VStack {
                            Image(systemName: "flame.fill")
                                .foregroundColor(Color("AccentColor"))
                                .font(.title2)
                            
                            Text("\(entry.nutrition.calories, specifier: "%.0f")")
                                .font(.title)
                                .bold()
                            Text("/ 2000\nkcal")
                                .font(.footnote)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(width: 120, height: 120)
                    .padding(.top, 3)
                }
                .frame(width: geometry.size.width * 0.45)
                
                VStack(spacing: 16) {
                    ProgressView(value: entry.nutrition.protein, total: 70) {
                        HStack {
                            Text("Protein")
                                .font(.footnote)
                                .bold()
                            Spacer()
                            Text("\(entry.nutrition.protein, specifier: "%.1f") / 60 g")
                                .font(.footnote)
                        }
                    }
                    .tint(Color("AccentColor"))
                    
                    ProgressView(value: entry.nutrition.fat, total: 30) {
                        HStack {
                            Text("Fat")
                                .font(.footnote)
                                .bold()
                            Spacer()
                            Text("\(entry.nutrition.fat, specifier: "%.1f") / 30 g")
                                .font(.footnote)
                        }
                    }
                    .tint(Color("AccentColor"))
                    
                    ProgressView(value: entry.nutrition.carbs, total: 70) {
                        HStack {
                            Text("Carbs")
                                .font(.footnote)
                                .bold()
                            Spacer()
                            Text("\(entry.nutrition.carbs, specifier: "%.1f") / 70 g")
                                .font(.footnote)
                        }
                    }
                    .tint(Color("AccentColor"))
                }
                .frame(width: geometry.size.width * 0.45)
                .padding(.bottom, 2)
            }
            .padding(.vertical)
            .padding(.horizontal, 4)
        }
    }
}

//struct MediumSizeView_Previews: PreviewProvider {
//    static var previews: some View {
//        MediumSizeView()
//    }
//}
