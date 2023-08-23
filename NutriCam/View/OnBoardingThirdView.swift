//
//  OnBoardingThirdView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 08/08/23.
//

import SwiftUI

struct OnBoardingThirdView: View {
    var body: some View {
        VStack (spacing: 16) {
            Spacer()
            
            Image("OnBoarding3")
                .resizable()
                .scaledToFit()
                .frame(width: 300)
                .padding(.bottom, 32)
            
            Text("Calculate Your Calories")
                .font(.title3)
                .bold()
                .padding(.horizontal, 32)
            
            Text("And achieve your daily nutritional goals")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}

struct OnBoardingThirdView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingThirdView()
    }
}
