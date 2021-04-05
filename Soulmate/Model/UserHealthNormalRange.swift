//
//  UserHealthNormalRange.swift
//  Soulmate
//
//  Created by Will Lam on 6/3/2021.
//


import RealmSwift

class DataNormalRange: Object {
    @objc dynamic var isManual: Bool = false
    @objc dynamic var weekends_max: Double = 0.0
    @objc dynamic var weekends_min: Double = 0.0
    @objc dynamic var weekdays_max: Double = 0.0
    @objc dynamic var weekdays_min: Double = 0.0
}


class UserHealthNormalRange: Object {
    
    // Activity
    @objc dynamic var activeEnergy: DataNormalRange? = DataNormalRange()
    @objc dynamic var exerciseMinutes: DataNormalRange? = DataNormalRange()
    @objc dynamic var standMinutes: DataNormalRange? = DataNormalRange()
    @objc dynamic var steps: DataNormalRange? = DataNormalRange()
    @objc dynamic var walkingRunningDistance: DataNormalRange? = DataNormalRange()
    
    // Heart
    @objc dynamic var heartRate: DataNormalRange? = DataNormalRange()
    @objc dynamic var restingHeartRate: DataNormalRange? = DataNormalRange()

    // Respiratory
    @objc dynamic var bloodOxygen: DataNormalRange? = DataNormalRange()

    // Mindfulness
    @objc dynamic var mindfulMinutes: DataNormalRange? = DataNormalRange()

    // Sleep
    @objc dynamic var sleepHours: DataNormalRange? = DataNormalRange()
}
