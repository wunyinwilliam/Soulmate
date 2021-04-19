//
//  S3_SettingsMoreDetailsViewController.swift
//  Soulmate
//
//  Created by Will Lam on 12/3/2021.
//

import UIKit
import RealmSwift
import MaterialComponents

class S3_SettingsMoreDetailsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    // MARK: - Variables
    
    @IBOutlet weak var lb_weekdays: UILabel!
    @IBOutlet weak var lb_range_weekdays: UILabel!
    @IBOutlet weak var stepper_low_weekdays: UIStepper!
    @IBOutlet weak var stepper_high_weekdays: UIStepper!
    
    @IBOutlet weak var lb_weekends: UILabel!
    @IBOutlet weak var lb_range_weekends: UILabel!
    @IBOutlet weak var stepper_low_weekends: UIStepper!
    @IBOutlet weak var stepper_high_weekends: UIStepper!
    
    @IBOutlet weak var lb_setManual: UILabel!
    @IBOutlet weak var switch_manual: UISwitch!
    @IBOutlet weak var bn_save: UIBarButtonItem!
    
    var places: Int = 0
    var unit: String = ""
    
    let bn_hour = MDCButton()
    let bn_day = MDCButton()
    let bn_week = MDCButton()
    let lb_notification_frequency = UILabel()
    let datePicker_notification_frequency = UIDatePicker()
    let pickerView_notification_frequency = UIPickerView()
    
    let minutesList = Array(0...59)
    let hoursList = Array(0...23)
    let weekdaysList = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    let stressLevelList = Array(0...10)
    var showing = -1
    var dataFromPickerView = ""

    
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
        case "Asking Stress Level":
            self.hideAllViews()
            self.setUpNotificationViews()
        case "Encouraging Quotes":
            self.hideAllViews()
            self.setUpNotificationViews()
        case "Stress Reminders":
            self.hideAllViews()
            self.setUpStressRemindersViews()
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
            case "Asking Stress Level":
                let tempClass = StressLevel_Notifications()
                switch showing {
                case 0:
                    tempClass.sendAskingStressLevelNotifications(min: Int(dataFromPickerView), hour: nil, weekday: nil)
                case 1:
                    tempClass.sendAskingStressLevelNotifications(min: nil, hour: Int(dataFromPickerView), weekday: nil)
                default:
                    tempClass.sendAskingStressLevelNotifications(min: nil, hour: nil, weekday: weekdaysList.firstIndex(of: dataFromPickerView))
                }
                self.view.makeToast("Change Frequency Successfully", duration: 1.0, position: .bottom)
            case "Encouraging Quotes":
                let tempClass = StressLevel_Notifications()
                switch showing {
                case 0:
                    tempClass.sendEncouragingQuoteNotifications(min: Int(dataFromPickerView), hour: nil, weekday: nil)
                case 1:
                    tempClass.sendEncouragingQuoteNotifications(min: nil, hour: Int(dataFromPickerView), weekday: nil)
                default:
                    tempClass.sendEncouragingQuoteNotifications(min: nil, hour: nil, weekday: weekdaysList.firstIndex(of: dataFromPickerView))
                }
                self.view.makeToast("Change Frequency Successfully", duration: 1.0, position: .bottom)
            case "Stress Reminders":
                let tempClass = StressLevel_Notifications()
                stressReminder_Notifications_StressLevel = Int(dataFromPickerView)!
                tempClass.sendStressReminderNotifications(stressLevel: stressReminder_Notifications_StressLevel)
                self.view.makeToast("Change Frequency Successfully", duration: 1.0, position: .bottom)
            default:
                print("ERROR: Invalid Data Type")
            }
        }
    }
    
    private func hideAllViews() {
        self.lb_weekdays.isHidden = true
        self.lb_range_weekdays.isHidden = true
        self.stepper_low_weekdays.isHidden = true
        self.stepper_high_weekdays.isHidden = true
        
        self.lb_weekends.isHidden = true
        self.lb_range_weekends.isHidden = true
        self.stepper_low_weekends.isHidden = true
        self.stepper_high_weekends.isHidden = true
        
        self.lb_setManual.isHidden = true
        self.switch_manual.isHidden = true
    }
    
    private func setUpNotificationViews() {
        self.bn_hour.frame = CGRect(x: 60.0, y: 150.0, width: 255.0, height: 50.0)
        self.bn_hour.center.x = self.view.center.x
        self.bn_hour.setTitle("Send Every Hour", for: .normal)
        self.bn_hour.applyContainedTheme(withScheme: globalContainerScheme())
        self.bn_hour.addTarget(self, action: #selector(pressed_bn_hour), for: .touchUpInside)
        self.view.addSubview(bn_hour)
        
        self.bn_day.frame = CGRect(x: 60.0, y: 210.0, width: 255.0, height: 50.0)
        self.bn_day.center.x = self.view.center.x
        self.bn_day.setTitle("Send Every Day", for: .normal)
        self.bn_day.applyContainedTheme(withScheme: globalContainerScheme())
        self.bn_day.addTarget(self, action: #selector(pressed_bn_day), for: .touchUpInside)
        self.view.addSubview(bn_day)
        
        self.bn_week.frame = CGRect(x: 60.0, y: 270.0, width: 255.0, height: 50.0)
        self.bn_week.center.x = self.view.center.x
        self.bn_week.setTitle("Send Every Week", for: .normal)
        self.bn_week.applyContainedTheme(withScheme: globalContainerScheme())
        self.bn_week.addTarget(self, action: #selector(pressed_bn_week), for: .touchUpInside)
        self.view.addSubview(bn_week)
        
        self.lb_notification_frequency.frame = CGRect(x: 60.0, y: 350.0, width: 255.0, height: 50.0)
        self.lb_notification_frequency.center.x = self.view.center.x
        self.lb_notification_frequency.textAlignment = .center
        self.view.addSubview(lb_notification_frequency)
        self.lb_notification_frequency.isHidden = true
                
        self.pickerView_notification_frequency.frame = CGRect(x: 0.0, y: 375.0, width: 320.0, height: 250.0)
        self.pickerView_notification_frequency.center.x = self.view.center.x
        self.pickerView_notification_frequency.delegate = self
        self.pickerView_notification_frequency.dataSource = self
        self.view.addSubview(pickerView_notification_frequency)
        self.pickerView_notification_frequency.isHidden = true
    }
        
    @objc func pressed_bn_hour(_ sender: UIButton) -> Void {
        self.showing = 0
        self.pickerView_notification_frequency.reloadAllComponents()
        self.lb_notification_frequency.isHidden = false
        self.pickerView_notification_frequency.isHidden = false
        self.lb_notification_frequency.text = "Send in which minute?"
    }
    
    @objc func pressed_bn_day(_ sender: UIButton) -> Void {
        self.showing = 1
        self.pickerView_notification_frequency.reloadAllComponents()
        self.lb_notification_frequency.isHidden = false
        self.pickerView_notification_frequency.isHidden = false
        self.lb_notification_frequency.text = "Send in which hour?"
        
    }
    
    @objc func pressed_bn_week(_ sender: UIButton) -> Void {
        self.showing = 2
        self.pickerView_notification_frequency.reloadAllComponents()
        self.lb_notification_frequency.isHidden = false
        self.pickerView_notification_frequency.isHidden = false
        self.lb_notification_frequency.text = "Send in which day?"
    }
    
    private func setUpStressRemindersViews() {
        self.lb_notification_frequency.frame = CGRect(x: 60.0, y: 150.0, width: 255.0, height: 50.0)
        self.lb_notification_frequency.center.x = self.view.center.x
        self.lb_notification_frequency.textAlignment = .center
        self.lb_notification_frequency.text = "When exceed which stress level, send notifications?"
        self.lb_notification_frequency.numberOfLines = 0
        self.view.addSubview(lb_notification_frequency)
        self.lb_notification_frequency.isHidden = false
        
        self.pickerView_notification_frequency.frame = CGRect(x: 0.0, y: 175.0, width: 320.0, height: 250.0)
        self.pickerView_notification_frequency.center.x = self.view.center.x
        self.pickerView_notification_frequency.delegate = self
        self.pickerView_notification_frequency.dataSource = self
        self.pickerView_notification_frequency.selectRow(7, inComponent: 0, animated: false)
        self.view.addSubview(pickerView_notification_frequency)
        self.pickerView_notification_frequency.isHidden = false
    }
    
    
    // MARK: UIPickerViewDelegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.title == "Stress Reminders" {
            return stressLevelList.count
        } else {
            switch self.showing {
            case 0:
                return minutesList.count
            case 1:
                return hoursList.count
            default:
                return weekdaysList.count
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.title == "Stress Reminders" {
            return String(stressLevelList[row])
        } else {
            switch self.showing {
            case 0:
                return String(minutesList[row])
            case 1:
                return String(hoursList[row])
            default:
                return weekdaysList[row]
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.title == "Stress Reminders" {
            dataFromPickerView = String(stressLevelList[row])
        } else {
            switch self.showing {
            case 0:
                dataFromPickerView = String(minutesList[row])
            case 1:
                dataFromPickerView = String(hoursList[row])
            default:
                dataFromPickerView = weekdaysList[row]
            }
        }
    }

}
