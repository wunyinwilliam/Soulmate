//
//  S2_SettingsDetailsTableViewController.swift
//  Soulmate
//
//  Created by Will Lam on 10/3/2021.
//

import UIKit

class S2_SettingsDetailsTableViewController: UITableViewController {

    // MARK: - Variables
    
    var SectionsList: [[String]] = []
    
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch self.title {
        case "User Info":
            SectionsList = [["Name", "Icon"], ["Email"], ["Password"]]
        case "Notifications":
            SectionsList = [["Change Frequency", "Restore Notifications", "Disable Notifications"], ["Change Frequency", "Restore Notifications", "Disable Notifications"], ["Change Frequency", "Restore Notifications", "Disable Notifications"], ["Restore All Notifications", "Disable All Notifications"]]
        default:
            SectionsList = [["Active Energy", "Exercise Minutes", "Stand Minutes", "Steps", "Walking & Running Distance"], ["Heart Rate", "Resting Heart Rate"], ["Blood Oxygen"], ["Mindful Minutes"], ["Sleep Hours"]]
        }
        
        self.tableView.backgroundColor = UIColor(hex: "#F7F7F6FF")
        self.overrideUserInterfaceStyle = .light
    }
    

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SectionsList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SectionsList[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var titleName: String? = nil
        switch self.title {
        case "User Info":
            if section == 1 {
                titleName = "Email"
            } else if section == 2 {
                titleName = "Password"
            }
        case "Notifications":
            switch section {
            case 0:
                titleName = "Asking Stress Level"
            case 1:
                titleName = "Encouraging Quotes"
            case 2:
                titleName = "Stress Reminders"
            default:
                titleName = nil
            }
        default:
            switch section {
            case 0:
                titleName = "Activity"
            case 1:
                titleName = "Heart"
            case 2:
                titleName = "Respiratory"
            case 3:
                titleName = "Mindfulness"
            case 4:
                titleName = "Sleep"
            default:
                titleName = nil
            }
        }
        return titleName
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "S2TableCell", for: indexPath)
        if let textLabel = cell.textLabel {
            textLabel.text = SectionsList[indexPath.section][indexPath.row]
            if (self.title == "Notifications" && (indexPath.section < 3 && indexPath.row == 1 || indexPath.section == 3 && indexPath.row == 0)) {
                textLabel.textColor = .systemGreen
                cell.accessoryType = .none
            }
            if (self.title == "Notifications" && (indexPath.section < 3 && indexPath.row == 2 || indexPath.section == 3 && indexPath.row == 1)) {
                textLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
                textLabel.textColor = .systemRed
                cell.accessoryType = .none
            }
        } else {
            print("ERROR: There is no textLabel in the cell")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.title {
        case "User Info":
            print("NOT YET IMPLEMENTED")
        case "Notifications":
            let center = UNUserNotificationCenter.current()
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    self.performSegue(withIdentifier: "S2ToS3Segue", sender: self)
                case 1:
                    class_StressLevel_Notifications.sendAskingStressLevelNotifications(min: 0, hour: nil, weekday: nil)
                    self.view.makeToast("Restore Successfully", duration: 1.0, position: .center)
                default:
                    center.removePendingNotificationRequests(withIdentifiers: [askingStressLevelNotificationID])
                    self.view.makeToast("Disable Successfully", duration: 1.0, position: .center)
                }
            case 1:
                switch indexPath.row {
                case 0:
                    self.performSegue(withIdentifier: "S2ToS3Segue", sender: self)
                case 1:
                    class_StressLevel_Notifications.sendEncouragingQuoteNotifications(min: 0, hour: nil, weekday: nil)
                    self.view.makeToast("Restore Successfully", duration: 1.0, position: .center)
                default:
                    center.removePendingNotificationRequests(withIdentifiers: [encouragingQuoteNotificationID])
                    self.view.makeToast("Disable Successfully", duration: 1.0, position: .center)
                }
            case 2:
                switch indexPath.row {
                case 0:
                    self.performSegue(withIdentifier: "S2ToS3Segue", sender: self)
                case 1:
                    class_StressLevel_Notifications.sendStressReminderNotifications(stressLevel: 8)
                    self.view.makeToast("Restore Successfully", duration: 1.0, position: .center)
                default:
                    center.removePendingNotificationRequests(withIdentifiers: [stressReminderNotificationID])
                    self.view.makeToast("Disable Successfully", duration: 1.0, position: .center)
                }
            default:
                switch indexPath.row {
                case 0:
                    self.view.makeToast("Restore Successfully", duration: 1.0, position: .center)
                    class_StressLevel_Notifications.sendAskingStressLevelNotifications(min: 0, hour: nil, weekday: nil)
                    class_StressLevel_Notifications.sendEncouragingQuoteNotifications(min: 0, hour: nil, weekday: nil)
                    class_StressLevel_Notifications.sendStressReminderNotifications(stressLevel: 8)
                default:
                    center.removeAllPendingNotificationRequests()
                    self.view.makeToast("Disable Successfully", duration: 1.0, position: .center)
                }
            }
            self.showPendingNotifications()
        default:
            switch indexPath.section {
            case 0:
                self.performSegue(withIdentifier: "S2ToS3Segue", sender: self)
            case 1:
                self.performSegue(withIdentifier: "S2ToS3Segue", sender: self)
            case 2:
                self.performSegue(withIdentifier: "S2ToS3Segue", sender: self)
            case 3:
                self.performSegue(withIdentifier: "S2ToS3Segue", sender: self)
            case 4:
                self.performSegue(withIdentifier: "S2ToS3Segue", sender: self)
            default:
                self.performSegue(withIdentifier: "S2ToS3Segue", sender: self)
            }
        }
    }
    
    
    // MARK: - Private Functions
    
    private func showPendingNotifications() {
        let center = UNUserNotificationCenter.current()
        print(" ******* PENDING NOTIFICATIONS *******")
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(request.identifier)
            }
        })
    }
    
    
    // MARK: - Navigations
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "S2ToS3Segue" {
            let target = segue.destination as! S3_SettingsMoreDetailsViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                if self.title == "Normal Range" {
                    target.title = SectionsList[indexPath.section][indexPath.row]
                } else if self.title == "Notifications" {
                    switch indexPath.section {
                    case 0:
                        target.title = "Asking Stress Level"
                    case 1:
                        target.title = "Encouraging Quotes"
                    default:
                        target.title = "Stress Reminders"
                    }
                }
            }
        }
    }
}
