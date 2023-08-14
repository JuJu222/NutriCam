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
        .padding()
//        .frame(width: 120, height: 120)
    }
}

//struct SmallSizeView_Previews: PreviewProvider {
//    static var previews: some View {
//        SmallSizeView()
//    }
//}
