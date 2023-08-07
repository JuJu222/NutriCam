//
//  SmallSizeView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 06/08/23.
//

import SwiftUI
import WidgetKit

struct SmallSizeView: View {
    
    var entry: SimpleEntry
    
    var body: some View {
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
        .onAppear {
            WidgetService.shared.fetchFoodNutritionRequest()
        }
    }
}

//struct SmallSizeView_Previews: PreviewProvider {
//    static var previews: some View {
//        SmallSizeView()
//    }
//}
