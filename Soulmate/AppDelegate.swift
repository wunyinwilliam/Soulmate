//
//  AppDelegate.swift
//  Soulmate
//
//  Created by Will Lam on 20/2/2021.
//

import UIKit
import BackgroundTasks
import Kommunicate
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        authorizeHealthKit()
        self.registerBackgroundTasks()
        Kommunicate.setup(applicationId: "25bf91ac7fe1e011b0882253edbc2cf1d")       // Set up Chatbot
        FirebaseApp.configure()
        return true
    }
    
    private func registerBackgroundTasks() {
        // Ask permission for notifications
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("UNUserNotificationCenter: Permission granted")
            } else {
                print("UNUserNotificationCenter: Permission denied")
            }
        }
        print(" ******* PENDING NOTIFICATIONS *******")
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(request)
            }
        })
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

