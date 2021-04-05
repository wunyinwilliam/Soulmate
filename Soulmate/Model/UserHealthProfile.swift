//
//  UserHealthProfile.swift
//  HealthView
//
//  Created by Will Lam on 8/2/2021.
//

import HealthKit

class UserHealthProfile {
    
    // User Information
    var age: Int = 0
    
    // Activity
    var activeEnergy: [HKStatistics] = []
    var exerciseMinutes: [HKStatistics] = []
    var standMinutes: [HKStatistics] = []
    var steps: [HKStatistics] = []
    var walkingRunningDistance: [HKStatistics] = []
    
    // Heart
    var heartRate: [HKQuantitySample] = []
    var restingHeartRate: [HKQuantitySample] = []

    // Respiratory
    var bloodOxygen: [HKQuantitySample] = []
    
    // Mindfulness
    var mindfulMinutes: [HKCategorySample] = []
    
    // Sleep
    var sleepHours: [HKCategorySample] = []
}
