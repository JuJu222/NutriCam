//
//  NutriCamWidget.swift
//  NutriCamWidget
//
//  Created by Maximus Aurelius Wiranata on 29/07/23.
//

import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
    let nutrition: Nutrition
    let profile: Profile
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), nutrition: Nutrition(), profile: Profile())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        do {
            let nutrition = try getNutritionData()
            let profile = try getProfileData()
            let entry = SimpleEntry(date: Date(), nutrition: nutrition, profile: profile)
            completion(entry)
        } catch {
            print(error)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        do {
            let nutrition = try getNutritionData()
            let profile = try getProfileData()
            let entry = SimpleEntry(date: Date(), nutrition: nutrition, profile: profile)
            
            let timeline = Timeline(entries: [entry], policy: .after(.now.advanced(by: 60 * 60)))
            completion(timeline)
        } catch {
            print(error)
        }
    }
    
    private func getNutritionData() throws -> Nutrition {
        let request = FoodNutrition.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ && date <= %@", Date().midnight() as CVarArg, Calendar.current.startOfDay(for: Date().midnight() + 86400) as CVarArg)
        
        let result = try PersistenceController.shared.container.viewContext.fetch(request)
        
        var dailyNutrition = Nutrition()
        
        result.forEach { food in
            dailyNutrition.calories += food.calories
            dailyNutrition.protein += food.protein
            dailyNutrition.fat += food.fat
            dailyNutrition.carbs += food.carbs
        }
        
        return dailyNutrition
    }
    
    private func getProfileData() throws -> Profile {
        let request = Profile.fetchRequest()
        let result = try PersistenceController.shared.container.viewContext.fetch(request)
        
        let profile = result.first
        
        return profile ?? Profile()
    }
}

struct NutriCamWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    
    var entry: Provider.Entry

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            SmallSizeView(entry: entry)
        case .systemMedium:
            MediumSizeView(entry: entry)
        default:
            Text("Not implemented!")
        }
    }
}

struct NutriCamWidget: Widget {
    let kind: String = "NutriCamWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            NutriCamWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("NutriCam Widget")
        .description("This widget displays information about your daily nutrition, including calories, protein, fat, and carbs.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct NutriCamWidget_Previews: PreviewProvider {
    static var previews: some View {
        NutriCamWidgetEntryView(entry: SimpleEntry(date: Date(), nutrition: Nutrition(), profile: Profile()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
