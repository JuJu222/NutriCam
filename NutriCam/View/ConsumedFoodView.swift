//
//  ConsumedFoodView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 11/08/23.
//

import SwiftUI

struct ConsumedFoodView: View {
    
    @ObservedObject var vm: StatisticsViewModel
    
    var body: some View {
        ScrollView {
            VStack (spacing: 8) {
                if !vm.foods.isEmpty {
                    ForEach(vm.foods) { food in
                        ConsumedFoodCardView(food: food)
                    }
                } else {
                    VStack (spacing: 8) {
                        Spacer()
                        Text("No Data")
                            .font(.title2)
                            .bold()
                        Text("You haven't added daily nutrition data for this week.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 32)
                        Spacer()
                    }
                    .frame(height: 500)
                }
            }
            .padding()
        }
        .navigationTitle("Consumed Food")
    }
}

struct ConsumedFoodView_Previews: PreviewProvider {
    static var previews: some View {
        ConsumedFoodView(vm: StatisticsViewModel())
    }
}
