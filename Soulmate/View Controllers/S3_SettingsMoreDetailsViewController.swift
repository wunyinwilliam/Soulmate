//
//  S3_SettingsMoreDetailsViewController.swift
//  Soulmate
//
//  Created by Will Lam on 12/3/2021.
//

import UIKit
import RealmSwift

class S3_SettingsMoreDetailsViewController: UIViewController {

    
    // MARK: - Variables
    
    @IBOutlet weak var lb_weekdays: UILabel!
    @IBOutlet weak var lb_range_weekdays: UILabel!
    @IBOutlet weak var stepper_low_weekdays: UIStepper!
    @IBOutlet weak var stepper_high_weekdays: UIStepper!
    
    @IBOutlet weak var lb_weekends: UILabel!
    @IBOutlet weak var lb_range_weekends: UILabel!
    @IBOutlet weak var stepper_low_weekends: UIStepper!
    @IBOutlet weak var stepper_high_weekends: UIStepper!
    
    @IBOutlet weak var switch_manual: UISwitch!
    @IBOutlet weak var bn_save: UIBarButtonItem!
    
    var places: Int = 0
    var unit: String = ""

    
    // MARK: - Actions
    
    @IBAction func switch_manual_changed(_ sender: UISwitch) {
        if sender.isOn {
            self.InfoIsHidden(false)
        } else {
            self.InfoIsHidden(true)
        }
    }
    
    @IBAction func stepper_low_weekdays_changed(_ sender: UIStepper) {
        self.updateLabels()
    }
    
    @IBAction func stepper_high_weekdays_changed(_ sender: UIStepper) {
        self.updateLabels()
    }
    
    @IBAction func stepper_low_weekends_changed(_ sender: UIStepper) {
        self.updateLabels()
    }
    
    @IBAction func stepper_high_weekends_changed(_ sender: UIStepper) {
        self.updateLabels()
    }
    
    @IBAction func bn_save_pressed(_ sender: UIBarButtonItem) {
        self.saveData()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupData()
    }
    

    // MARK: - Private Functions
    
    private func setupData() {
        switch self.title {
        case "Active Energy":
            if let data = currentuser.userNormalRange?.activeEnergy {
                if data.isManual {
                    switch_manual.isOn = true
                    self.InfoIsHidden(false)
                } else {
                    switch_manual.isOn = false
                    self.InfoIsHidden(true)
                }
                self.places = 2
                self.unit = "kcal"
                self.updateSteppers(min: 0, max: 5000, step: 100)
                self.stepper_low_weekdays.value = data.weekdays_min
                self.stepper_high_weekdays.value = data.weekdays_max
                self.stepper_low_weekends.value = data.weekends_min
                self.stepper_high_weekends.value = data.weekends_max
                self.updateLabels()
            }
        case "Exercise Minutes":
            if let data = currentuser.userNormalRange?.exerciseMinutes {
                if data.isManual {
                    switch_manual.isOn = true
                    self.InfoIsHidden(false)
                } else {
                    switch_manual.isOn = false
                    self.InfoIsHidden(true)
                }
                self.places = 0
                self.unit = "mins"
                self.updateSteppers(min: 0, max: 300, step: 10)
                self.stepper_low_weekdays.value = data.weekdays_min
                self.stepper_high_weekdays.value = data.weekdays_max
                self.stepper_low_weekends.value = data.weekends_min
                self.stepper_high_weekends.value = data.weekends_max
                self.updateLabels()
            }
        case "Stand Minutes":
            if let data = currentuser.userNormalRange?.standMinutes {
                if data.isManual {
                    switch_manual.isOn = true
                    self.InfoIsHidden(false)
                } else {
                    switch_manual.isOn = false
                    self.InfoIsHidden(true)
                }
                self.places = 0
                self.unit = "mins"
                self.updateSteppers(min: 0, max: 1000, step: 10)
                self.stepper_low_weekdays.value = data.weekdays_min
                self.stepper_high_weekdays.value = data.weekdays_max
                self.stepper_low_weekends.value = data.weekends_min
                self.stepper_high_weekends.value = data.weekends_max
                self.updateLabels()
            }
        case "Steps":
            if let data = currentuser.userNormalRange?.steps {
                if data.isManual {
                    switch_manual.isOn = true
                    self.InfoIsHidden(false)
                } else {
                    switch_manual.isOn = false
                    self.InfoIsHidden(true)
                }
                self.places = 0
                self.unit = "steps"
                self.updateSteppers(min: 0, max: 100000, step: 500)
                self.stepper_low_weekdays.value = data.weekdays_min
                self.stepper_high_weekdays.value = data.weekdays_max
                self.stepper_low_weekends.value = data.weekends_min
                self.stepper_high_weekends.value = data.weekends_max
                self.updateLabels()
            }
        case "Walking & Running Distance":
            if let data = currentuser.userNormalRange?.walkingRunningDistance {
                if data.isManual {
                    switch_manual.isOn = true
                    self.InfoIsHidden(false)
                } else {
                    switch_manual.isOn = false
                    self.InfoIsHidden(true)
                }
                self.places = 2
                self.unit = "m"
                self.updateSteppers(min: 0, max: 100000, step: 250)
                self.stepper_low_weekdays.value = data.weekdays_min
                self.stepper_high_weekdays.value = data.weekdays_max
                self.stepper_low_weekends.value = data.weekends_min
                self.stepper_high_weekends.value = data.weekends_max
                self.updateLabels()
            }
        case "Heart Rate":
            if let data = currentuser.userNormalRange?.heartRate {
                if data.isManual {
                    switch_manual.isOn = true
                    self.InfoIsHidden(false)
                } else {
                    switch_manual.isOn = false
                    self.InfoIsHidden(true)
                }
                self.places = 0
                self.unit = "count/min"
                self.updateSteppers(min: 0, max: 200, step: 5)
                self.stepper_low_weekdays.value = data.weekdays_min
                self.stepper_high_weekdays.value = data.weekdays_max
                self.stepper_low_weekends.value = data.weekends_min
                self.stepper_high_weekends.value = data.weekends_max
                self.updateLabels()
            }
        case "Resting Heart Rate":
            if let data = currentuser.userNormalRange?.restingHeartRate {
                if data.isManual {
                    switch_manual.isOn = true
                    self.InfoIsHidden(false)
                } else {
                    switch_manual.isOn = false
                    self.InfoIsHidden(true)
                }
                self.places = 0
                self.unit = "count/min"
                self.updateSteppers(min: 0, max: 200, step: 5)
                self.stepper_low_weekdays.value = data.weekdays_min
                self.stepper_high_weekdays.value = data.weekdays_max
                self.stepper_low_weekends.value = data.weekends_min
                self.stepper_high_weekends.value = data.weekends_max
                self.updateLabels()
            }
        case "Blood Oxygen":
            if let data = currentuser.userNormalRange?.bloodOxygen {
                if data.isManual {
                    switch_manual.isOn = true
                    self.InfoIsHidden(false)
                } else {
                    switch_manual.isOn = false
                    self.InfoIsHidden(true)
                }
                self.places = 0
                self.unit = "%"
                self.updateSteppers(min: 0, max: 100, step: 1)
                self.stepper_low_weekdays.value = data.weekdays_min
                self.stepper_high_weekdays.value = data.weekdays_max
                self.stepper_low_weekends.value = data.weekends_min
                self.stepper_high_weekends.value = data.weekends_max
                self.updateLabels()
            }
        case "Mindful Minutes":
            if let data = currentuser.userNormalRange?.mindfulMinutes {
                if data.isManual {
                    switch_manual.isOn = true
                    self.InfoIsHidden(false)
                } else {
                    switch_manual.isOn = false
                    self.InfoIsHidden(true)
                }
                self.places = 0
                self.unit = "mins"
                self.updateSteppers(min: 0, max: 300, step: 5)
                self.stepper_low_weekdays.value = data.weekdays_min
                self.stepper_high_weekdays.value = data.weekdays_max
                self.stepper_low_weekends.value = data.weekends_min
                self.stepper_high_weekends.value = data.weekends_max
                self.updateLabels()
            }
        case "Sleep Hours":
            if let data = currentuser.userNormalRange?.sleepHours {
                if data.isManual {
                    switch_manual.isOn = true
                    self.InfoIsHidden(false)
                } else {
                    switch_manual.isOn = false
                    self.InfoIsHidden(true)
                }
                self.places = 2
                self.unit = "hours"
                self.updateSteppers(min: 0, max: 15, step: 0.5)
                self.stepper_low_weekdays.value = data.weekdays_min
                self.stepper_high_weekdays.value = data.weekdays_max
                self.stepper_low_weekends.value = data.weekends_min
                self.stepper_high_weekends.value = data.weekends_max
                self.updateLabels()
            }
        default:
            print("ERROR: Invalid Data Type")
        }
    }
    
    private func InfoIsHidden(_ isHidden: Bool) {
        self.lb_weekdays.isHidden = isHidden
        self.lb_range_weekdays.isHidden = isHidden
        self.stepper_low_weekdays.isHidden = isHidden
        self.stepper_high_weekdays.isHidden = isHidden
        self.lb_weekends.isHidden = isHidden
        self.lb_range_weekends.isHidden = isHidden
        self.stepper_low_weekends.isHidden = isHidden
        self.stepper_high_weekends.isHidden = isHidden
        self.lb_weekdays.text = "Weekdays"
        if self.title == "Heart Rate" || self.title == "Resting Heart Rate" || self.title == "Blood Oxygen" {
            self.lb_weekdays.text = ""
            self.lb_weekends.isHidden = true
            self.lb_range_weekends.isHidden = true
            self.stepper_low_weekends.isHidden = true
            self.stepper_high_weekends.isHidden = true
        }
    }
    
    private func updateSteppers(min: Double, max: Double, step: Double) {
        for stepper in [stepper_low_weekdays, stepper_high_weekdays, stepper_low_weekends, stepper_high_weekends] {
            stepper!.minimumValue = min
            stepper!.maximumValue = max
            stepper!.stepValue = step
        }
    }
    
    private func updateLabels() {
        if places != 0 {
            self.lb_range_weekdays.text = "\(self.stepper_low_weekdays.value.rounded(toPlaces: places)) - \(self.stepper_high_weekdays.value.rounded(toPlaces: places)) \(unit)"
            self.lb_range_weekends.text = "\(self.stepper_low_weekends.value.rounded(toPlaces: places)) - \(self.stepper_high_weekends.value.rounded(toPlaces: places)) \(unit)"
        } else {
            self.lb_range_weekdays.text = "\(Int(self.stepper_low_weekdays.value)) - \(Int(self.stepper_high_weekdays.value)) \(unit)"
            self.lb_range_weekends.text = "\(Int(self.stepper_low_weekends.value)) - \(Int(self.stepper_high_weekends.value)) \(unit)"
        }
    }
    
    
    private func saveData() {
        
        let realm = try! Realm()
        try! realm.safeWrite {
            switch self.title {
            case "Active Energy":
                if let data = currentuser.userNormalRange?.activeEnergy {
                    data.isManual = self.switch_manual.isOn
                    if data.isManual {
                        data.weekdays_min = self.stepper_low_weekdays.value
                        data.weekdays_max = self.stepper_high_weekdays.value
                        data.weekends_min = self.stepper_low_weekends.value
                        data.weekends_max = self.stepper_high_weekends.value
                    } else {
                        calculateAverage_ActiveEnergyHealthData()
                    }
                }
            case "Exercise Minutes":
                if let data = currentuser.userNormalRange?.exerciseMinutes {
                    data.isManual = self.switch_manual.isOn
                    if data.isManual {
                        data.weekdays_min = self.stepper_low_weekdays.value
                        data.weekdays_max = self.stepper_high_weekdays.value
                        data.weekends_min = self.stepper_low_weekends.value
                        data.weekends_max = self.stepper_high_weekends.value
                    } else {
                        calculateAverage_ExerciseMinutesHealthData()
                    }
                }
            case "Stand Minutes":
                if let data = currentuser.userNormalRange?.standMinutes {
                    data.isManual = self.switch_manual.isOn
                    if data.isManual {
                        data.weekdays_min = self.stepper_low_weekdays.value
                        data.weekdays_max = self.stepper_high_weekdays.value
                        data.weekends_min = self.stepper_low_weekends.value
                        data.weekends_max = self.stepper_high_weekends.value
                    } else {
                        calculateAverage_StandMinutesHealthData()
                    }
                }
            case "Steps":
                if let data = currentuser.userNormalRange?.steps {
                    data.isManual = self.switch_manual.isOn
                    if data.isManual {
                        data.weekdays_min = self.stepper_low_weekdays.value
                        data.weekdays_max = self.stepper_high_weekdays.value
                        data.weekends_min = self.stepper_low_weekends.value
                        data.weekends_max = self.stepper_high_weekends.value
                    } else {
                        calculateAverage_StepsHealthData()
                    }
                }
            case "Walking & Running Distance":
                if let data = currentuser.userNormalRange?.walkingRunningDistance {
                    data.isManual = self.switch_manual.isOn
                    if data.isManual {
                        data.weekdays_min = self.stepper_low_weekdays.value
                        data.weekdays_max = self.stepper_high_weekdays.value
                        data.weekends_min = self.stepper_low_weekends.value
                        data.weekends_max = self.stepper_high_weekends.value
                    } else {
                        calculateAverage_WalkingRunningDistanceHealthData()
                    }
                }
            case "Heart Rate":
                if let data = currentuser.userNormalRange?.heartRate {
                    data.isManual = self.switch_manual.isOn
                    if data.isManual {
                        data.weekdays_min = self.stepper_low_weekdays.value
                        data.weekdays_max = self.stepper_high_weekdays.value
                        data.weekends_min = self.stepper_low_weekends.value
                        data.weekends_max = self.stepper_high_weekends.value
                    } else {
                        calculateAverage_HeartRateHealthData()
                    }
                }
            case "Resting Heart Rate":
                if let data = currentuser.userNormalRange?.restingHeartRate {
                    data.isManual = self.switch_manual.isOn
                    if data.isManual {
                        data.weekdays_min = self.stepper_low_weekdays.value
                        data.weekdays_max = self.stepper_high_weekdays.value
                        data.weekends_min = self.stepper_low_weekends.value
                        data.weekends_max = self.stepper_high_weekends.value
                    } else {
                        calculateAverage_RestingHeartRateHealthData()
                    }
                }
            case "Blood Oxygen":
                if let data = currentuser.userNormalRange?.bloodOxygen {
                    data.isManual = self.switch_manual.isOn
                    if data.isManual {
                        data.weekdays_min = self.stepper_low_weekdays.value
                        data.weekdays_max = self.stepper_high_weekdays.value
                        data.weekends_min = self.stepper_low_weekends.value
                        data.weekends_max = self.stepper_high_weekends.value
                    } else {
                        calculateAverage_RespiratoryHealthData()
                    }
                }
            case "Mindful Minutes":
                if let data = currentuser.userNormalRange?.mindfulMinutes {
                    data.isManual = self.switch_manual.isOn
                    if data.isManual {
                        data.weekdays_min = self.stepper_low_weekdays.value
                        data.weekdays_max = self.stepper_high_weekdays.value
                        data.weekends_min = self.stepper_low_weekends.value
                        data.weekends_max = self.stepper_high_weekends.value
                    } else {
                        calculateAverage_MindfulnessHealthData()
                    }
                }
            case "Sleep Hours":
                if let data = currentuser.userNormalRange?.sleepHours {
                    data.isManual = self.switch_manual.isOn
                    if data.isManual {
                        data.weekdays_min = self.stepper_low_weekdays.value
                        data.weekdays_max = self.stepper_high_weekdays.value
                        data.weekends_min = self.stepper_low_weekends.value
                        data.weekends_max = self.stepper_high_weekends.value
                    } else {
                        calculateAverage_SleepHealthData()
                    }
                }
            default:
                print("ERROR: Invalid Data Type")
            }
        }
    }
}
