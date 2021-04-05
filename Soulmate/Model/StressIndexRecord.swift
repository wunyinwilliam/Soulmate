//
//  StressIndexRecord.swift
//  Soulmate
//
//  Created by Will Lam on 13/3/2021.
//

import RealmSwift

class StressIndexRecord: Object {
    let records = List<StressIndexRecordObject>()
}

class StressIndexRecordObject: Object {
    @objc dynamic var date: Date = Date()
    @objc dynamic var stressIndex: Int = 5
    
    // Activities
    @objc dynamic var activeEnergy: Double = -1.0
        
    // Heart
    @objc dynamic var heartRate: Double = -1.0
        
    // Mindfulness
    @objc dynamic var mindfulMinutes: Double = -1.0
        
    // Sleep
    @objc dynamic var sleepHours: Double = -1.0
}
