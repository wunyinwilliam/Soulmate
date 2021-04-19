//
//  R1_RecordsViewController.swift
//  Soulmate
//
//  Created by Will Lam on 2/3/2021.
//

import UIKit
import KDCalendar
import RealmSwift


class R1_RecordsViewController: UIViewController {

    // MARK: - Variables
    @IBOutlet var calendarView: CalendarView!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var lb_average: UILabel!
    
    var recordPassed: StressIndexRecordObject? = nil
    

    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "RECORDS"
        navigationController?.title = "Records"
        
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self

        self.setupLoadingIndicator()
        self.setupUserIconButton()
        self.setupCalendar()
        self.setupRefreshButton()
        self.setupUI()
    }
    
    
    // MARK: - ViewDidAppear

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let today = Date()
        self.calendarView.selectDate(today)

        #if KDCALENDAR_EVENT_MANAGER_ENABLED
        self.calendarView.loadEvents() { error in
            if error != nil {
                let message = "The karmadust calender could not load system events. It is possibly a problem with permissions"
                let alert = UIAlertController(title: "Events Loading Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        #endif
        
        self.calendarView.setDisplayDate(today)
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
    
    
    private func setupCalendar() {
        let style = CalendarView.Style()
        
        style.cellShape                = .bevel(8.0)
        style.cellColorDefault         = UIColor.clear
        style.cellColorToday           = UIColor(red:1.00, green:0.84, blue:0.64, alpha:1.00)
        style.cellSelectedBorderColor  = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        style.cellEventColor           = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        style.headerTextColor          = UIColor.gray
        
        style.cellTextColorDefault     = UIColor(red: 249/255, green: 180/255, blue: 139/255, alpha: 1.0)
        style.cellTextColorToday       = UIColor.orange
        style.cellTextColorWeekend     = UIColor(red: 237/255, green: 103/255, blue: 73/255, alpha: 1.0)
        style.cellColorOutOfRange      = UIColor(red: 249/255, green: 226/255, blue: 212/255, alpha: 1.0)
            
        style.headerBackgroundColor    = UIColor(hex: "#F8EDEBFF")!
        style.weekdaysBackgroundColor  = UIColor(hex: "#F8EDEBFF")!
        style.firstWeekday             = .sunday
        
        style.locale                   = Locale(identifier: "en_US")
        
        style.cellFont = UIFont(name: "Helvetica", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0)
        style.headerFont = UIFont(name: "Helvetica", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0)
        style.weekdaysFont = UIFont(name: "Helvetica", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        
        calendarView.style = style
        
        calendarView.dataSource = self
        calendarView.delegate = self
        
        calendarView.direction = .horizontal
        calendarView.multipleSelectionEnable = false
        calendarView.marksWeekends = true
        
        calendarView.backgroundColor = UIColor(hex: "#F8EDEBFF")
    }
    
    
    private func setupRefreshButton() {
        let refreshButton = UIButton(primaryAction: UIAction(title: "", handler: { [self] _ in
            self.detailTableView.reloadData()
            loadingIndicator.isAnimating = true
            self.view.isUserInteractionEnabled = false
            
            self.view.mask = UIView(frame: self.view.frame)
            self.view.mask?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.loadingIndicator.isAnimating = false
                self.view.isUserInteractionEnabled = true
                self.view.mask = nil
            }
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
    }
    
    // MARK: - setupLoadingIndicator
    private func setupLoadingIndicator() {
        overrideUserInterfaceStyle = .light
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


// MARK: - CalendarViewDataSource

extension R1_RecordsViewController: CalendarViewDataSource {
    func headerString(_ date: Date) -> String? {
        let dF = DateFormatter()
        dF.dateFormat = "MMMM yyyy"
        return dF.string(from: date)
    }
    
    func startDate() -> Date {
        let dF = DateFormatter()
        dF.dateFormat = "yyyy/MM/dd"
        let Jan2021 = dF.date(from: "2021/01/02")!
        return Jan2021
    }
      
    func endDate() -> Date {
        let today = Date()
        return today
    }
    
}


// MARK: - CalendarViewDelegate

extension R1_RecordsViewController: CalendarViewDelegate {
    
    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
        
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        self.detailTableView.isHidden = true
        self.lb_average.isHidden = true
    }
    
    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        return true
    }
    
    func calendar(_ calendar: CalendarView, didSelectDate date : Date, withEvents events: [CalendarEvent]) {
        detailTableView.reloadData()
        self.detailTableView.isHidden = false
        self.lb_average.isHidden = false
    }
           
    func calendar(_ calendar: CalendarView, didLongPressDate date : Date, withEvents events: [CalendarEvent]?) {
    }
}


extension R1_RecordsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(calendarView.selectedDates)
        if calendarView.selectedDates.count != 0 {
            let selectedDate = calendarView.selectedDates[0]
            return retrivestressIndexRecord(selectedDate).count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "R1TableCell", for: indexPath)
        
        let dF_timeOnly = DateFormatter()
        dF_timeOnly.dateFormat = "hh:mm"
        
        if calendarView.selectedDates.count != 0 {
            let selectedDate = calendarView.selectedDates[0]
            if let textLabel = cell.textLabel {
                textLabel.text = dF_timeOnly.string(from: retrivestressIndexRecord(selectedDate)[indexPath.row].date)
            } else {
                print("ERROR: There is no textLabel in the cell")
            }
            if let detailTextLabel = cell.detailTextLabel {
                detailTextLabel.text = String(retrivestressIndexRecord(selectedDate)[indexPath.row].stressIndex)
            } else {
                print("ERROR: There is no detailTextLabel in the cell")
            }
        }
        return cell
    }
    
    private func retrivestressIndexRecord(_ selectedDate: Date) -> [StressIndexRecordObject] {
        var temp_recordsList: [StressIndexRecordObject] = []
        var average: Double = 0.0
        let dF_dateOnly = DateFormatter()
        dF_dateOnly.dateFormat = "yyyy/MM/dd"
        if let stressIndexRecord = currentuser.userStressIndexRecord {
            for record in stressIndexRecord.records {
                if dF_dateOnly.string(from: record.date) == dF_dateOnly.string(from: selectedDate) {
                    temp_recordsList.append(record)
                    average += Double(record.stressIndex)
                }
            }
            if temp_recordsList.count > 0 {
                average = average/Double(temp_recordsList.count)
                self.update_lb_average(selectedDate, average)
            } else {
                self.update_lb_average(selectedDate, nil)
            }
        } else {
            print("There is no user stress index record.")
            self.update_lb_average(selectedDate, nil)
        }
        return temp_recordsList
    }
    
    private func update_lb_average(_ selectedDate: Date, _ average: Double?) {
        let dF_dateOnly = DateFormatter()
        dF_dateOnly.dateFormat = "yyyy/MM/dd"
        var text = "\(dF_dateOnly.string(from: selectedDate))"
        if average != nil {
            text += " Average: \(average!.rounded(toPlaces: 2))"
        }
        self.lb_average.text = text
    }
}

extension R1_RecordsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if calendarView.selectedDates.count != 0 {
            let selectedDate = calendarView.selectedDates[0]
            recordPassed = retrivestressIndexRecord(selectedDate)[indexPath.row]
            self.performSegue(withIdentifier: "R1ToR2Segue", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if calendarView.selectedDates.count != 0 {
                let selectedDate = calendarView.selectedDates[0]
                if let stressIndexRecord = currentuser.userStressIndexRecord {
                    let newRecords = StressIndexRecord()
                    for record in stressIndexRecord.records {
                        if record.date != retrivestressIndexRecord(selectedDate)[indexPath.row].date {
                            newRecords.records.append(record)
                        }
                    }
                    let realm = try! Realm()
                    let user = realm.objects(User.self).filter("userID == \(currentuser.userID)").first
                    try! realm.write {
                        user!.userStressIndexRecord = newRecords
                    }
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "R1ToR2Segue" {
            let target_nav = segue.destination as! UINavigationController
            if let target = target_nav.viewControllers.first as? R2_RecordsDetailTableViewController {
                let dF = DateFormatter()
                dF.dateFormat = "yyyy/MM/dd hh:mm"
                if let recordPassed = recordPassed {
                    target.title = dF.string(from: recordPassed.date)
                    target.navigationController?.title = dF.string(from: recordPassed.date)
                    target.record = recordPassed
                } else {
                    print("ERROR: recordPassed is nil")
                }
            }
        }
    }
}
