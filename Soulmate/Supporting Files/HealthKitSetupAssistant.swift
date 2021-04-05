//
//  HealthKitSetupAssistant.swift
//  HealthView
//
//  Created by Will Lam on 8/2/2021.
//

import HealthKit

class HealthKitSetupAssistant {
  
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
  
    class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {

        // Check to see if HealthKit Is Available on this device
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }
        
        // User Information Variables
        guard let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
              let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
              
              // Activity Variables
              let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
              let exerciseMinutes = HKObjectType.quantityType(forIdentifier: .appleExerciseTime),
              let standMinutes = HKObjectType.quantityType(forIdentifier: .appleStandTime),
              let steps = HKObjectType.quantityType(forIdentifier: .stepCount),
              let walkingRunningDistance = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
              
              // Heart Variables
              let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate),
              let restingHeartRate = HKObjectType.quantityType(forIdentifier: .restingHeartRate),
              let walkingHeartRateAverage = HKObjectType.quantityType(forIdentifier: .walkingHeartRateAverage),
              let cardioFitness = HKObjectType.quantityType(forIdentifier: .vo2Max),
              
              // Respiratory Variable
              let bloodOxygen = HKObjectType.quantityType(forIdentifier: .oxygenSaturation),
              
              // Mindfulness Variable
              let mindfulMinutes = HKObjectType.categoryType(forIdentifier: .mindfulSession),
              
              // Sleep Variable
              let sleepMinutes = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)
        else {
            completion(false, HealthkitSetupError.dataTypeNotAvailable)
            return
        }

        // Prepare a list of types you want HealthKit to read and write
        let healthKitTypesToWrite: Set<HKSampleType> = [mindfulMinutes,
                                                        HKObjectType.workoutType()]

        let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth,
                                                       biologicalSex,
                                                       activeEnergy,
                                                       exerciseMinutes,
                                                       standMinutes,
                                                       steps,
                                                       walkingRunningDistance,
                                                       heartRate,
                                                       restingHeartRate,
                                                       walkingHeartRateAverage,
                                                       cardioFitness,
                                                       bloodOxygen,
                                                       mindfulMinutes,
                                                       sleepMinutes,
                                                       HKObjectType.workoutType()]

        // Request Authorization
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
                                             read: healthKitTypesToRead) { (success, error) in
            completion(success, error)
        }
    }
}
