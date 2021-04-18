//
//  globalFunctions.swift
//  
//
//  Created by Will Lam on 10/3/2021.
//

import UIKit
import HealthKit
import RealmSwift
import MaterialComponents


// MARK: - authorizeHealthKit

func authorizeHealthKit() {
    HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
        guard authorized else {
            let baseMessage = "HealthKit Authorization Failed"
            if let error = error {
                print("\(baseMessage). Reason: \(error.localizedDescription)")
            } else {
                print(baseMessage)
            }
            return
        }
        print("HealthKit Successfully Authorized.")
        extractAllHealthData()
    }
}


// MARK: - extractAllHealthData

func extractAllHealthData() {
    print("extractAllHealthData")
    extractHeartHealthData()
    extractActivityHealthData()
    extractRespiratoryHealthData()
    extractMindfulnessHealthData()
    extractSleepHealthData()
}


// MARK: - extractHeartHealthData

func extractHeartHealthData() {
    guard let heartRateSampleType = HKSampleType.quantityType(forIdentifier: .heartRate) else {
        print("Heart Rate Sample Type is no longer available in HealthKit")
        return
    }
    
    guard let restingHeartRateSampleType = HKSampleType.quantityType(forIdentifier: .restingHeartRate) else {
        print("Resting Heart Rate Sample Type is no longer available in HealthKit")
        return
    }
    
    ProfileDataStore.getMostRecentSample(noOfSamples: defaultNoOfSamples, noOfDays: nil, for: heartRateSampleType) { (sample, error) in
        guard let sample = sample else {
            if let error = error {
                print(error)
            }
            return
        }
        userHealthProfile.heartRate = sample
    }
    
    ProfileDataStore.getMostRecentSample(noOfSamples: nil, noOfDays: defaultNoOfDays, for: restingHeartRateSampleType) { (sample, error) in
        guard let sample = sample else {
            if let error = error {
                print(error)
            }
            return
        }
        userHealthProfile.restingHeartRate = sample
    }
}


// MARK: - extractActivityHealthData

func extractActivityHealthData() {
    guard let activeEnergySampleType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
        print("Activity Energy Sample Type is no longer available in HealthKit")
        return
    }
    
    guard let exerciseMinutesSampleType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) else {
        print("Exercise Minutes Sample Type is no longer available in HealthKit")
        return
    }
    
    guard let standMinutesSampleType = HKQuantityType.quantityType(forIdentifier: .appleStandTime) else {
        print("Stand Minutes Sample Type is no longer available in HealthKit")
        return
    }
    
    guard let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
        print("Steps Sample Type is no longer available in HealthKit")
        return
    }
    
    guard let walkingAndRunningDistanceSampleType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
        print("Walking And Running Distance Sample Type is no longer available in HealthKit")
        return
    }
    
    ProfileDataStore.getMostRecentAccumulateSample(noOfDays: defaultNoOfDays, for: activeEnergySampleType) { (sample, error) in
        guard let sample = sample else {
            if let error = error {
                print(error)
            }
            return
        }
        userHealthProfile.activeEnergy = sample.reversed()
    }
    
    ProfileDataStore.getMostRecentAccumulateSample(noOfDays: defaultNoOfDays, for: exerciseMinutesSampleType) { (sample, error) in
        guard let sample = sample else {
            if let error = error {
                print(error)
            }
            return
        }
        userHealthProfile.exerciseMinutes = sample.reversed()
    }
    
    ProfileDataStore.getMostRecentAccumulateSample(noOfDays: defaultNoOfDays, for: standMinutesSampleType) { (sample, error) in
        guard let sample = sample else {
            if let error = error {
                print(error)
            }
            return
        }
        userHealthProfile.standMinutes = sample.reversed()
    }
    
    ProfileDataStore.getMostRecentAccumulateSample(noOfDays: defaultNoOfDays, for: stepsQuantityType) { (sample, error) in
        guard let sample = sample else {
            if let error = error {
                print(error)
            }
            return
        }
        userHealthProfile.steps = sample.reversed()
    }
    
    ProfileDataStore.getMostRecentAccumulateSample(noOfDays: defaultNoOfDays, for: walkingAndRunningDistanceSampleType) { (sample, error) in
        guard let sample = sample else {
            if let error = error {
                print(error)
            }
            return
        }
        userHealthProfile.walkingRunningDistance = sample.reversed()
    }
    
}


// MARK: - extractRespiratoryHealthData

func extractRespiratoryHealthData() {
    guard let bloodOxygenSampleType = HKSampleType.quantityType(forIdentifier: .oxygenSaturation) else {
        print("Blood Oxygen Sample Type is no longer available in HealthKit")
        return
    }
    
    ProfileDataStore.getMostRecentSample(noOfSamples: nil, noOfDays: defaultNoOfDays, for: bloodOxygenSampleType) { (sample, error) in
        guard let sample = sample else {
            if let error = error {
                print(error)
            }
            return
        }
        userHealthProfile.bloodOxygen = sample
    }
}


// MARK: - extractMindfulnessHealthData

func extractMindfulnessHealthData() {
    guard let mindfulMinutesSample = HKSampleType.categoryType(forIdentifier: .mindfulSession) else {
        print("Mindful Minutes Sample Type is no longer available in HealthKit")
        return
    }
    
    ProfileDataStore.getMostRecentCategoryTypeSample(noOfSamples: nil, noOfDays: defaultNoOfDays, for: mindfulMinutesSample) { (sample, error) in
        guard let sample = sample else {
            if let error = error {
                print(error)
            }
            return
        }
        userHealthProfile.mindfulMinutes = sample
    }
}


// MARK: - extractSleepHealthData

func extractSleepHealthData() {
    guard let sleepMinutesSampleType = HKSampleType.categoryType(forIdentifier: .sleepAnalysis) else {
        print("Sleep Minutes Sample Type is no longer available in HealthKit")
        return
    }
    
    ProfileDataStore.getMostRecentCategoryTypeSample(noOfSamples: nil, noOfDays: defaultNoOfDays, for: sleepMinutesSampleType) { (sample, error) in
        guard let sample = sample else {
            if let error = error {
                print(error)
            }
            return
        }
        userHealthProfile.sleepHours = sample
    }
}




// MARK: - calculateAverage_AllHealthData

func calculateAverage_AllHealthData() {
    print("calculateAverage_AllHealthData")
    calculateAverage_ActivityHealthData()
    calculateAverage_HeartHealthData()
    calculateAverage_RespiratoryHealthData()
    calculateAverage_MindfulnessHealthData()
    calculateAverage_SleepHealthData()
}


// MARK: - calculateAverage_ActivityHealthData

func calculateAverage_ActivityHealthData() {
    calculateAverage_ActiveEnergyHealthData()
    calculateAverage_ExerciseMinutesHealthData()
    calculateAverage_StandMinutesHealthData()
    calculateAverage_StepsHealthData()
    calculateAverage_WalkingRunningDistanceHealthData()
}
    
func calculateAverage_ActiveEnergyHealthData() {
        
    guard currentuser.userNormalRange?.activeEnergy != nil else {
        currentuser.userNormalRange?.activeEnergy = DataNormalRange()
        return
    }
    if !(currentuser.userNormalRange?.activeEnergy!.isManual)! {
        var activeEnergy_weekends_average: Double = 0.0
        var activeEnergy_weekdays_average: Double = 0.0
        var activeEnergy_weekends_count: Int = 0
        var activeEnergy_weekdays_count: Int = 0

        for record in userHealthProfile.activeEnergy {
            if let sum = record.sumQuantity() {
                let energyInKcal = sum.doubleValue(for: .kilocalorie())
                if Calendar.current.isDateInWeekend(record.startDate) {
                    activeEnergy_weekends_average += energyInKcal
                    activeEnergy_weekends_count += 1
                } else {
                    activeEnergy_weekdays_average += energyInKcal
                    activeEnergy_weekdays_count += 1
                }
            }
        }
        activeEnergy_weekends_average = activeEnergy_weekends_average / Double(activeEnergy_weekends_count)
        activeEnergy_weekdays_average = activeEnergy_weekdays_average / Double(activeEnergy_weekdays_count)
        
        let realm = try! Realm()
        let user = realm.objects(User.self).filter("userID == \(currentuser.userID)").first
        try! realm.safeWrite {
            user!.userNormalRange?.activeEnergy?.weekends_min = activeEnergy_weekends_average - 100
            user!.userNormalRange?.activeEnergy?.weekends_max = activeEnergy_weekends_average + 100
            user!.userNormalRange?.activeEnergy?.weekdays_min = activeEnergy_weekdays_average - 100
            user!.userNormalRange?.activeEnergy?.weekdays_max = activeEnergy_weekdays_average + 100
            if (currentuser.userNormalRange?.activeEnergy!.weekends_min)! < 200 {
                user!.userNormalRange?.activeEnergy?.weekends_min = 200
            }
            if (currentuser.userNormalRange?.activeEnergy!.weekdays_min)! < 200 {
                user!.userNormalRange?.activeEnergy?.weekdays_min = 200
            }
        }
    }
    
    
}

func calculateAverage_ExerciseMinutesHealthData() {
    guard currentuser.userNormalRange?.exerciseMinutes != nil else {
        currentuser.userNormalRange?.exerciseMinutes = DataNormalRange()
        return
    }
    if !currentuser.userNormalRange!.exerciseMinutes!.isManual {
        var exerciseMinutes_weekends_average: Double = 0.0
        var exerciseMinutes_weekdays_average: Double = 0.0
        var exerciseMinutes_weekends_count: Int = 0
        var exerciseMinutes_weekdays_count: Int = 0

        for record in userHealthProfile.exerciseMinutes {
            if let sum = record.sumQuantity() {
                let timeInMinutes = sum.doubleValue(for: .minute())
                if Calendar.current.isDateInWeekend(record.startDate) {
                    exerciseMinutes_weekends_average += timeInMinutes
                    exerciseMinutes_weekends_count += 1
                } else {
                    exerciseMinutes_weekdays_average += timeInMinutes
                    exerciseMinutes_weekdays_count += 1
                }
            }
        }
        exerciseMinutes_weekends_average = exerciseMinutes_weekends_average / Double(exerciseMinutes_weekends_count)
        exerciseMinutes_weekdays_average = exerciseMinutes_weekdays_average / Double(exerciseMinutes_weekdays_count)
        
        let realm = try! Realm()
        let user = realm.objects(User.self).filter("userID == \(currentuser.userID)").first
        try! realm.safeWrite {
            if !exerciseMinutes_weekends_average.isNaN && !exerciseMinutes_weekends_average.isInfinite {
                user!.userNormalRange?.exerciseMinutes?.weekends_min = exerciseMinutes_weekends_average - 30
                user!.userNormalRange?.exerciseMinutes?.weekends_max = exerciseMinutes_weekends_average + 30
            }
            if !exerciseMinutes_weekdays_average.isNaN && !exerciseMinutes_weekdays_average.isInfinite {
                user!.userNormalRange?.exerciseMinutes?.weekdays_min = exerciseMinutes_weekdays_average - 30
                user!.userNormalRange?.exerciseMinutes?.weekdays_max = exerciseMinutes_weekdays_average + 30
            }
            
            if currentuser.userNormalRange!.exerciseMinutes!.weekends_min < 15 {
                user!.userNormalRange?.exerciseMinutes?.weekends_min = 15
            }
            if currentuser.userNormalRange!.exerciseMinutes!.weekdays_min < 15 {
                user!.userNormalRange?.exerciseMinutes?.weekdays_min = 15
            }
        }
    }
}

func calculateAverage_StandMinutesHealthData() {
    guard currentuser.userNormalRange?.standMinutes != nil else {
        currentuser.userNormalRange?.standMinutes = DataNormalRange()
        return
    }
    if !currentuser.userNormalRange!.standMinutes!.isManual {
        var standMinutes_weekends_average: Double = 0.0
        var standMinutes_weekdays_average: Double = 0.0
        var standMinutes_weekends_count: Int = 0
        var standMinutes_weekdays_count: Int = 0

        for record in userHealthProfile.standMinutes {
            if let sum = record.sumQuantity() {
                let timeInMinutes = sum.doubleValue(for: .minute())
                if Calendar.current.isDateInWeekend(record.startDate) {
                    standMinutes_weekends_average += timeInMinutes
                    standMinutes_weekends_count += 1
                } else {
                    standMinutes_weekdays_average += timeInMinutes
                    standMinutes_weekdays_count += 1
                }
            }
        }
        standMinutes_weekends_average = standMinutes_weekends_average / Double(standMinutes_weekends_count)
        standMinutes_weekdays_average = standMinutes_weekdays_average / Double(standMinutes_weekdays_count)
        
        let realm = try! Realm()
        let user = realm.objects(User.self).filter("userID == \(currentuser.userID)").first
        try! realm.safeWrite {
            if !standMinutes_weekends_average.isNaN && !standMinutes_weekends_average.isInfinite {
                user!.userNormalRange?.standMinutes?.weekends_min = standMinutes_weekends_average - 30
                user!.userNormalRange?.standMinutes?.weekends_max = standMinutes_weekends_average + 30
            }
            
            if !standMinutes_weekdays_average.isNaN && !standMinutes_weekdays_average.isInfinite {
                user!.userNormalRange?.standMinutes?.weekdays_min = standMinutes_weekdays_average - 30
                user!.userNormalRange?.standMinutes?.weekdays_max = standMinutes_weekdays_average + 30
            }
            
            if currentuser.userNormalRange!.standMinutes!.weekends_min < 15 {
                user!.userNormalRange?.standMinutes?.weekends_min = 15
            }
            if currentuser.userNormalRange!.standMinutes!.weekdays_min < 15 {
                user!.userNormalRange?.standMinutes?.weekdays_min = 15
            }
        }
    }
}

func calculateAverage_StepsHealthData() {
    guard currentuser.userNormalRange?.steps != nil else {
        currentuser.userNormalRange?.steps = DataNormalRange()
        return
    }
    if !currentuser.userNormalRange!.steps!.isManual {
        var steps_weekends_average: Double = 0.0
        var steps_weekdays_average: Double = 0.0
        var steps_weekends_count: Int = 0
        var steps_weekdays_count: Int = 0

        for record in userHealthProfile.steps {
            if let sum = record.sumQuantity() {
                let stepsNumber = sum.doubleValue(for: .count())
                if Calendar.current.isDateInWeekend(record.startDate) {
                    steps_weekends_average += stepsNumber
                    steps_weekends_count += 1
                } else {
                    steps_weekdays_average += stepsNumber
                    steps_weekdays_count += 1
                }
            }
        }
        steps_weekends_average = steps_weekends_average / Double(steps_weekends_count)
        steps_weekdays_average = steps_weekdays_average / Double(steps_weekdays_count)
        
        let realm = try! Realm()
        let user = realm.objects(User.self).filter("userID == \(currentuser.userID)").first
        try! realm.safeWrite {
            if !steps_weekends_average.isNaN && !steps_weekends_average.isInfinite {
                user!.userNormalRange?.steps?.weekends_min = steps_weekends_average - 500
                user!.userNormalRange?.steps?.weekends_max = steps_weekends_average + 500
            }
                
            if !steps_weekdays_average.isNaN && !steps_weekdays_average.isInfinite {
                user!.userNormalRange?.steps?.weekdays_min = steps_weekdays_average - 500
                user!.userNormalRange?.steps?.weekdays_max = steps_weekdays_average + 500
            }
            
            if currentuser.userNormalRange!.steps!.weekends_min < 1000 {
                user!.userNormalRange?.steps?.weekends_min = 1000
            }
            if currentuser.userNormalRange!.steps!.weekdays_min < 1000 {
                user!.userNormalRange?.steps?.weekdays_min = 1000
            }
        }
    }
}

func calculateAverage_WalkingRunningDistanceHealthData() {
    guard currentuser.userNormalRange?.walkingRunningDistance != nil else {
        currentuser.userNormalRange?.walkingRunningDistance = DataNormalRange()
        return
    }
    if !currentuser.userNormalRange!.walkingRunningDistance!.isManual {
        var walkingRunningDistance_weekends_average: Double = 0.0
        var walkingRunningDistance_weekdays_average: Double = 0.0
        var walkingRunningDistance_weekends_count: Int = 0
        var walkingRunningDistance_weekdays_count: Int = 0

        for record in userHealthProfile.walkingRunningDistance {
            if let sum = record.sumQuantity() {
                let distanceInMeter = sum.doubleValue(for: .meter())
                if Calendar.current.isDateInWeekend(record.startDate) {
                    walkingRunningDistance_weekends_average += distanceInMeter
                    walkingRunningDistance_weekends_count += 1
                } else {
                    walkingRunningDistance_weekdays_average += distanceInMeter
                    walkingRunningDistance_weekdays_count += 1
                }
            }
        }
        walkingRunningDistance_weekends_average = walkingRunningDistance_weekends_average / Double(walkingRunningDistance_weekends_count)
        walkingRunningDistance_weekdays_average = walkingRunningDistance_weekdays_average / Double(walkingRunningDistance_weekdays_count)
        
        let realm = try! Realm()
        let user = realm.objects(User.self).filter("userID == \(currentuser.userID)").first
        try! realm.safeWrite {
            if !walkingRunningDistance_weekends_average.isNaN && !walkingRunningDistance_weekends_average.isInfinite {
                user!.userNormalRange?.walkingRunningDistance?.weekends_min = walkingRunningDistance_weekends_average - 500
                user!.userNormalRange?.walkingRunningDistance?.weekends_max = walkingRunningDistance_weekends_average + 500
            }
            
            if !walkingRunningDistance_weekdays_average.isNaN && !walkingRunningDistance_weekdays_average.isInfinite {
                user!.userNormalRange?.walkingRunningDistance?.weekdays_min = walkingRunningDistance_weekdays_average - 500
                user!.userNormalRange?.walkingRunningDistance?.weekdays_max = walkingRunningDistance_weekdays_average + 500
            }
            
            if currentuser.userNormalRange!.walkingRunningDistance!.weekends_min < 1000 {
                user!.userNormalRange?.walkingRunningDistance?.weekends_min = 1000
            }
            if currentuser.userNormalRange!.walkingRunningDistance!.weekdays_min < 1000 {
                user!.userNormalRange?.walkingRunningDistance?.weekdays_min = 1000
            }
        }
    }
}


// MARK: - calculateAverage_HeartHealthData

func calculateAverage_HeartHealthData() {
    calculateAverage_HeartRateHealthData()
    calculateAverage_RestingHeartRateHealthData()
}

func calculateAverage_HeartRateHealthData() {
    guard currentuser.userNormalRange?.heartRate != nil else {
        currentuser.userNormalRange?.heartRate = DataNormalRange()
        return
    }
    if !currentuser.userNormalRange!.heartRate!.isManual {
        var heartRate_average: Double = 0.0
        var heartRate_count: Int = 0
        for record in userHealthProfile.heartRate {
            let heartRateInBPM = record.quantity.doubleValue(for: HKUnit(from: "count/min"))
            heartRate_average += heartRateInBPM
            heartRate_count += 1
        }
        heartRate_average = heartRate_average / Double(heartRate_count)
        
        let realm = try! Realm()
        let user = realm.objects(User.self).filter("userID == \(currentuser.userID)").first
        try! realm.safeWrite {
            if !heartRate_average.isNaN && !heartRate_average.isInfinite {
                user!.userNormalRange?.heartRate?.weekdays_min = heartRate_average - 20
                user!.userNormalRange?.heartRate?.weekdays_max = heartRate_average + 20
            }
        }
    }
}

func calculateAverage_RestingHeartRateHealthData() {
    guard currentuser.userNormalRange?.restingHeartRate != nil else {
        currentuser.userNormalRange?.restingHeartRate = DataNormalRange()
        return
    }
    if !currentuser.userNormalRange!.restingHeartRate!.isManual {
        var restingHeartRate_average: Double = 0.0
        var restingHeartRate_count: Int = 0
        for record in userHealthProfile.restingHeartRate {
            let heartRateInBPM = record.quantity.doubleValue(for: HKUnit(from: "count/min"))
            restingHeartRate_average += heartRateInBPM
            restingHeartRate_count += 1
        }
        restingHeartRate_average = restingHeartRate_average / Double(restingHeartRate_count)
        
        let realm = try! Realm()
        let user = realm.objects(User.self).filter("userID == \(currentuser.userID)").first
        try! realm.safeWrite {
            if !restingHeartRate_average.isNaN && !restingHeartRate_average.isInfinite {
                user!.userNormalRange?.restingHeartRate?.weekdays_min = restingHeartRate_average - 20
                user!.userNormalRange?.restingHeartRate?.weekdays_max = restingHeartRate_average + 20
            }
        }
    }
}
    
    
// MARK: - calculateAverage_RespiratoryHealthData

func calculateAverage_RespiratoryHealthData() {
    guard currentuser.userNormalRange?.bloodOxygen != nil else {
        currentuser.userNormalRange?.bloodOxygen = DataNormalRange()
        return
    }
    if !currentuser.userNormalRange!.bloodOxygen!.isManual {
        var bloodOxygen_average: Double = 0.0
        var bloodOxygen_count: Int = 0
        
        for record in userHealthProfile.bloodOxygen {
            let percentage = record.quantity.doubleValue(for: .percent())
            bloodOxygen_average += percentage
            bloodOxygen_count += 1
        }
        bloodOxygen_average = bloodOxygen_average / Double(bloodOxygen_count)
        
        let realm = try! Realm()
        let user = realm.objects(User.self).filter("userID == \(currentuser.userID)").first
        try! realm.safeWrite {
            if !bloodOxygen_average.isNaN && !bloodOxygen_average.isInfinite {
                user!.userNormalRange?.bloodOxygen?.weekdays_min = bloodOxygen_average*100 - 3
                user!.userNormalRange?.bloodOxygen?.weekdays_max = bloodOxygen_average*100 + 3
            }
            
            if currentuser.userNormalRange!.bloodOxygen!.weekdays_min < 90 {
                user!.userNormalRange?.bloodOxygen?.weekdays_min = 90
            }
            if currentuser.userNormalRange!.bloodOxygen!.weekdays_max > 100 {
                user!.userNormalRange?.bloodOxygen?.weekdays_max = 100
            }
        }
    }
}


// MARK: - calculateAverage_MindfulnessHealthData

func calculateAverage_MindfulnessHealthData() {
    guard currentuser.userNormalRange?.mindfulMinutes != nil else {
        currentuser.userNormalRange?.mindfulMinutes = DataNormalRange()
        return
    }
    if !currentuser.userNormalRange!.mindfulMinutes!.isManual {
        var mindfulMinutes: Double = 0.0
        var tempDate = Date()
        var lastDate = Date()
        var tempDateList_weekends: [Double] = []
        var tempDateList_weekdays: [Double] = []
        var mindfulMinutes_weekends_average: Double = 0
        var mindfulMinutes_weekdays_average: Double = 0

        if let firstRecord = userHealthProfile.mindfulMinutes.first {
            tempDate = Calendar.current.startOfDay(for: firstRecord.endDate)
        }

        if let lastRecord = userHealthProfile.mindfulMinutes.last {
            lastDate = Calendar.current.startOfDay(for: lastRecord.endDate)
        }

        for record in userHealthProfile.mindfulMinutes {
            if Calendar.current.startOfDay(for: record.endDate) == tempDate && Calendar.current.startOfDay(for: record.endDate) != lastDate {
                mindfulMinutes += record.endDate.timeIntervalSince(record.startDate)/60
            } else {
                if Calendar.current.isDateInWeekend(tempDate) {
                    tempDateList_weekends.append(mindfulMinutes)
                } else {
                    tempDateList_weekdays.append(mindfulMinutes)
                }
                mindfulMinutes = record.endDate.timeIntervalSince(record.startDate)/60
                tempDate = Calendar.current.startOfDay(for: record.endDate)
            }
        }
        
        for record in tempDateList_weekends {
            mindfulMinutes_weekends_average += record
        }
        for record in tempDateList_weekdays {
            mindfulMinutes_weekdays_average += record
        }
        
        if tempDateList_weekends.count > 0 {
            mindfulMinutes_weekends_average = mindfulMinutes_weekends_average / Double(tempDateList_weekends.count)
        }
        if tempDateList_weekdays.count > 0 {
            mindfulMinutes_weekdays_average = mindfulMinutes_weekdays_average / Double(tempDateList_weekdays.count)
        }
        
        let realm = try! Realm()
        let user = realm.objects(User.self).filter("userID == \(currentuser.userID)").first
        try! realm.safeWrite {
            user!.userNormalRange?.mindfulMinutes?.weekends_min = mindfulMinutes_weekends_average - 10
            user!.userNormalRange?.mindfulMinutes?.weekends_max = mindfulMinutes_weekends_average + 10
            user!.userNormalRange?.mindfulMinutes?.weekdays_min = mindfulMinutes_weekdays_average - 10
            user!.userNormalRange?.mindfulMinutes?.weekdays_max = mindfulMinutes_weekdays_average + 10

            if currentuser.userNormalRange!.mindfulMinutes!.weekends_min < 3 {
                user!.userNormalRange?.mindfulMinutes?.weekends_min = 3
            }
            if currentuser.userNormalRange!.mindfulMinutes!.weekdays_min < 3 {
                user!.userNormalRange?.mindfulMinutes?.weekdays_min = 3
            }
        }
    }
}


// MARK: - calculateAverage_SleepHealthData

func calculateAverage_SleepHealthData() {
    guard currentuser.userNormalRange?.sleepHours != nil else {
        currentuser.userNormalRange?.sleepHours = DataNormalRange()
        return
    }
    if !currentuser.userNormalRange!.sleepHours!.isManual {
        var sleepHours: Double = 0
        var tempDate = Date()
        var lastDate = Date()
        var tempDateList_weekends: [Double] = []
        var tempDateList_weekdays: [Double] = []
        var sleepMinutes_weekends_average: Double = 0.0
        var sleepMinutes_weekdays_average: Double = 0.0

        if let firstRecord = userHealthProfile.sleepHours.first {
            tempDate = Calendar.current.startOfDay(for: firstRecord.endDate)
        }

        if let lastRecord = userHealthProfile.sleepHours.last {
            lastDate = Calendar.current.startOfDay(for: lastRecord.endDate)
        }

        for record in userHealthProfile.sleepHours {
            if Calendar.current.startOfDay(for: record.endDate) != lastDate {
                if Calendar.current.startOfDay(for: record.endDate) == tempDate {
                    sleepHours += Double(record.endDate.timeIntervalSince(record.startDate)/3600)
                } else {
                    if Calendar.current.isDateInWeekend(tempDate) {
                        tempDateList_weekends.append(sleepHours)
                    } else {
                        tempDateList_weekdays.append(sleepHours)
                    }
                    sleepHours = Double(record.endDate.timeIntervalSince(record.startDate)/3600)
                    tempDate = Calendar.current.startOfDay(for: record.endDate)
                }
            }
        }

        
        for record in tempDateList_weekends {
            sleepMinutes_weekends_average += record
        }
        for record in tempDateList_weekdays {
            sleepMinutes_weekdays_average += record
        }
        
        if tempDateList_weekends.count > 0 {
            sleepMinutes_weekends_average = sleepMinutes_weekends_average / Double(tempDateList_weekends.count)
        }
        if tempDateList_weekdays.count > 0 {
            sleepMinutes_weekdays_average = sleepMinutes_weekdays_average / Double(tempDateList_weekdays.count)
        }

        let realm = try! Realm()
        let user = realm.objects(User.self).filter("userID == \(currentuser.userID)").first
        try! realm.safeWrite {
            user!.userNormalRange?.sleepHours?.weekends_min = sleepMinutes_weekends_average - 1.5
            user!.userNormalRange?.sleepHours?.weekends_max = sleepMinutes_weekends_average + 1.5
            user!.userNormalRange?.sleepHours?.weekdays_min = sleepMinutes_weekdays_average - 1.5
            user!.userNormalRange?.sleepHours?.weekdays_max = sleepMinutes_weekdays_average + 1.5

            if currentuser.userNormalRange!.sleepHours!.weekends_min < 4.0 {
                user!.userNormalRange?.sleepHours?.weekends_min = 4.0
            }
            if currentuser.userNormalRange!.sleepHours!.weekdays_min < 4.0 {
                user!.userNormalRange?.sleepHours?.weekdays_min = 4.0
            }
        }
    }
}


// MARK: - UI Design

func globalContainerScheme() -> MDCContainerScheming {
    let containerScheme = MDCContainerScheme()
    containerScheme.colorScheme.primaryColor = .orange
    containerScheme.colorScheme.secondaryColor = .red
    return containerScheme
}

func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text

    label.sizeToFit()
    return label.frame.height
}



// MARK: - Notifications

func sendStressReminderNotifications() {
    if let latestRecord = currentuser.userStressIndexRecord?.records.last {
        let center = UNUserNotificationCenter.current()
        let stressReminderID = "stressReminderID"
        if latestRecord.stressIndex >= 8 {
            let content = UNMutableNotificationContent()
            content.title = "Stress Reminder"
            content.body = "You are estimated as high stress level recently. Let's have some relaxing time."
            content.sound = .default
            content.categoryIdentifier = "stressReminderIdentifier"

            // Setup trigger time
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60*30, repeats: false)

            // Create request
            let request = UNNotificationRequest(identifier: stressReminderID, content: content, trigger: trigger)
            center.add(request) { (error : Error?) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        } else {
            center.removePendingNotificationRequests(withIdentifiers: [stressReminderID])
        }
    }
}
