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
                    Text("No Data")
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
