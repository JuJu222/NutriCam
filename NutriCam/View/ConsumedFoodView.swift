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
            VStack {
                ForEach(vm.foods) { food in
                    ConsumedFoodCardView(food: food)
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
