//
//  OnBoardingSecondView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 08/08/23.
//

import SwiftUI

struct OnBoardingSecondView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack (spacing: 16) {
            Spacer()
            
            Image("OnBoarding2")
                .resizable()
                .scaledToFit()
                .frame(width: 150)
                .padding(.bottom, 32)
            
            Text("Capture Your Food")
                .font(.title3)
                .bold()
                .padding(.horizontal, 32)
            
            Text("To recognize the nutrients in the food that you eat")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            HStack (spacing: 8) {
                Circle()
                    .frame(width: 8)
                    .foregroundColor(.gray)
                Circle()
                    .frame(width: 8)
                    .foregroundColor(.accentColor)
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

struct OnBoardingSecondView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingSecondView()
    }
}
