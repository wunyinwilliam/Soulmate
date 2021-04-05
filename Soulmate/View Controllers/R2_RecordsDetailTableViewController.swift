//
//  R2_RecordsDetailTableViewController.swift
//  Soulmate
//
//  Created by Will Lam on 17/3/2021.
//

import UIKit
import RealmSwift

class R2_RecordsDetailTableViewController: UITableViewController {
    
    // MARK: - Variables
    
    @IBOutlet weak var lb_stressIndex: UILabel!
    @IBOutlet weak var lb_activeEnergy: UILabel!
    @IBOutlet weak var lb_heartRate: UILabel!
    @IBOutlet weak var lb_mindfulMinutes: UILabel!
    @IBOutlet weak var lb_sleepHours: UILabel!
    
    var record: StressIndexRecordObject? = nil
    
    
    // MARK: - Actions
    
    @IBAction func edit_pressed(_ sender: UIBarButtonItem) {
        self.showAlert()
    }
    
    
    // MARK: - Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupStressIndexLabel()
        self.setupActivityLabel()
        self.setupHeartRateLabel()
        self.setupMindfulMinutesLabel()
        self.setupSleepHoursLabel()
    }
    
    
    // MARK: - Private Functions
    
    private func setupStressIndexLabel() {
        if let record = record {
            lb_stressIndex.text = String(record.stressIndex)
            if record.stressIndex <= 3 {
                self.lb_activeEnergy.textColor = .systemGreen
            } else if record.stressIndex >= 7 {
                self.lb_activeEnergy.textColor = .red
            } else {
                self.lb_activeEnergy.textColor = .black
            }
        }
    }
    
    
    private func setupActivityLabel() {
        if let record = record {
            self.lb_activeEnergy.text = String(record.activeEnergy.rounded(toPlaces: 2)) + " kcal"
            var activeEnergy_min: Double = 200.0
            var activeEnergy_max: Double = 1000.0
            if Calendar.current.isDateInWeekend(record.date) {
                activeEnergy_min = currentuser.userNormalRange?.activeEnergy?.weekends_min ?? 0.0
                activeEnergy_max = currentuser.userNormalRange?.activeEnergy?.weekends_max ?? 0.0
            } else {
                activeEnergy_min = currentuser.userNormalRange?.activeEnergy?.weekdays_min ?? 0.0
                activeEnergy_max = currentuser.userNormalRange?.activeEnergy?.weekdays_max ?? 0.0
            }
            
            if record.activeEnergy < activeEnergy_min {
                self.lb_activeEnergy.textColor = .red
            } else if record.activeEnergy > activeEnergy_max {
                self.lb_activeEnergy.textColor = .systemGreen
            } else {
                self.lb_activeEnergy.textColor = .black
            }
        }
    }
    
    
    private func setupHeartRateLabel() {
        if let record = record {
            lb_heartRate.text = String(record.heartRate.rounded(toPlaces: 2)) + " count/min"
            let heartRateInBPM = record.heartRate
            if heartRateInBPM < currentuser.userNormalRange?.heartRate?.weekdays_min ?? 0.0 {
                self.lb_heartRate.textColor = .systemGreen
            } else if heartRateInBPM > currentuser.userNormalRange?.heartRate?.weekdays_max ?? 0.0 {
                self.lb_heartRate.textColor = .red
            } else {
                self.lb_heartRate.textColor = .black
            }
        }
    }
    
    
    private func setupMindfulMinutesLabel() {
        if let record = record {
            lb_mindfulMinutes.text = String(record.mindfulMinutes.rounded(toPlaces: 2)) + " mins"
            var mindfulMinutes_min: Double = 0
            var mindfulMinutes_max: Double = 180
            if Calendar.current.isDateInWeekend(record.date) {
                mindfulMinutes_min = currentuser.userNormalRange?.mindfulMinutes?.weekends_min ?? 0.0
                mindfulMinutes_max = currentuser.userNormalRange?.mindfulMinutes?.weekends_max ?? 0.0
            } else {
                mindfulMinutes_min = currentuser.userNormalRange?.mindfulMinutes?.weekdays_min ?? 0.0
                mindfulMinutes_max = currentuser.userNormalRange?.mindfulMinutes?.weekdays_max ?? 0.0
            }
            if record.mindfulMinutes < mindfulMinutes_min {
                self.lb_mindfulMinutes.textColor = .red
            } else if record.activeEnergy > mindfulMinutes_max {
                self.lb_mindfulMinutes.textColor = .systemGreen
            } else {
                self.lb_mindfulMinutes.textColor = .black
            }
        }
    }
    
    
    private func setupSleepHoursLabel() {
        if let record = record {
            lb_sleepHours.text = String(record.sleepHours.rounded(toPlaces: 2)) + " hrs"
            var sleepHours_min: Double = 4.0
            var sleepHours_max: Double = 10.0
            if Calendar.current.isDateInWeekend(userHealthProfile.mindfulMinutes.first!.startDate) {
                sleepHours_min = currentuser.userNormalRange?.sleepHours?.weekends_min ?? 0.0
                sleepHours_max = currentuser.userNormalRange?.sleepHours?.weekends_max ?? 0.0
            } else {
                sleepHours_min = currentuser.userNormalRange?.sleepHours?.weekdays_min ?? 0.0
                sleepHours_max = currentuser.userNormalRange?.sleepHours?.weekdays_max ?? 0.0
            }
            if record.sleepHours < sleepHours_min {
                self.lb_sleepHours.textColor = .red
            } else if record.sleepHours > sleepHours_max {
                self.lb_sleepHours.textColor = .systemGreen
            } else {
                self.lb_sleepHours.textColor = .black
            }
        }
    }

    
    private func showAlert() {
        let alert = UIAlertController(title: "Stress Index (0-10):", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.keyboardType = .numberPad
            textField.addTarget(alert, action: #selector(alert.textDidChange), for: .editingChanged)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.editRecords((textField?.text)!)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func editRecords(_ value: String) {
        let newStressIndex = Int(value)
        let selectedDate = record?.date
        if let stressIndexRecord = currentuser.userStressIndexRecord {
            let newRecords = StressIndexRecord()
            for record in stressIndexRecord.records {
                if record.date != selectedDate {
                    newRecords.records.append(record)
                } else {
                    let newRecordObject = StressIndexRecordObject()
                    newRecordObject.stressIndex = newStressIndex!
                    newRecordObject.date = record.date
                    newRecordObject.activeEnergy = record.activeEnergy
                    newRecordObject.heartRate = record.heartRate
                    newRecordObject.mindfulMinutes = record.mindfulMinutes
                    newRecordObject.sleepHours = record.sleepHours
                    newRecords.records.append(newRecordObject)
                }
            }
            let realm = try! Realm()
            let user = realm.objects(User.self).filter("userID == \(currentuser.userID)").first
            try! realm.write {
                user!.userStressIndexRecord = newRecords
            }
        }
        self.lb_stressIndex.text = value
    }
}
