//
//  StatisticsView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 04/08/23.
//

import SwiftUI
import Charts

struct StatisticsView: View {
    
    @State var chartOption = 0
    
    var body: some View {
        NavigationStack {
            VStack {
//                Chart(contents) { content in
                Chart {
                    if chartOption == 0 {
                        BarMark(x: .value("Date", "01 August"), y: .value("Value", 2000)
                        )
                        .cornerRadius(4)
                        BarMark(x: .value("Date", "02 August"), y: .value("Value", 1000)
                        )
                        .cornerRadius(4)
                    } else {
                        LineMark(x: .value("Date", "01 August"), y: .value("Value", 2000)
                        )
                        PointMark(x: .value("Date", "01 August"), y: .value("Value", 2000)
                        )
                        LineMark(x: .value("Date", "02 August"), y: .value("Value", 1000)
                        )
                        PointMark(x: .value("Date", "02 August"), y: .value("Value", 1000)
                        )
                    }
                }
                .frame(maxHeight: 300)
                
                Spacer()
            }
            .padding()
            .background(Color("Background"))
            .navigationTitle("Statistics")
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
