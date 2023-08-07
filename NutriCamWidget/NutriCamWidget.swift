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
    let nutritions: Nutrition
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), nutritions: Nutrition())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        Task {
            let entry = SimpleEntry(date: Date(), nutritions: WidgetService.shared.nutrition)
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let entry = SimpleEntry(date: Date(), nutritions: WidgetService.shared.nutrition)
            
            let timeline = Timeline(entries: [entry], policy: .after(.now.advanced(by: 60 * 60 * 30)))
            
            completion(timeline)
        }
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
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct NutriCamWidget_Previews: PreviewProvider {
    static var previews: some View {
        NutriCamWidgetEntryView(entry: SimpleEntry(date: Date(), nutritions: Nutrition()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
