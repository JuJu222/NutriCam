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
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), nutrition: Nutrition())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        do {
            let nutrition = try getData()
            let entry = SimpleEntry(date: Date(), nutrition: nutrition)
            completion(entry)
        } catch {
            print(error)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        do {
            let nutrition = try getData()
            let entry = SimpleEntry(date: Date(), nutrition: nutrition)
            
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        } catch {
            print(error)
        }
    }
    
    private func getData() throws -> Nutrition {
        let request = FoodNutrition.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@", Date().midnight() as CVarArg)
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
        NutriCamWidgetEntryView(entry: SimpleEntry(date: Date(), nutrition: Nutrition()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
