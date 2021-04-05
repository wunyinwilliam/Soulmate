//
//  ProfileDataStore.swift
//  HealthView
//
//  Created by Will Lam on 8/2/2021.
//

import HealthKit

class ProfileDataStore {

    
    class func getAge() throws -> Int {
        let healthKitStore = HKHealthStore()
        do {
            // This method throws an error if these data are not available.
            let birthdayComponents =  try healthKitStore.dateOfBirthComponents()

            // Use Calendar to calculate age.
            let today = Date()
            let calendar = Calendar.current
            let todayDateComponents = calendar.dateComponents([.year],
            from: today)
            let thisYear = todayDateComponents.year!
            let age = thisYear - birthdayComponents.year!

            return age
        }
    }
  
    
    class func getMostRecentSample(noOfSamples: Int?,
                                   noOfDays: Int?,
                                   for sampleType: HKSampleType,
                                   completion: @escaping ([HKQuantitySample]?, Error?) -> Swift.Void) {
        var startDate = Date.distantPast
        if let noOfDays = noOfDays {
            startDate = Date().addingTimeInterval(-1.0 * 60.0 * 60.0 * 24.0 * Double(noOfDays))
        }
        let precidate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: Date(),
                                                    options: .strictEndDate)
        var limit = 0
        if let noOfSamples = noOfSamples {
            limit = noOfSamples
        }
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                              ascending: false)

        let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                        predicate: precidate,
                                        limit: limit,
                                        sortDescriptors: [sortDescriptor]) {
            (query, samples, error) in
            DispatchQueue.main.async {
                guard let samples = samples as? [HKQuantitySample] else {
                    completion(nil, error)
                    return
                }
                completion(samples, nil)
            }
        }
        HKHealthStore().execute(sampleQuery)
    }
    
    
    class func getMostRecentAccumulateSample(noOfDays: Int?,
                                             for sampleType: HKQuantityType,
                                             completion: @escaping ([HKStatistics]?, Error?) -> Swift.Void) {
        var startDate = Date.distantPast
        if let noOfDays = noOfDays {
            startDate = Calendar.current.startOfDay(for: Date()).addingTimeInterval(-1.0 * 60.0 * 60.0 * 24.0 * Double(noOfDays))
        }
        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: Date(),
                                                    options: .strictEndDate)
        let anchorDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        var interval = DateComponents()
        interval.day = 1
        let sampleQuery = HKStatisticsCollectionQuery.init(quantityType: sampleType,
                                                           quantitySamplePredicate: predicate,
                                                           options: .cumulativeSum,
                                                           anchorDate: anchorDate!,
                                                           intervalComponents: interval)
        sampleQuery.initialResultsHandler = {
            (query, samples, error) in
            guard let samples = samples else {
                completion(nil, error)
                return
            }
            var sampleList: [HKStatistics] = []
            
            samples.enumerateStatistics(from: startDate,
                                        to: Date(),
                                        with: { (sample, error) in
                                            sampleList.append(sample)
                                        })
            completion(sampleList, nil)
        }
        HKHealthStore().execute(sampleQuery)
    }
    
    
    class func getMostRecentCategoryTypeSample(noOfSamples: Int?,
                                               noOfDays: Int?,
                                               for sampleType: HKSampleType,
                                               completion: @escaping ([HKCategorySample]?, Error?) -> Swift.Void) {
        var startDate = Date.distantPast
        if let noOfDays = noOfDays {
            startDate = Calendar.current.startOfDay(for: Date()).addingTimeInterval(-1.0 * 60.0 * 60.0 * 24.0 * Double(noOfDays))
        }
        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: Date(),
                                                    options: .strictEndDate)
        var limit = 0
        if let noOfSamples = noOfSamples {
            limit = noOfSamples
        }
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
                                              ascending: false)
        let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                        predicate: predicate,
                                        limit: limit,
                                        sortDescriptors: [sortDescriptor]) {
            (query, samples, error) in
            DispatchQueue.main.async {
                guard let samples = samples as? [HKCategorySample] else {
                    completion (nil, error)
                    return
                }
                var sampleList: [HKCategorySample] = []
                for sample in samples {
                    if sample.categoryType == HKSampleType.categoryType(forIdentifier: .sleepAnalysis) {
                        if sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue {
                            sampleList.append(sample)
                        }
                    } else {
                        sampleList.append(sample)
                    }
                }
                completion(sampleList, nil)
            }
        }
        HKHealthStore().execute(sampleQuery)
    }
}
