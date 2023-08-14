//
//  OnBoardingSecondView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 08/08/23.
//

import SwiftUI

struct OnBoardingSecondView: View {
    var body: some View {
        VStack (spacing: 16) {
            Spacer()
            
            Image("OnBoarding2")
                .resizable()
                .scaledToFit()
                .frame(width: 175)
                .padding(.bottom, 32)
            
            Text("Capture Your Food")
                .font(.title3)
                .bold()
                .padding(.horizontal, 32)
            
            Text("To recognize the nutrients in the food that you eat")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}

struct OnBoardingSecondView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingSecondView()
    }
}
