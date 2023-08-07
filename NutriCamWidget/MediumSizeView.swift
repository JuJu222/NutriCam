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
            HStack {
                VStack(spacing: 10) {
                    ZStack {
                        CircularProgressView(progress: entry.nutritions.calories / 2000)
                        
                        VStack {
                            Text("\(entry.nutritions.calories, specifier: "%.0f")")
                                .font(.title2)
                                .bold()
                            Text("/ 2000")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(width: 100, height: 100)
                    
                    Text("Calories")
                        .font(.footnote)
                        .bold()
                }
                .frame(width: geometry.size.width * 0.45)
                
                VStack(spacing: 16) {
                    ProgressView(value: entry.nutritions.protein, total: 70) {
                        HStack {
                            Text("Protein")
                                .font(.footnote)
                                .bold()
                            Spacer()
                            Text("\(entry.nutritions.protein, specifier: "%.1f") / 60 g")
                                .font(.footnote)
                        }
                    }
                    ProgressView(value: entry.nutritions.fat, total: 70) {
                        HStack {
                            Text("Fat")
                                .font(.footnote)
                                .bold()
                            Spacer()
                            Text("\(entry.nutritions.fat, specifier: "%.1f") / 30 g")
                                .font(.footnote)
                        }
                    }
                    ProgressView(value: entry.nutritions.carbs, total: 70) {
                        HStack {
                            Text("Carbs")
                                .font(.footnote)
                                .bold()
                            Spacer()
                            Text("\(entry.nutritions.carbs, specifier: "%.1f") / 70 g")
                                .font(.footnote)
                        }
                    }
                }
                .frame(width: geometry.size.width * 0.45)
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
