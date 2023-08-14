//
//  AddFoodCameraView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 05/08/23.
//

import SwiftUI

struct AddFoodCameraView: View {
    
    @ObservedObject var vm: NutritionViewModel
    @State var showCamera = true
    @StateObject var camera = CameraModel()
    @StateObject var classification = ImageClassification()
    @State var weight: Double = 0
    
    var body: some View {
        if showCamera {
            NavigationStack {
                CustomCameraView(showCamera: $showCamera)
                    .environmentObject(camera)
            }
        } else {
            NavigationStack {
                ScrollView {
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
                        Image(uiImage: camera.image!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200)
                        Text(classification.classificationLabel)
                            .padding(20)
                            .foregroundColor(.black)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.secondary)
                                )
                        Text(classification.searchQuery)
                        if vm.hintFoods.count > 0 {
                            Text(vm.hintFoods[0].food?.label ?? "")
                            
                            Text("\(String(format: "%.0f", weight)) gram per serving")
                                .onAppear {
                                    vm.hintFoods[0].measures?.forEach({ measure in
                                        if measure.label == "Serving" {
                                            weight = measure.weight ?? 0
                                        }
                                    })
                                }
                                .padding()
                            
                            VStack (alignment: .leading) {
                                HStack {
                                    Text("Nutrients")
                                        .font(.title3)
                                        .bold()
                                        .padding(.bottom)
                                    
                                    Spacer()
                                }
                                
                                HStack {
                                    Text("Calories")
                                    
                                    Spacer()
                                    
                                    Text("\(String(format: "%.0f", vm.hintFoods[0].food?.nutrients?.ENERC_KCAL ?? 0)) kcal")
                                }
                                Divider()
                                    .padding(.bottom, 4)
                                
                                HStack {
                                    Text("Protein")
                                    
                                    Spacer()
                                    
                                    Text("\(String(format: "%.2f", vm.hintFoods[0].food?.nutrients?.PROCNT ?? 0)) g")
                                }
                                Divider()
                                    .padding(.bottom, 4)
                                
                                HStack {
                                    Text("Fat")
                                    
                                    Spacer()
                                    
                                    Text("\(String(format: "%.2f", vm.hintFoods[0].food?.nutrients?.FAT ?? 0)) g")
                                }
                                Divider()
                                    .padding(.bottom, 4)
                                
                                HStack {
                                    Text("Carbohydrates")
                                    
                                    Spacer()
                                    
                                    Text("\(String(format: "%.2f", vm.hintFoods[0].food?.nutrients?.CHOCDF ?? 0)) g")
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color("Background"))
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Text("Cancel")
                                .foregroundColor(.red)
                                .onTapGesture {
                                    vm.showAddSheet.toggle()
                                }
                        }
                    }
                    .onAppear {
                        classification.updateClassifications(for: camera.image!)
                    }
                    .onChange(of: classification.doneClassifying) { newValue in
                        if classification.doneClassifying {
                            vm.foodName = classification.searchQuery
//                            vm.fetchEdamamFoods()
                        }
                    }
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
