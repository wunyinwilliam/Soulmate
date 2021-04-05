//
//  S1_SettingsTableViewController.swift
//  Soulmate
//
//  Created by Will Lam on 4/3/2021.
//

import UIKit
import RealmSwift

class S1_SettingsTableViewController: UITableViewController {
    
    // MARK: - Variables
    
    var tapView: Int = -1
    

    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
        navigationController?.title = "Settings"
        
        self.overrideUserInterfaceStyle = .light
    }
    
    
    // MARK: - UITableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {                                             // User Info
            tapView = 0
            self.performSegue(withIdentifier: "S1ToS2Segue", sender: self)
        } else if indexPath.section == 1 && indexPath.row == 0 {                // Notifications
            tapView = 1
            self.performSegue(withIdentifier: "S1ToS2Segue", sender: self)
        } else if indexPath.section == 1 && indexPath.row == 1 {                // Health Normal Range
            tapView = 2
            self.performSegue(withIdentifier: "S1ToS2Segue", sender: self)
        } else if indexPath.section == 2 {                                      // Logout
            tapView = 3
            self.loggingOut()
            self.performSegue(withIdentifier: "S1ToL1Segue", sender: self)
        }
    }
    
    
    // MARK: - Private Functions
    
    private func loggingOut() {
        let realm = try! Realm()
        let login_results = realm.objects(Login.self)
        if login_results.count == 0 {
            try! realm.write {
                let login = Login()
                login.isLogin = false
                realm.add(login)
            }
        }
        let current_login = login_results.first
        try! realm.write {
            current_login!.isLogin = false
        }
    }
    
    
    // MARK: - Navigations
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "S1ToS2Segue" {
            let target = segue.destination as! S2_SettingsDetailsTableViewController
            switch tapView {
            case 0:
                target.title = "User Info"
            case 1:
                target.title = "Notifications"
            default:
                target.title = "Normal Range"
            }
        }
    }

}
