//
//  E3_SpecificHealthDataViewController.swift
//  Soulmate
//
//  Created by Will Lam on 8/3/2021.
//

import UIKit
import HealthKit
import SwiftChart

class E3_SpecificHealthDataViewController: UIViewController, ChartDelegate {
    
    
    // MARK: - Variables
    @IBOutlet weak var lb_range: UILabel!
    @IBOutlet weak var lb_chartData: UILabel!
    var dataType: String = ""
    
    
    // MARK: - Actions
    @IBAction func press_DoneButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lb_chartData.isHidden = true
        self.showData()
        self.showChart()
    }
    

    // MARK: - Private Functions
    
    private func showData() {
        switch dataType {
        case "heartRate":
            if let heartRate = currentuser.userNormalRange?.heartRate {
                let min = heartRate.weekdays_min
                let max = heartRate.weekdays_max
                self.lb_range.text = "\(Int(min)) - \(Int(max)) count/min"
            } else {
                print("Unable to show heart rate normal range data")
            }
        case "activity":
            if let activeEnergy = currentuser.userNormalRange?.activeEnergy {
                if Calendar.current.isDateInWeekend(Date()) {
                    let min = activeEnergy.weekends_min
                    let max = activeEnergy.weekends_max
                    self.lb_range.text = "\(min.rounded(toPlaces: 2)) - \(max.rounded(toPlaces: 2)) kcal"
                } else {
                    let min = activeEnergy.weekdays_min
                    let max = activeEnergy.weekdays_max
                    self.lb_range.text = "\(min.rounded(toPlaces: 2)) - \(max.rounded(toPlaces: 2)) kcal"
                }
            } else {
                print("Unable to show activity normal range data")
            }
        case "mindfulTime":
            if let mindfulMinutes = currentuser.userNormalRange?.mindfulMinutes {
                if Calendar.current.isDateInWeekend(Date()) {
                    let min = mindfulMinutes.weekends_min
                    let max = mindfulMinutes.weekends_max
                    self.lb_range.text = "\(Int(min)) - \(Int(max)) mins"
                } else {
                    let min = mindfulMinutes.weekdays_min
                    let max = mindfulMinutes.weekdays_max
                    self.lb_range.text = "\(Int(min)) - \(Int(max)) mins"
                }
            } else {
                print("Unable to show mindful time normal range data")
            }
        default:
            if let sleepHours = currentuser.userNormalRange?.sleepHours {
                if Calendar.current.isDateInWeekend(Date()) {
                    let min = sleepHours.weekends_min
                    let max = sleepHours.weekends_max
                    self.lb_range.text = "\(min.rounded(toPlaces: 2)) - \(max.rounded(toPlaces: 2)) hrs"
                } else {
                    let min = sleepHours.weekdays_min
                    let max = sleepHours.weekdays_max
                    self.lb_range.text = "\(min.rounded(toPlaces: 2)) - \(max.rounded(toPlaces: 2)) hrs"
                }
            } else {
                print("Unable to show sleep hours normal range data")
            }
        }
    }
    
    
    private func showChart() {
        let chart = Chart(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 50, height: self.view.frame.height - 400))
        chart.center.x = self.view.center.x
        chart.center.y = self.view.center.y + 30.0
        chart.delegate = self
        chart.minY = 0
        chart.showXLabelsAndGrid = false
        
        let dF = DateFormatter()
        dF.dateFormat = "yyyy-MM-dd"
        
        var data: [(x: Int, y: Double)] = []
        
        
        switch dataType {
        
        case "heartRate":
            var count = 50
            if userHealthProfile.heartRate.count < 50 {
                count = userHealthProfile.heartRate.count
            }
            let latestRecords = userHealthProfile.heartRate[0..<count]
            for record in latestRecords {
                let heartRateInBPM = record.quantity.doubleValue(for: HKUnit(from: "count/min"))
                let heartRate = heartRateInBPM
                data.append((x: count, y: heartRate))
                count -= 1
            }
            chart.yLabelsFormatter = { String(Int($1)) + " count/min" }
            
        case "activity":
            var count = 30
            if userHealthProfile.activeEnergy.count < 30 {
                count = userHealthProfile.activeEnergy.count
            }
            let latestRecords = userHealthProfile.activeEnergy[0..<count]
            for record in latestRecords {
                if let sum = record.sumQuantity() {
                    let energyInKcal = sum.doubleValue(for: .kilocalorie())
                    data.append((x: count, y: energyInKcal))
                    count -= 1
                }
            }
            chart.yLabelsFormatter = { String(Int($1)) + " kcal" }
            
        case "mindfulTime":
            var recordList: [Double] = []
            var currentRecord: Double = 0.0
            var dayAdded: TimeInterval = 0
            
            for record in userHealthProfile.mindfulMinutes.prefix(100) {
                while Calendar.current.startOfDay(for: record.endDate) != Calendar.current.startOfDay(for: Date().addingTimeInterval(-dayAdded * 60 * 60 * 24)) {
                    dayAdded += 1
                    recordList.append(currentRecord)
                    currentRecord = 0
                }
                currentRecord += record.endDate.timeIntervalSince(record.startDate)/60
            }
                        
            var count = 30
            if recordList.count < 30 {
                count = recordList.count
            }
            let latestRecords = recordList[0..<count]
            for record in latestRecords {
                data.append((x: count, y: record))
                count -= 1
            }
            chart.yLabelsFormatter = { String(Int($1)) + " mins" }
            
        default:
            var recordList: [Double] = []
            var currentRecord: Double = 0.0
            var dayAdded: TimeInterval = 0
            
            for record in userHealthProfile.sleepHours.prefix(100) {
                while Calendar.current.startOfDay(for: record.endDate) != Calendar.current.startOfDay(for: Date().addingTimeInterval(-dayAdded * 60 * 60 * 24)) {
                    dayAdded += 1
                    recordList.append(currentRecord)
                    currentRecord = 0
                }
                currentRecord += record.endDate.timeIntervalSince(record.startDate)/3600
            }
                        
            var count = 30
            if recordList.count < 30 {
                count = recordList.count
            }
            let latestRecords = recordList[0..<count]
            for record in latestRecords {
                data.append((x: count, y: record))
                count -= 1
            }
            chart.yLabelsFormatter = { String(Int($1)) + " hours" }
        }
        
        var upperData: [(x: Int, y: Double)] = []
        var lowerData: [(x: Int, y: Double)] = []
        
        switch dataType {
        case "heartRate":
            if let heartRate = currentuser.userNormalRange?.heartRate {
                let min = heartRate.weekdays_min
                let max = heartRate.weekdays_max
                for count in 0...data.count {
                    upperData.append((x: count, y: max))
                    lowerData.append((x: count, y: min))
                }
            } else {
                print("Unable to show heart rate normal range data")
            }
            
        case "activity":
            if let activeEnergy = currentuser.userNormalRange?.activeEnergy {
                if Calendar.current.isDateInWeekend(Date()) {
                    let min = activeEnergy.weekends_min
                    let max = activeEnergy.weekends_max
                    for count in 0...data.count {
                        upperData.append((x: count, y: max))
                        lowerData.append((x: count, y: min))
                    }
                } else {
                    let min = activeEnergy.weekdays_min
                    let max = activeEnergy.weekdays_max
                    for count in 0...data.count {
                        upperData.append((x: count, y: max))
                        lowerData.append((x: count, y: min))
                    }
                }
            } else {
                print("Unable to show activity normal range data")
            }
            
        case "mindfulTime":
            if let mindfulMinutes = currentuser.userNormalRange?.mindfulMinutes {
                if Calendar.current.isDateInWeekend(Date()) {
                    let min = mindfulMinutes.weekends_min
                    let max = mindfulMinutes.weekends_max
                    for count in 0...data.count {
                        upperData.append((x: count, y: max))
                        lowerData.append((x: count, y: min))
                    }
                } else {
                    let min = mindfulMinutes.weekdays_min
                    let max = mindfulMinutes.weekdays_max
                    for count in 0...data.count {
                        upperData.append((x: count, y: max))
                        lowerData.append((x: count, y: min))
                    }
                }
            } else {
                print("Unable to show mindful time normal range data")
            }
            
        default:
            if let sleepHours = currentuser.userNormalRange?.sleepHours {
                if Calendar.current.isDateInWeekend(Date()) {
                    let min = sleepHours.weekends_min
                    let max = sleepHours.weekends_max
                    for count in 0...data.count {
                        upperData.append((x: count, y: max))
                        lowerData.append((x: count, y: min))
                    }
                } else {
                    let min = sleepHours.weekdays_min
                    let max = sleepHours.weekdays_max
                    for count in 0...data.count {
                        upperData.append((x: count, y: max))
                        lowerData.append((x: count, y: min))
                    }
                }
            } else {
                print("Unable to show sleep hours normal range data")
            }
        }
        
        let upperBoundSeries = ChartSeries(data: upperData)
        upperBoundSeries.color = UIColor.red
        chart.add(upperBoundSeries)
        
        let lowerBoundSeries = ChartSeries(data: lowerData)
        lowerBoundSeries.color = UIColor.red
        chart.add(lowerBoundSeries)
        
        let series = ChartSeries(data: data)
        series.area = true
        if dataType == "heartRate" {
            series.colors = (
                above: UIColor.red,
                below: UIColor.green,
                zeroLevel: upperData.first!.y
            )
        } else {
            series.colors = (
                above: UIColor.green,
                below: UIColor.red,
                zeroLevel: lowerData.first!.y
            )
        }
        chart.add(series)
        
        self.view.addSubview(chart)
    }
    
    
    // MARK: ChartDelegate
    
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        let dF = DateFormatter()
        dF.dateFormat = "yyyy-MM-dd"
        self.lb_chartData.isHidden = false
        for (seriesIndex, dataIndex) in indexes.enumerated() {
            if dataIndex != nil {
                let value = chart.valueForSeries(seriesIndex, atIndex: dataIndex)
                switch dataType {
                case "heartRate":
                    let dF2 = DateFormatter()
                    dF2.dateFormat = "yyyy-MM-dd hh:mm"
                    let date_shown = dF2.string(from: userHealthProfile.heartRate[dataIndex!].endDate)
                    self.lb_chartData.text = """
                        \(date_shown)
                        \(String(Int(value!))) count/min
                        """

                case "activity":
                    let date_shown = dF.string(from: Calendar.current.startOfDay(for: Date().addingTimeInterval(-TimeInterval(dataIndex!) * 60 * 60 * 24)))
                    self.lb_chartData.text = """
                        \(date_shown)
                        \(String(value!.rounded(toPlaces: 2))) kcal
                        """

                case "mindfulTime":
                    let date_shown = dF.string(from: Calendar.current.startOfDay(for: Date().addingTimeInterval(-TimeInterval(dataIndex!) * 60 * 60 * 24)))
                    self.lb_chartData.text = """
                        \(date_shown)
                        \(String(Int(value!))) mins
                        """
                    
                default:
                    let date_shown = dF.string(from: Calendar.current.startOfDay(for: Date().addingTimeInterval(-TimeInterval(dataIndex!) * 60 * 60 * 24)))
                    self.lb_chartData.text = """
                        \(date_shown)
                        \(String(value!.rounded(toPlaces: 2))) hours
                        """
                }
            }
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
//        print("didFinishTouchingChart")
    }
    
    func didEndTouchingChart(_ chart: Chart) {
//        print("didEndTouchingChart")
    }
    
}
