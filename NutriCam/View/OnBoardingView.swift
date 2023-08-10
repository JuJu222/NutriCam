//
//  OnBoardingView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 05/08/23.
//

import SwiftUI

struct OnBoardingView: View {
    @AppStorage("currentPage") var currentPage = 1

    @StateObject var vm: ProfileViewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if currentPage == 1 {
                    OnBoardingFirstView()
                } else if currentPage == 2 {
                    OnBoardingSecondView()
                } else if currentPage == 3 {
                    OnBoardingThirdView()
                } else if currentPage == 4 {
                    OnBoardingProfileView(vm: vm)
                }
                
                Button {
                    currentPage += 1
                } label: {
                    HStack {
                        Spacer()
                        Text(currentPage < 3 ? "Next" : currentPage < 4 ? "Lets get started!" : "Save")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .padding(.vertical, 12)
                        Spacer()
                    }
                    .background(Color.accentColor)
                    .clipShape(Capsule())
                }
                .padding(.horizontal)
            }
            .toolbar {
                if currentPage > 1 {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("Back")
                            .foregroundColor(.accentColor)
                            .onTapGesture {
                                currentPage -= 1
                            }
                    }
                }
                if currentPage < 4 {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Text("Skip")
                            .foregroundColor(.accentColor)
                            .onTapGesture {
                                currentPage = 4
                            }
                    }
                }
            }
            .background(Color("Background"))
        }
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
