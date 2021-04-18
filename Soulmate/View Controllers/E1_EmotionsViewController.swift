//
//  E1_EmotionsViewController.swift
//  Soulmate
//
//  Created by Will Lam on 2/3/2021.
//

import UIKit
import RealmSwift
import HealthKit
import Kommunicate


class E1_EmotionsViewController: UIViewController {

    // MARK: - Variables
    
    @IBOutlet weak var view_heartRate: UIView!
    @IBOutlet weak var heartRate_leftOval: UIImageView!
    @IBOutlet weak var heartRate_middleOval: UIImageView!
    @IBOutlet weak var heartRate_rightOval: UIImageView!
    @IBOutlet weak var lb_heartRate: UILabel!
    
    @IBOutlet weak var view_activity: UIView!
    @IBOutlet weak var activity_leftOval: UIImageView!
    @IBOutlet weak var activity_middleOval: UIImageView!
    @IBOutlet weak var activity_rightOval: UIImageView!
    @IBOutlet weak var lb_activity: UILabel!
    
    @IBOutlet weak var view_mindfulTime: UIView!
    @IBOutlet weak var mindfulTime_leftOval: UIImageView!
    @IBOutlet weak var mindfulTime_middleOval: UIImageView!
    @IBOutlet weak var mindfulTime_rightOval: UIImageView!
    @IBOutlet weak var lb_mindfulTime: UILabel!
    
    @IBOutlet weak var view_sleepTime: UIView!
    @IBOutlet weak var sleepTime_leftOval: UIImageView!
    @IBOutlet weak var sleepTime_middleOval: UIImageView!
    @IBOutlet weak var sleepTime_rightOval: UIImageView!
    @IBOutlet weak var lb_sleepTime: UILabel!
    
    @IBOutlet weak var lb_stressLevelIndex: UILabel!
    
    @IBOutlet weak var view_AIChatbot: UIView!
    @IBOutlet weak var view_QuestionBank: UIView!
    
    var stressLevelIndex: Int = 5
    var tapView: Int = -1
    
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "EMOTIONS"
        navigationController?.title = "Emotions"
        
        self.setupLoadingIndicator()
        self.setupUserIconButton()
        self.setupUI()
        self.setupRefreshButton()
        self.setupAIChatbot()
        self.addGestureRecognizer()
        
        self.updateViewsAndIndex()
    }
    
    
    // MARK: - Private Functions
    
    private func setupUserIconButton() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "S1Nav") as! UINavigationController
        let userIconButton = UIButton(primaryAction: UIAction(title: "", handler: { _ in
            self.present(vc, animated: true, completion: nil)
        }))
        userIconButton.setBackgroundImage(UIImage(named: "Person"), for: .normal)
        
        let segmentBarItem = UIBarButtonItem(customView: userIconButton)
        // Add constraints to the bar buttion item
        let currWidth = segmentBarItem.customView?.widthAnchor.constraint(equalToConstant: 40)
        currWidth?.isActive = true
        let currHeight = segmentBarItem.customView?.heightAnchor.constraint(equalToConstant: 40)
        currHeight?.isActive = true
        navigationItem.rightBarButtonItem = segmentBarItem
    }
    
    
    private func setupUI() {
        self.view.backgroundColor = UIColor(hex: "#FAEDEBFF")
        
        let lb_logo_soulmate = UILabel()
        lb_logo_soulmate.text = "Soulmate"
        lb_logo_soulmate.font = UIFont(name: "American Typewriter Bold", size: 18.0)
        lb_logo_soulmate.textAlignment = .center
        lb_logo_soulmate.textColor = UIColor(hex: "#FF9587FF")
        lb_logo_soulmate.frame = CGRect(x: 10.0, y: 20.0, width: 100.0, height: 50.0)
        lb_logo_soulmate.center.x = self.view.center.x
        self.view.addSubview(lb_logo_soulmate)
        
        for view in [view_heartRate, view_activity, view_mindfulTime, view_sleepTime, view_AIChatbot, view_QuestionBank] {
            view?.layer.borderWidth = 1.0
            view?.layer.borderColor = UIColor.systemPink.cgColor
            view?.layer.cornerRadius = 5.0
        }
    }
    
    
    private func setupRefreshButton() {
        let refreshButton = UIButton(primaryAction: UIAction(title: "", handler: { [self] _ in
            self.reloadHealthData()
        }))
        refreshButton.setBackgroundImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        
        let segmentBarItem = UIBarButtonItem(customView: refreshButton)
        // Add constraints to the bar buttion item
        let currWidth = segmentBarItem.customView?.widthAnchor.constraint(equalToConstant: 25)
        currWidth?.isActive = true
        let currHeight = segmentBarItem.customView?.heightAnchor.constraint(equalToConstant: 25)
        currHeight?.isActive = true
        navigationItem.leftBarButtonItem = segmentBarItem
    }
    
    
    private func reloadHealthData() {
        extractAllHealthData()
        calculateAverage_AllHealthData()
        self.loadingIndicator.isAnimating = true
        self.view.isUserInteractionEnabled = false
        self.view.mask = UIView(frame: self.view.frame)
        self.view.mask?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.updateViewsAndIndex()
            self.loadingIndicator.isAnimating = false
            self.view.isUserInteractionEnabled = true
            self.view.mask = nil
        }
    }
    
    
    private func addGestureRecognizer() {
        let tap_heartRate = UILongPressGestureRecognizer(target: self, action: #selector(self.didTapView_heartRate(_:)))
        tap_heartRate.minimumPressDuration = 0.01
        self.view_heartRate.addGestureRecognizer(tap_heartRate)
        
        let tap_activity = UILongPressGestureRecognizer(target: self, action: #selector(self.didTapView_activity(_:)))
        tap_activity.minimumPressDuration = 0.01
        self.view_activity.addGestureRecognizer(tap_activity)
        
        let tap_mindfulTime = UILongPressGestureRecognizer(target: self, action: #selector(self.didTapView_mindfulTime(_:)))
        tap_mindfulTime.minimumPressDuration = 0.01
        self.view_mindfulTime.addGestureRecognizer(tap_mindfulTime)
        
        let tap_sleepTime = UILongPressGestureRecognizer(target: self, action: #selector(self.didTapView_sleepTime(_:)))
        tap_sleepTime.minimumPressDuration = 0.01
        self.view_sleepTime.addGestureRecognizer(tap_sleepTime)
        
        let tap_AIChatbot = UILongPressGestureRecognizer(target: self, action: #selector(self.didTapView_AIChatbot(_:)))
        tap_AIChatbot.minimumPressDuration = 0.01
        self.view_AIChatbot.addGestureRecognizer(tap_AIChatbot)
        
        let tap_QuestionBank = UILongPressGestureRecognizer(target: self, action: #selector(self.didTapView_QuestionBank(_:)))
        tap_QuestionBank.minimumPressDuration = 0.01
        self.view_QuestionBank.addGestureRecognizer(tap_QuestionBank)
    }
    
    @objc func didTapView_heartRate(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            sender.view?.backgroundColor = UIColor(hex: "#FFB5A7FF")
        } else if sender.state == .ended {
            self.tapView = 0
            self.performSegue(withIdentifier: "E1ToE3Segue", sender: self)
            sender.view?.backgroundColor = UIColor(hex: "#FCD5CEFF")
        }
    }
    
    @objc func didTapView_activity(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            sender.view?.backgroundColor = UIColor(hex: "#FFB5A7FF")
        } else if sender.state == .ended {
            self.tapView = 1
            self.performSegue(withIdentifier: "E1ToE3Segue", sender: self)
            sender.view?.backgroundColor = UIColor(hex: "#FCD5CEFF")
        }
    }
    
    @objc func didTapView_mindfulTime(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            sender.view?.backgroundColor = UIColor(hex: "#FFB5A7FF")
        } else if sender.state == .ended {
            self.tapView = 2
            self.performSegue(withIdentifier: "E1ToE3Segue", sender: self)
            sender.view?.backgroundColor = UIColor(hex: "#FCD5CEFF")
        }
    }
    
    @objc func didTapView_sleepTime(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            sender.view?.backgroundColor = UIColor(hex: "#FFB5A7FF")
        } else if sender.state == .ended {
            self.tapView = 3
            self.performSegue(withIdentifier: "E1ToE3Segue", sender: self)
            sender.view?.backgroundColor = UIColor(hex: "#FCD5CEFF")
        }
    }
    
    @objc func didTapView_AIChatbot(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            sender.view?.backgroundColor = UIColor(hex: "#FFB5A7FF")
        } else if sender.state == .ended {
            self.openChatbotView()
            self.loadingIndicator.isAnimating = true
            self.view.isUserInteractionEnabled = false
            self.view.mask = UIView(frame: self.view.frame)
            self.view.mask?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.loadingIndicator.isAnimating = false
                self.view.isUserInteractionEnabled = true
                self.view.mask = nil
            }
            sender.view?.backgroundColor = UIColor(hex: "#FCD5CEFF")
        }
    }
    
    @objc func didTapView_QuestionBank(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            sender.view?.backgroundColor = UIColor(hex: "#FFB5A7FF")
        } else if sender.state == .ended {
            sender.view?.backgroundColor = UIColor(hex: "#FCD5CEFF")
        }
    }
    
    
    // MARK: - readLatestData
    
    private func updateHeartRateView() -> Double {
        if let firstRecord = userHealthProfile.heartRate.first {
            let heartRateInBPM = firstRecord.quantity.doubleValue(for: HKUnit(from: "count/min"))
            if heartRateInBPM < currentuser.userNormalRange?.heartRate?.weekdays_min ?? 0.0 {
                self.heartRate_leftOval.image = UIImage(named: "Gray Oval")
                self.heartRate_middleOval.image = UIImage(named: "Gray Oval")
                self.heartRate_rightOval.image = UIImage(named: "Green Oval")
                self.lb_heartRate.text = "GOOD"
                self.lb_heartRate.textColor = .systemGreen
                self.stressLevelIndex -= 1
            } else if heartRateInBPM > currentuser.userNormalRange?.heartRate?.weekdays_max ?? 0.0 {
                self.heartRate_leftOval.image = UIImage(named: "Red Oval")
                self.heartRate_middleOval.image = UIImage(named: "Gray Oval")
                self.heartRate_rightOval.image = UIImage(named: "Gray Oval")
                self.lb_heartRate.text = "POOR"
                self.lb_heartRate.textColor = .red
                self.stressLevelIndex += 1
            } else {
                self.heartRate_leftOval.image = UIImage(named: "Gray Oval")
                self.heartRate_middleOval.image = UIImage(named: "Orange Oval")
                self.heartRate_rightOval.image = UIImage(named: "Gray Oval")
                self.lb_heartRate.text = "NORMAL"
                self.lb_heartRate.textColor = .orange
            }
            return heartRateInBPM
        }
        return 0.0
    }
    
    
    private func updateActivityView() -> Double {
        if let firstRecord = userHealthProfile.activeEnergy.first {
            if let sum = firstRecord.sumQuantity() {
                let energyInKcal = sum.doubleValue(for: .kilocalorie())
                
                var activeEnergy_min: Double = 200.0
                var activeEnergy_max: Double = 1000.0
                if Calendar.current.isDateInWeekend(firstRecord.startDate) {
                    activeEnergy_min = currentuser.userNormalRange?.activeEnergy?.weekends_min ?? 0.0
                    activeEnergy_max = currentuser.userNormalRange?.activeEnergy?.weekends_max ?? 0.0
                } else {
                    activeEnergy_min = currentuser.userNormalRange?.activeEnergy?.weekdays_min ?? 0.0
                    activeEnergy_max = currentuser.userNormalRange?.activeEnergy?.weekdays_max ?? 0.0
                }
                
                if energyInKcal < activeEnergy_min {
                    self.activity_leftOval.image = UIImage(named: "Red Oval")
                    self.activity_middleOval.image = UIImage(named: "Gray Oval")
                    self.activity_rightOval.image = UIImage(named: "Gray Oval")
                    self.lb_activity.text = "POOR"
                    self.lb_activity.textColor = .red
                    self.stressLevelIndex += 1
                } else if energyInKcal > activeEnergy_max {
                    self.activity_leftOval.image = UIImage(named: "Gray Oval")
                    self.activity_middleOval.image = UIImage(named: "Gray Oval")
                    self.activity_rightOval.image = UIImage(named: "Green Oval")
                    self.lb_activity.text = "GOOD"
                    self.lb_activity.textColor = .systemGreen
                    self.stressLevelIndex -= 1
                } else {
                    self.activity_leftOval.image = UIImage(named: "Gray Oval")
                    self.activity_middleOval.image = UIImage(named: "Orange Oval")
                    self.activity_rightOval.image = UIImage(named: "Gray Oval")
                    self.lb_activity.text = "NORMAL"
                    self.lb_activity.textColor = .orange
                }
                return energyInKcal
            }
        }
        return 0.0
    }
    
    
    private func updateMindfulTimeView() -> Double {
        if userHealthProfile.mindfulMinutes.count > 10 {
            var mindfulMinutes: Double = 0
            for record in userHealthProfile.mindfulMinutes.prefix(10) {
                if Calendar.current.startOfDay(for: record.endDate) == Calendar.current.startOfDay(for: Date()) {
                    mindfulMinutes += record.endDate.timeIntervalSince(record.startDate)/60
                }
            }
            var mindfulMinutes_min: Double = 0
            var mindfulMinutes_max: Double = 180
            if Calendar.current.isDateInWeekend(userHealthProfile.mindfulMinutes.first!.startDate) {
                mindfulMinutes_min = currentuser.userNormalRange?.mindfulMinutes?.weekends_min ?? 0.0
                mindfulMinutes_max = currentuser.userNormalRange?.mindfulMinutes?.weekends_max ?? 0.0
            } else {
                mindfulMinutes_min = currentuser.userNormalRange?.mindfulMinutes?.weekdays_min ?? 0.0
                mindfulMinutes_max = currentuser.userNormalRange?.mindfulMinutes?.weekdays_max ?? 0.0
            }
            if mindfulMinutes < mindfulMinutes_min {
                self.mindfulTime_leftOval.image = UIImage(named: "Red Oval")
                self.mindfulTime_middleOval.image = UIImage(named: "Gray Oval")
                self.mindfulTime_rightOval.image = UIImage(named: "Gray Oval")
                self.lb_mindfulTime.text = "POOR"
                self.lb_mindfulTime.textColor = .red
                self.stressLevelIndex += 1
            } else if mindfulMinutes > mindfulMinutes_max {
                self.mindfulTime_leftOval.image = UIImage(named: "Gray Oval")
                self.mindfulTime_middleOval.image = UIImage(named: "Gray Oval")
                self.mindfulTime_rightOval.image = UIImage(named: "Green Oval")
                self.lb_mindfulTime.text = "GOOD"
                self.lb_mindfulTime.textColor = .systemGreen
                self.stressLevelIndex -= 1
            } else {
                self.mindfulTime_leftOval.image = UIImage(named: "Gray Oval")
                self.mindfulTime_middleOval.image = UIImage(named: "Orange Oval")
                self.mindfulTime_rightOval.image = UIImage(named: "Gray Oval")
                self.lb_mindfulTime.text = "NORMAL"
                self.lb_mindfulTime.textColor = .orange
            }
            return mindfulMinutes
        }
        return 0.0
    }
    
    
    private func updateSleepTimeView() -> Double {
        if userHealthProfile.sleepHours.count > 10 {
            var sleepHours: Double = 0.0
            for record in userHealthProfile.sleepHours.prefix(10) {
                if Calendar.current.startOfDay(for: record.endDate) == Calendar.current.startOfDay(for: Date()) {
                    sleepHours += Double(record.endDate.timeIntervalSince(record.startDate)/3600)
                }
            }
            var sleepHours_min: Double = 4.0
            var sleepHours_max: Double = 10.0
            if Calendar.current.isDateInWeekend(userHealthProfile.sleepHours.first!.startDate) {
                sleepHours_min = currentuser.userNormalRange?.sleepHours?.weekends_min ?? 0.0
                sleepHours_max = currentuser.userNormalRange?.sleepHours?.weekends_max ?? 0.0
            } else {
                sleepHours_min = currentuser.userNormalRange?.sleepHours?.weekdays_min ?? 0.0
                sleepHours_max = currentuser.userNormalRange?.sleepHours?.weekdays_max ?? 0.0
            }
            if sleepHours < sleepHours_min {
                self.sleepTime_leftOval.image = UIImage(named: "Red Oval")
                self.sleepTime_middleOval.image = UIImage(named: "Gray Oval")
                self.sleepTime_rightOval.image = UIImage(named: "Gray Oval")
                self.lb_sleepTime.text = "POOR"
                self.lb_sleepTime.textColor = .red
                self.stressLevelIndex += 1
            } else if sleepHours > sleepHours_max {
                self.sleepTime_leftOval.image = UIImage(named: "Gray Oval")
                self.sleepTime_middleOval.image = UIImage(named: "Gray Oval")
                self.sleepTime_rightOval.image = UIImage(named: "Green Oval")
                self.lb_sleepTime.text = "GOOD"
                self.lb_sleepTime.textColor = .systemGreen
                self.stressLevelIndex -= 1
            } else {
                self.sleepTime_leftOval.image = UIImage(named: "Gray Oval")
                self.sleepTime_middleOval.image = UIImage(named: "Orange Oval")
                self.sleepTime_rightOval.image = UIImage(named: "Gray Oval")
                self.lb_sleepTime.text = "NORMAL"
                self.lb_sleepTime.textColor = .orange
            }
            return sleepHours
        }
        return 0.0
    }
    
    
    private func updateStressIndex() {
        self.lb_stressLevelIndex.text = "Estimated Stress Level Index: \(stressLevelIndex)"
    }
    
    
    private func updateViewsAndIndex() {
        print("updateViewsAndIndex")
        self.stressLevelIndex = 5
        let heartRate = self.updateHeartRateView()
        let activity = self.updateActivityView()
        let mindfulTime = self.updateMindfulTimeView()
        let sleepTime = self.updateSleepTimeView()
        self.updateStressIndex()
        self.saveStressLevelIndex(index: self.stressLevelIndex, heartRate: heartRate, activity: activity, mindfulTime: mindfulTime, sleepTime: sleepTime)
    }

    
    private func displayAlert(for error: Error) {
        let alert = UIAlertController(title: nil,
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))

        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigations
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "E1ToE3Segue" {
            let target_nav = segue.destination as! UINavigationController
            if let target = target_nav.viewControllers.first as? E3_SpecificHealthDataViewController {
                switch tapView {
                case 0:
                    target.title = "HEART RATE"
                    target.navigationController?.title = "Heart Rate"
                    target.dataType = "heartRate"
                case 1:
                    target.title = "ACTIVITY"
                    target.navigationController?.title = "Activity"
                    target.dataType = "activity"
                case 2:
                    target.title = "MINDFUL TIME"
                    target.navigationController?.title = "Mindful Time"
                    target.dataType = "mindfulTime"
                default:
                    target.title = "SLEEP TIME"
                    target.navigationController?.title = "Sleep Time"
                    target.dataType = "sleepTime"
                }
            }
        }
    }
    
    
    private func saveStressLevelIndex(index: Int, heartRate: Double?, activity: Double?, mindfulTime: Double?, sleepTime: Double?) {
        self.view.makeToast("Save Stress Index: \(String(index))", duration: 1.0, position: .bottom)
        let record = StressIndexRecordObject()
        record.date = Date()
        record.stressIndex = index
        record.heartRate = heartRate ?? -1.0
        record.activeEnergy = activity ?? -1.0
        record.mindfulMinutes = mindfulTime ?? -1.0
        record.sleepHours = sleepTime ?? -1.0
        
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
        
        sendStressReminderNotifications()
    }
    
    
    // MARK: - AIChatbot Related Functions
    
    private func setupAIChatbot() {
        let kmUser = KMUser()
        kmUser.userId = Kommunicate.randomId()
        kmUser.displayName = currentuser.name
        kmUser.applicationId = "25bf91ac7fe1e011b0882253edbc2cf1d"

        Kommunicate.registerUser(kmUser, completion: {
            response, error in
            guard error == nil else {
                print("Kommunicate Register User: Unsuccessful")
                return
            }
        })
    }
    
    private func openChatbotView() {
        // Pass an instance of the current UIViewController in the 'from' argument.
        Kommunicate.createAndShowConversation(from: self) { error in
            guard error == nil else {
                print("Conversation error: \(error.debugDescription)")
                return
            }
        }
    }
    
    
    // MARK: - setupLoadingIndicator
    private func setupLoadingIndicator() {
        overrideUserInterfaceStyle = .light
        self.view.backgroundColor = .white
        self.view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: self.view.centerXAnchor),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: self.view.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 50),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }
    
    // MARK: - Properties
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.red, .green, .blue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
}
