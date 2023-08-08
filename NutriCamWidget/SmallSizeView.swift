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
                CircularProgressView(progress: entry.nutrition.calories / 2000)

                VStack {
                    Text("\(entry.nutrition.calories, specifier: "%.0f")")
                        .font(.title2)
                        .bold()
                        .padding(.top, 12)
                    Text("/ 2000\nkcal")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(width: 100, height: 100)

            Text("Calories")
                .font(.footnote)
                .bold()
        }
    }
}

//struct SmallSizeView_Previews: PreviewProvider {
//    static var previews: some View {
//        SmallSizeView()
//    }
//}
