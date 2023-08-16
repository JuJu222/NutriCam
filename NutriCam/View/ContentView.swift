//
//  ContentView.swift
//  NutriCam
//
//  Created by Yap Justin on 28/07/23.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    var body: some View {
        TabView {
            NutritionView()
                .tabItem {
                    Label("My Nutrition", systemImage: "fork.knife")
                }

            StatisticsView()
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .onAppear {
            scheduleNotifications()
        }
    }
    
    func scheduleNotifications() {
        let notificationTimes: [DateComponents] = [
            makeDateComponents(hour: 6),
            makeDateComponents(hour: 12),
            makeDateComponents(hour: 18)
        ]
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
                
                for components in notificationTimes {
                    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                    let content = UNMutableNotificationContent()
                    if components.hour == 6 {
                        content.title = "It's time for breakfast!"
                    } else if components.hour == 12 {
                        content.title = "It's time for lunch!"
                    } else if components.hour == 18 {
                        content.title = "It's time for dinner!"
                    }
                    content.body = "Don't forget to add your food"
                    content.sound = UNNotificationSound.default
                    
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request) {
                        error in
                        if let error = error {
                            print("Error scheduling notification:\(error)")
                        } else {
                            print("Notifications scheduled successfully")
                        }
                    }
                }
            } else if let error = error {
                print("Error requesting notification permission:\(error)")
            }
        }
    }
        
    func makeDateComponents(hour: Int) -> DateComponents {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = 0
        return dateComponents
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
