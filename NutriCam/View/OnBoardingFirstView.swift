//
//  OnBoardingFirstView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 08/08/23.
//

import SwiftUI

struct OnBoardingFirstView: View {
    @Environment(\.colorScheme) var colorScheme
    
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
            
            Text("We can help you to calculate your body's daily nutritional requirements.")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            HStack (spacing: 8) {
                Circle()
                    .frame(width: 8)
                    .foregroundColor(.accentColor)
                Circle()
                    .frame(width: 8)
                    .foregroundColor(.gray)
                Circle()
                    .frame(width: 8)
                    .foregroundColor(.gray)
            }
            .padding(8)
            .background(colorScheme == .dark ? Color(UIColor.systemGray6) : .white)
            .cornerRadius(100)
                .padding(.bottom, 64)
            
            Spacer()
        }
    }
}

struct OnBoardingFirstView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingFirstView()
    }
}
