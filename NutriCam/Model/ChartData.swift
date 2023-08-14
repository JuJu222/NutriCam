//
//  ChartData.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 13/08/23.
//

import Foundation

struct ChartData: Identifiable {
    var id = UUID()
    var date: Date = Date()
    var nutritions: Nutrition = Nutrition()
}
