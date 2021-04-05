//
//  H1_HomeViewController.swift
//  Soulmate
//
//  Created by Will Lam on 22/2/2021.
//

import UIKit
import MaterialComponents
import RealmSwift
import Toast_Swift


class H1_HomeViewController: UIViewController {
    
    // MARK: - Variables
    @IBOutlet weak var stress_slideBar: UISlider!
    let quoteCard = MDCCardCollectionCell()
    let quote = quotesList.randomElement()
    let quoteLabel = UILabel()
    let lb_quickRecord = UILabel()
    let lb_min = UILabel()
    let lb_max = UILabel()
    
    
    // MARK: - Actions
    @IBAction func stressSliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        self.saveStressLevelIndex(index: currentValue, heartRate: nil, activity: nil, mindfulTime: nil, sleepTime: nil)
    }
    
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "HOME"
        navigationController?.title = "Home"
        
        self.setupUserIconButton()
        self.setupUI()
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
        let lb_logo_soulmate = UILabel()
        lb_logo_soulmate.text = "Soulmate"
        lb_logo_soulmate.font = UIFont(name: "American Typewriter Bold", size: 18.0)
        lb_logo_soulmate.textAlignment = .center
        lb_logo_soulmate.textColor = UIColor(hex: "#FF9587FF")
        lb_logo_soulmate.frame = CGRect(x: 10.0, y: 20.0, width: 100.0, height: 50.0)
        lb_logo_soulmate.center.x = self.view.center.x
        self.view.addSubview(lb_logo_soulmate)
        
        
        // Set up 'Today Quote' Card
        
        quoteCard.frame = CGRect(x: 60.0, y: 150.0, width: self.view.frame.width - 50.0, height: 100.0)
        quoteCard.center.x = self.view.center.x
        quoteCard.cornerRadius = 3.0
        quoteCard.applyTheme(withScheme: globalContainerScheme())
        quoteCard.sizeToFit()
        
        quoteLabel.text = quote
        quoteLabel.numberOfLines = 0
        quoteLabel.font = UIFont(name: "Noteworthy", size: 16.0)
        
        quoteLabel.frame = CGRect(x: 15.0, y: 10.0, width: quoteCard.frame.width - 30.0, height: heightForView(text: quoteLabel.text!, font: quoteLabel.font, width: quoteCard.frame.width - 30.0))
        self.quoteCard.addSubview(quoteLabel)
        
        quoteCard.frame = CGRect(x: quoteCard.frame.minX, y: quoteCard.frame.minY, width: quoteCard.frame.width, height: quoteLabel.frame.height + 20.0)
        
        self.view.addSubview(quoteCard)
        
        
        // Set up Slide Bar
        
        lb_quickRecord.font = UIFont(name: "American Typewriter Bold", size: 17.0)
        lb_quickRecord.frame = CGRect(x: 0.0, y: quoteCard.frame.maxY + 30.0, width: 300.0, height: 20.0)
        lb_quickRecord.center.x = self.view.center.x
        lb_quickRecord.textAlignment = .center
        lb_quickRecord.text = "Stress Level Quick Record"
        self.view.addSubview(lb_quickRecord)
        
        stress_slideBar.value = 5
        stress_slideBar.frame = CGRect(x: 0.0, y: lb_quickRecord.frame.maxY + 15.0, width: self.view.frame.width-50.0, height: 40.0)
        stress_slideBar.center.x = self.view.center.x
        
        lb_min.font = UIFont(name: "American Typewriter Regular", size: 8.0)
        lb_min.frame = CGRect(x: 25.0, y: stress_slideBar.frame.maxY, width: 50.0, height: 12.0)
        lb_min.textAlignment = .left
        lb_min.text = "min"
        self.view.addSubview(lb_min)
        
        lb_max.font = UIFont(name: "American Typewriter Regular", size: 8.0)
        lb_max.frame = CGRect(x: self.view.frame.width-75.0, y: stress_slideBar.frame.maxY, width: 50.0, height: 12.0)
        lb_max.textAlignment = .right
        lb_max.text = "max"
        self.view.addSubview(lb_max)
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
    }
}
