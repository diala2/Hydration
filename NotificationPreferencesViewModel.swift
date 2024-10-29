//
//  NotificationPreferencesViewModel.swift
//  Hydration
//
//  Created by Diala Abdulnasser Fayoumi on 24/04/1446 AH.
//
import Foundation
import UserNotifications
import SwiftUI

class NotificationPreferencesViewModel: ObservableObject {
    @Published var startHour: String = "3"
    @Published var startAMPM: String = "PM"
    @Published var endHour: String = "3"
    @Published var endAMPM: String = "AM"
    @Published var notificationInterval: Int = 0
    @Published var notificationMessage: String = ""
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    init() {
        requestNotificationPermission()
    }
    
    private func requestNotificationPermission() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
            
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
    
    func scheduleNotifications() {
        cancelAllNotifications()
        
        guard let interval = notificationIntervalInMinutes(), interval > 0 else {
            print("Invalid notification interval.")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Hydration Reminder"
        content.body = "It's time to hydrate! Keep up with your water intake goal."
        content.sound = UNNotificationSound.default

        let startDate = convertTo24HourFormat(hour: startHour, ampm: startAMPM)
        let endDate = convertTo24HourFormat(hour: endHour, ampm: endAMPM)

        // Ensure startDate is before endDate
        guard startDate < endDate else {
            print("Start time must be before end time.")
            return
        }

        // Initialize notification time
        var notificationTime = startDate

        while notificationTime <= endDate {
            let hour = Calendar.current.component(.hour, from: notificationTime)
            let minute = Calendar.current.component(.minute, from: notificationTime)

            let dateComponents = DateComponents(hour: hour, minute: minute)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            notificationCenter.add(request) { error in
                if let error = error {
                    print("Failed to add notification: \(error)")
                } else {
                    print("Notification scheduled for \(hour):\(String(format: "%02d", minute))")
                }
            }

            // Update notificationTime by adding the interval
            notificationTime = Calendar.current.date(byAdding: .minute, value: interval, to: notificationTime) ?? endDate.addingTimeInterval(1)
        }

        notificationMessage = "Notifications scheduled every \(interval) minutes from \(startHour) \(startAMPM) to \(endHour) \(endAMPM)."
    }

    private func cancelAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
        print("All pending notifications have been canceled.")
    }
    
    private func notificationIntervalInMinutes() -> Int? {
        let intervals = [1, 30, 60, 90, 120, 180, 240, 300]
        return notificationInterval < intervals.count ? intervals[notificationInterval] : nil
    }
    
    private func convertTo24HourFormat(hour: String, ampm: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h a" // 12-hour format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let dateString = "\(hour) \(ampm)"
        return dateFormatter.date(from: dateString) ?? Date()
    }

    func notificationIntervalLabel(for index: Int) -> String {
        let intervals = [
            "15 Mins", "30 Mins", "60 Mins", "90 Mins",
            "2 Hours", "3 Hours", "4 Hours", "5 Hours"
        ]
        return intervals[index]
    }
}
