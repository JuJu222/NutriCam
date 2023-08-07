//
//  AddFoodCameraView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 05/08/23.
//

import SwiftUI

struct AddFoodCameraView: View {
    
    @ObservedObject var vm: NutritionViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Food Name", text: $vm.foodName)
                    
                    NavigationLink(destination: SelectFoodView(vm: vm)) {
                        Text("Next")
                            .padding(8)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(100)
                    }
                }
                .padding(.bottom)
                
                Spacer()
            }
            .padding()
            .background(Color("Background"))
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("Cancel")
                    .foregroundColor(.red)
                    .onTapGesture {
                        vm.showAddSheet.toggle()
                    }
            }
        }
    }
}

struct AddFoodCameraView_Previews: PreviewProvider {
    static var previews: some View {
        AddFoodCameraView(vm: NutritionViewModel())
    }
}
