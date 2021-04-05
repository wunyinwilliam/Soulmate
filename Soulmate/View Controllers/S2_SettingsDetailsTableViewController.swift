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
            SectionsList = [[""], [""], [""], [""], [""]]
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
            titleName = nil
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
            if self.title == "Notifications" {
                textLabel.text = "Disable Notifications"
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
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    self.performSegue(withIdentifier: "S2ToS3Segue", sender: self)
                default:
                    self.performSegue(withIdentifier: "S2ToS3Segue", sender: self)
                }
            case 1:
                self.performSegue(withIdentifier: "S2ToS3Segue", sender: self)
            default:
                self.performSegue(withIdentifier: "S2ToS3Segue", sender: self)
            }
        case "Notifications":
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
            self.navigationController?.popViewController(animated: true)
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
    
    
    // MARK: - Navigations
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "S2ToS3Segue" {
            let target = segue.destination as! S3_SettingsMoreDetailsViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                target.title = SectionsList[indexPath.section][indexPath.row]
            }
        }
    }
}
