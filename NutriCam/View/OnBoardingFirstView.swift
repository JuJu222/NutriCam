//
//  OnBoardingFirstView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 08/08/23.
//

import SwiftUI

struct OnBoardingFirstView: View {
    var body: some View {
        VStack (spacing: 16) {
            Spacer()
            
            Image("OnBoarding1")
                .resizable()
                .scaledToFit()
                .padding(.bottom, 32)
            
            Text("Fulfill Your Daily Nutrition")
                .font(.title3)
                .bold()
                .padding(.horizontal, 32)
            
            Text("We can help you to calculate your body's daily nutritional requirements")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}

struct OnBoardingFirstView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingFirstView()
    }
}
