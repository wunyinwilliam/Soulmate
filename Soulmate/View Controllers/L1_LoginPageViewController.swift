//
//  ViewController.swift
//  Soulmate
//
//  Created by Will Lam on 20/2/2021.
//

import RealmSwift
import UIKit
import MaterialComponents
import UserNotifications
import HealthKit


class L1_LoginPageViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    // MARK: - Variables

    let tf_email = MDCOutlinedTextField()
    let tf_password = MDCOutlinedTextField()
    let bn_login = MDCButton()
    let bn_signUp = MDCButton()
    let bn_forgetPassword = MDCButton()
    
    var userList = try! Realm().objects(User.self).sorted(byKeyPath: "name", ascending: true)
    
    
    // MARK: - Actions
    
    @objc func pressed_bn_login(_ sender: UIButton) -> Void {
        if authenticatedUser() {
            calculateAverage_AllHealthData()
            
            self.loggingIn()
            self.sendNotifications()
        
            self.performSegue(withIdentifier: "loginSuccessfullySegue", sender: self)
        } else {
            showAlert(title: "Wrong email / password", msg: nil)
        }
    }
    
    @objc func pressed_bn_signUp(_ sender: UIButton) -> Void {
        self.performSegue(withIdentifier: "L1ToL2Segue", sender: self)
    }
    
    @objc func pressed_bn_forgetPassword(_ sender: UIButton) -> Void {
        print("pressed_bn_forgetPassword")
    }
    
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
                
        self.hideKeyboardWhenTappedAround()
        if userList.count == 0 {            // TO BE DELETED
            addNewUsers()                   // TO BE DELETED
        }                                   // TO BE DELETED
    }
    
    
    // MARK: - Private Functions
    
    private func setupUI() {
        tf_email.frame = CGRect(x: 60.0, y: 250.0, width: 255.0, height: 30.0)
        tf_email.center.x = self.view.center.x
        tf_email.label.text = "Email"
        tf_email.applyTheme(withScheme: globalContainerScheme())
        tf_email.text = "will@hku.hk"                               // TO BE DELETED
        tf_email.sizeToFit()
        self.view.addSubview(tf_email)
        
        tf_password.frame = CGRect(x: 60.0, y: 330.0, width: 255.0, height: 30.0)
        tf_password.center.x = self.view.center.x
        tf_password.label.text = "Password"
        tf_password.isSecureTextEntry = true
        tf_password.applyTheme(withScheme: globalContainerScheme())
        tf_password.text = "will"                                      // TO BE DELETED
        tf_password.sizeToFit()
        self.view.addSubview(tf_password)
    
        bn_login.frame = CGRect(x: 60.0, y: 420.0, width: 255.0, height: 50.0)
        bn_login.center.x = self.view.center.x
        bn_login.setTitle("Login", for: .normal)
        bn_login.applyContainedTheme(withScheme: globalContainerScheme())
        bn_login.addTarget(self, action: #selector(pressed_bn_login), for: .touchUpInside)
        self.view.addSubview(bn_login)
        
        bn_signUp.frame = CGRect(x: 60.0, y: 490.0, width: 255.0, height: 50.0)
        bn_signUp.center.x = self.view.center.x
        bn_signUp.setBorderWidth(2.0, for: .normal)
        bn_signUp.setTitle("Sign Up", for: .normal)
        bn_signUp.applyOutlinedTheme(withScheme: globalContainerScheme())
        bn_signUp.addTarget(self, action: #selector(pressed_bn_signUp), for: .touchUpInside)
        self.view.addSubview(bn_signUp)
        
        bn_forgetPassword.frame = CGRect(x: 60.0, y: 560.0, width: 200.0, height: 48.0)
        bn_forgetPassword.center.x = self.view.center.x
        bn_forgetPassword.setTitle("Forget Password", for: .normal)
        bn_forgetPassword.setTitleColor(.brown, for: .normal)
        bn_forgetPassword.setBackgroundColor(.clear)
        bn_forgetPassword.addTarget(self, action: #selector(pressed_bn_forgetPassword), for: .touchUpInside)
        self.view.addSubview(bn_forgetPassword)
    }
    
    
    private func authenticatedUser() -> Bool {
        let predicate = NSPredicate(format: "email = %@ AND password = %@", tf_email.text!, tf_password.text!)
        let user = try! Realm().objects(User.self).filter(predicate)
        
        if user.count == 1 {
            currentuser = user[0]
            return true
        } else {
            return false
        }
    }
    
    
    private func loggingIn() {
        let realm = try! Realm()
        let login_results = realm.objects(Login.self)
        if login_results.count == 0 {
            try! realm.write {
                let login = Login()
                login.isLogin = true
                realm.add(login)
            }
        }
        let current_login = login_results.first
        try! realm.write {
            current_login!.isLogin = true
        }
    }
    
    
    private func showAlert(title: String, msg: String?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        self.present(alert, animated: true)
    }
    
    //
    // MARK: - TO BE DELETED
    // Add Default Users to Database
    private func addNewUsers() {
        print("addNewUsers")
        let realm = try! Realm()
    
        try! realm.write {
            let newUser = User()

            newUser.userID = 0
            newUser.name = "Will"
            newUser.email = "will@hku.hk"
            newUser.password = "will"

            realm.add(newUser)
        }
    }
    
    
    private func sendNotifications() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let content = UNMutableNotificationContent()
        content.title = "Stress Level"
        content.body = "What is your current stress level?"
        content.sound = .default
        content.categoryIdentifier = "stressLevelIdentifier"
        content.userInfo = ["customData": "fizzbuzz"] // You can retrieve this when displaying notification
  
        // Setup trigger time
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let dateComponents = DateComponents(calendar: calendar,
                                            minute: 0)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        // Create request
        let uniqueID = UUID().uuidString // Keep a record of this if necessary
        let request = UNNotificationRequest(identifier: uniqueID, content: content, trigger: trigger)
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Play sound and show alert to the user
        completionHandler([.list, .banner, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
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
        completionHandler()
    }
    
    
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




extension L1_LoginPageViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(L1_LoginPageViewController.dismissKeyboard1))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard1() {
        view.endEditing(true)
    }
}
