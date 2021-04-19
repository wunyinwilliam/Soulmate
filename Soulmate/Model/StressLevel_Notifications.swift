//
//  StressLevel_Notifications.swift
//  Soulmate
//
//  Created by Will Lam on 19/4/2021.
//

import UIKit
import RealmSwift
import UserNotifications
import HealthKit

class StressLevel_Notifications: UIViewController, UNUserNotificationCenterDelegate {
    
    // MARK: Asking Stress Level Notifications
    
    func sendAskingStressLevelNotifications(min: Int?, hour: Int?, weekday: Int?) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let content = UNMutableNotificationContent()
        content.title = "Stress Level"
        content.body = "What is your current stress level?"
        content.sound = .default
        content.categoryIdentifier = "stressLevelIdentifier"
  
        // Setup trigger time
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        var dateComponents = DateComponents()
        if min != nil {
            dateComponents = DateComponents(calendar: calendar,
                                            minute: min)
        } else if hour != nil {
            dateComponents = DateComponents(calendar: calendar,
                                            hour: hour)
        } else if weekday != nil {
            dateComponents = DateComponents(calendar: calendar,
                                            weekday: weekday)
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        // Create request
        let request = UNNotificationRequest(identifier: askingStressLevelNotificationID, content: content, trigger: trigger)
        center.add(request) { (error : Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        let high = UNNotificationAction(identifier: "high", title: "high", options: [])
        let aboveAverage = UNNotificationAction(identifier: "aboveAverage", title: "above average", options: [])
        let average = UNNotificationAction(identifier: "average", title: "average", options: [])
        let belowAverage = UNNotificationAction(identifier: "belowAverage", title: "below average", options: [])
        let low = UNNotificationAction(identifier: "low", title: "low", options: [])
        let category = UNNotificationCategory(identifier: "stressLevelIdentifier", actions: [high, aboveAverage, average, belowAverage, low], intentIdentifiers: [], options: .customDismissAction)
        center.setNotificationCategories([category])
    }
    
    
    // MARK: Encouraging Quote Notifications
    
    func sendEncouragingQuoteNotifications(min: Int?, hour: Int?, weekday: Int?) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let content = UNMutableNotificationContent()
        content.title = "Encouraging Quote"
        content.body = quotesList.randomElement()!
        content.sound = .default
        content.categoryIdentifier = "encouragingQuoteIdentifier"
  
        // Setup trigger time
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        var dateComponents = DateComponents()
        if min != nil {
            dateComponents = DateComponents(calendar: calendar,
                                            minute: min)
        } else if hour != nil {
            dateComponents = DateComponents(calendar: calendar,
                                            hour: hour)
        } else if weekday != nil {
            dateComponents = DateComponents(calendar: calendar,
                                            weekday: weekday)
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        // Create request
        let request = UNNotificationRequest(identifier: encouragingQuoteNotificationID, content: content, trigger: trigger)
        center.add(request) { (error : Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    
    // MARK: Stress Reminder Notifications

    func sendStressReminderNotifications(stressLevel: Int) {
        if let latestRecord = currentuser.userStressIndexRecord?.records.last {
            let center = UNUserNotificationCenter.current()
            if latestRecord.stressIndex >= stressLevel && stressReminder_Notifications_Enable {
                let content = UNMutableNotificationContent()
                content.title = "Stress Reminder"
                content.body = "You are estimated as high stress level recently. Let's have some relaxing time."
                content.sound = .default
                content.categoryIdentifier = "stressReminderIdentifier"

                // Setup trigger time
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60*30, repeats: false)

                // Create request
                let request = UNNotificationRequest(identifier: stressReminderNotificationID, content: content, trigger: trigger)
                center.add(request) { (error : Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            } else {
                center.removePendingNotificationRequests(withIdentifiers: [stressReminderNotificationID])
            }
        }
    }
    
    
    // MARK: - userNotificationCenter (willPresent)
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Play sound and show alert to the user
        completionHandler([.list, .banner, .badge, .sound])
    }
    
    
    // MARK: - userNotificationCenter (didReceive)
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.content.categoryIdentifier == "stressLevelIdentifier" {
            let heartRate = self.updateHeartRate()
            let activity = self.updateActivity()
            let mindfulTime = self.updateMindfulTime()
            let sleepTime = self.updateSleepTime()
            // Determine the user action
            switch response.actionIdentifier {
            case UNNotificationDismissActionIdentifier:
                print("Dismiss Action")
            case UNNotificationDefaultActionIdentifier:
                print("Default")
            case "high":
                self.saveStressLevelIndex(index: 9, heartRate: heartRate, activity: activity, mindfulTime: mindfulTime, sleepTime: sleepTime)
            case "aboveAverage":
                self.saveStressLevelIndex(index: 7, heartRate: heartRate, activity: activity, mindfulTime: mindfulTime, sleepTime: sleepTime)
            case "average":
                self.saveStressLevelIndex(index: 5, heartRate: heartRate, activity: activity, mindfulTime: mindfulTime, sleepTime: sleepTime)
            case "belowAverage":
                self.saveStressLevelIndex(index: 3, heartRate: heartRate, activity: activity, mindfulTime: mindfulTime, sleepTime: sleepTime)
            case "low":
                self.saveStressLevelIndex(index: 1, heartRate: heartRate, activity: activity, mindfulTime: mindfulTime, sleepTime: sleepTime)
            default:
                print("Unknown action")
            }
        }
        completionHandler()
    }
    
    
    // MARK: - Private Functions
    
    private func saveStressLevelIndex(index: Int, heartRate: Double, activity: Double, mindfulTime: Double, sleepTime: Double) {
        let record = StressIndexRecordObject()
        record.date = Date()
        record.stressIndex = index
        record.heartRate = heartRate
        record.activeEnergy = activity
        record.mindfulMinutes = mindfulTime
        record.sleepHours = sleepTime
        
        let userStressIndexRecord = StressIndexRecord()
        // Append old records
        if currentuser.userStressIndexRecord != nil {
            for r in currentuser.userStressIndexRecord!.records {
                userStressIndexRecord.records.append(r)
            }
        }
        // Append the latest record
        userStressIndexRecord.records.append(record)
        
        let realm = try! Realm()
        let user = realm.objects(User.self).filter("userID == \(currentuser.userID)").first
        try! realm.write {
            user!.userStressIndexRecord = userStressIndexRecord
        }
        sendStressReminderNotifications(stressLevel: stressReminder_Notifications_StressLevel)
    }
    
    
    private func updateHeartRate() -> Double {
        if let firstRecord = userHealthProfile.heartRate.first {
            return firstRecord.quantity.doubleValue(for: HKUnit(from: "count/min"))
        }
        return 0.0
    }
    
    
    private func updateActivity() -> Double {
        if let firstRecord = userHealthProfile.activeEnergy.first {
            if let sum = firstRecord.sumQuantity() {
                return sum.doubleValue(for: .kilocalorie())
            }
        }
        return 0.0
    }
    
    
    private func updateMindfulTime() -> Double {
        if userHealthProfile.mindfulMinutes.count > 10 {
            var mindfulMinutes: Double = 0
            for record in userHealthProfile.mindfulMinutes.prefix(10) {
                if Calendar.current.startOfDay(for: record.endDate) == Calendar.current.startOfDay(for: Date()) {
                    mindfulMinutes += record.endDate.timeIntervalSince(record.startDate)/60
                }
            }
            return mindfulMinutes
        }
        return 0.0
    }
    
    
    private func updateSleepTime() -> Double {
        if userHealthProfile.sleepHours.count > 10 {
            var sleepHours: Double = 0.0
            for record in userHealthProfile.sleepHours.prefix(10) {
                if Calendar.current.startOfDay(for: record.endDate) == Calendar.current.startOfDay(for: Date()) {
                    sleepHours += Double(record.endDate.timeIntervalSince(record.startDate)/3600)
                }
            }
            return sleepHours
        }
        return 0.0
    }

}
