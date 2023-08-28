//
//  AddFoodCameraView.swift
//  NutriCam
//
//  Created by Maximus Aurelius Wiranata on 05/08/23.
//

import SwiftUI

struct AddFoodCameraView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var vm: NutritionViewModel
    @State var showCamera = true
    @StateObject var camera = CameraModel()
    @StateObject var classification = ImageClassification()
    @State var food: Hint = Hint()
    @State private var path = NavigationPath()
    
    @State var measures: [Measure] = []
    
    @State var weightPerMeasure: Double = 0
    @State var nutritionPerGram: Nutrition = Nutrition()
    
    @State var weight: Double = 1
    @State var selectedMeasure: String = "Serving"
    
    @State var labels: [String] = []
    
    var body: some View {
        
        ZStack {
            CustomCameraView(showCamera: $showCamera)
                .environmentObject(camera)
            
            if !showCamera {
                NavigationStack(path: $path) {
                    ScrollView {
                        VStack {
                            //                                    HStack {
                            //                                        TextField("Food Name", text: $vm.foodName)
                            //
                            //                                        NavigationLink(destination: SelectFoodView(vm: vm)) {
                            //                                            Text("Next")
                            //                                                .padding(8)
                            //                                                .background(Color.accentColor)
                            //                                                .foregroundColor(.white)
                            //                                                .cornerRadius(100)
                            //                                        }
                            //                                    }
                            //                        .padding(.bottom)
                            Image(uiImage: camera.image!)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(16)
                            //                        Text(classification.classificationLabel)
                            //                            .padding(20)
                            //                            .foregroundColor(.black)
                            //                            .background(
                            //                                RoundedRectangle(cornerRadius: 10)
                            //                                    .foregroundColor(.secondary)
                            //                                )
                            //                        Text(classification.searchQuery)
                            if (food.food != nil) {
                                //                            Text(food.food?.label ?? "")
                                //                                .font(.largeTitle)
                                
                                //                            Text("\(String(format: "%.0f", weight)) gram per serving")
                                //                                .onAppear {
                                //                                    food.measures?.forEach({ measure in
                                //                                        if measure.label == "Serving" {
                                //                                            weight = measure.weight ?? 0
                                //                                        }
                                //                                    })
                                //                                }
                                //                                .padding()
                                
                                VStack {
                                    //                                AsyncImage(url: URL(string: food.food?.image ?? "")) { image in
                                    //                                    image
                                    //                                        .resizable()
                                    //                                        .aspectRatio(contentMode: .fill)
                                    //                                        .frame(height: 200)
                                    //                                        .clipped()
                                    //                                        .cornerRadius(16)
                                    //                                } placeholder: {
                                    //                                    Color.gray
                                    //                                        .frame(height: 200)
                                    //                                        .cornerRadius(16)
                                    //                                }
                                    //                                .padding(.horizontal)
                                    
                                    HStack(spacing: 8) {
                                        TextField("Weight", value: $weight, format: .number)
                                            .frame(width: UIScreen.main.bounds.width / 5)
                                            .padding(14)
                                            .background(colorScheme == .dark ? Color(UIColor.systemGray6) : .white)
                                            .cornerRadius(8)
                                        
                                        Picker("Measure", selection: $selectedMeasure) {
                                            ForEach(labels, id: \.self) { label in
                                                Text(label)
                                            }
                                        }
                                        .padding(8)
                                        .background(colorScheme == .light ? .white : Color(UIColor.systemGray6))
                                        .cornerRadius(8)
                                    }
                                    .padding()
                                    
                                    Text("\(weightPerMeasure, specifier: "%.1f") grams per \(selectedMeasure)")
                                        .padding(.bottom)
                                    
                                    Text("NUTRIENTS")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .fontWeight(.regular)
                                        .font(.system(size: 13))
                                        .foregroundColor(Color(UIColor.systemGray))
                                        .padding(.leading, 16)
                                    
                                    VStack {
                                        HStack {
                                            Text("Calories")
                                            
                                            Spacer()
                                            
                                            Text("\(String(format: "%.0f", nutritionPerGram.calories * weightPerMeasure * weight)) kcal")
                                        }
                                        Divider()
                                        HStack {
                                            Text("Protein")
                                            
                                            Spacer()
                                            
                                            Text("\(String(format: "%.1f", nutritionPerGram.protein * weightPerMeasure * weight)) g")
                                        }
                                        Divider()
                                        HStack {
                                            Text("Fat")
                                            
                                            Spacer()
                                            
                                            Text("\(String(format: "%.1f", nutritionPerGram.fat * weightPerMeasure * weight)) g")
                                        }
                                        Divider()
                                        HStack {
                                            Text("Carbohydrates")
                                            
                                            Spacer()
                                            
                                            Text("\(String(format: "%.1f", nutritionPerGram.carbs * weightPerMeasure * weight)) g")
                                        }
                                    }
                                    .padding(16)
                                    .background(colorScheme == .light ? .white : Color(UIColor.systemGray6))
                                    .cornerRadius(16)
                                    
                                    Spacer()
                                    
                                    Text("Is the result wrong?")
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                        .padding(.top)
                                    
                                    HStack {
                                        Button {
                                            path.append("SelectFoodViewVariant")
                                        } label: {
                                            HStack {
                                                Spacer()
                                                Text("Choose Variant")
                                                    .foregroundColor(Color.accentColor)
                                                    .font(.headline)
                                                Spacer()
                                            }
                                            .padding()
                                            .background(.white)
                                            .cornerRadius(100)
                                        }
                                        Button {
                                            path.append("SelectFoodViewNew")
                                        } label: {
                                            HStack {
                                                Spacer()
                                                Text("Change Food")
                                                    .foregroundColor(Color.accentColor)
                                                    .font(.headline)
                                                Spacer()
                                            }
                                            .padding()
                                            .background(.white)
                                            .cornerRadius(100)
                                        }
                                    }
                                    .padding(.bottom)
                                    .frame(maxWidth: .infinity)
                                    
                                    Button {
                                        vm.addFood(
                                            calories: nutritionPerGram.calories * weightPerMeasure * weight,
                                            carbs: nutritionPerGram.carbs * weightPerMeasure * weight,
                                            fat: nutritionPerGram.fat * weightPerMeasure * weight,
                                            protein: nutritionPerGram.protein * weightPerMeasure * weight,
                                            name: food.food?.label ?? "Food Name",
                                            meal: vm.selectedMeal,
                                            date: vm.currentDay,
                                            weight: weight,
                                            measure: selectedMeasure
                                        )
                                        
                                        vm.fetchDailyNutrition()
                                        
                                        vm.showAddSheet.toggle()
                                    } label: {
                                        HStack {
                                            Text("Add to My Nutrition")
                                                .frame(maxWidth: .infinity)
                                                .foregroundColor(.white)
                                                .font(.headline)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.accentColor)
                                        .cornerRadius(100)
                                    }
                                }
                                .onAppear {
                                    measures = food.measures ?? []
                                    
                                    measures.forEach { measure in
                                        if let label = measure.label {
                                            labels.append(label)
                                        }
                                    }
                                    
                                    if !labels.contains("Serving") {
                                        measures.insert(Measure(label: "Serving", weight: 100), at: 0)
                                        labels.insert("Serving", at: 0)
                                    }
                                    
                                    nutritionPerGram = vm.countNutritionPerGram(calories: food.food?.nutrients?.ENERC_KCAL ?? 0, protein: food.food?.nutrients?.PROCNT ?? 0, fat: food.food?.nutrients?.FAT ?? 0, carbs: food.food?.nutrients?.CHOCDF ?? 0, weight: measures.first?.weight ?? 100)
                                    
                                    weightPerMeasure = measures.first?.weight ?? 100
                                }
                                .onChange(of: selectedMeasure) { newValue in
                                    measures.forEach({ measure in
                                        if measure.label == selectedMeasure {
                                            weightPerMeasure = measure.weight ?? 100
                                        }
                                    })
                                }
                            } else {
                                ProgressView()
                                    .padding(.vertical, 100)
                            }
                            Spacer()
                        }
                        .navigationTitle(food.food?.label ?? "Please Wait...")
                        .padding()
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    DispatchQueue.main.async {
                                        withAnimation{
                                            showCamera.toggle()
                                        }
                                        food.food = nil
                                        camera.retake()
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "chevron.backward")
                                        Text("Back")
                                    }
                                }
                            }
                        }
                        .onAppear {
                            vm.hintFoods = []
                            classification.updateClassifications(for: camera.image!)
                        }
                        .onChange(of: classification.doneClassifying) { newValue in
                            if classification.doneClassifying {
                                classification.doneClassifying = false
                                vm.foodName = classification.searchQuery
                                vm.fetchEdamamFoods(newSearch: false)
                            }
                        }
                        .onChange(of: vm.hintFoods) { newValue in
                            withAnimation{
                                if vm.hintFoods.count > 0 {
                                    food = vm.hintFoods[0]
                                }
                            }
                        }
                    }
                    .background(Color("Background"))
                    .navigationDestination(for: String.self) { view in
                        if view == "SelectFoodViewVariant" {
                            SelectFoodView(vm: vm, newSearch: false)
                        } else if view == "SelectFoodViewNew" {
                            SelectFoodView(vm: vm, newSearch: true)
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
