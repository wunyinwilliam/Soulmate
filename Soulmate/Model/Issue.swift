//
//  Issue.swift
//  Soulmate
//
//  Created by Will Lam on 24/3/2021.
//

import Firebase

class Issue {
    var positive_negative: String
    var emotions: [String] = []
    var stressLevel: Int = 5
    var reasons: [String] = []
    var details: String = ""
    var helps: [String] = []
    
    init(positive_negative: String, emotions: [String], stressLevel: Int, reasons: [String], details: String, helps: [String]) {
        self.positive_negative = positive_negative
        self.emotions = emotions
        self.stressLevel = stressLevel
        self.reasons = reasons
        self.details = details
        self.helps = helps
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: AnyObject] else {
            return nil
        }
        let positive_negative = value["positive_negative"] as? String
        let emotions = value["emotions"] as? String
        let stressLevel = value["stressLevel"] as? Int
        let reasons = value["reasons"] as? String
        let details = value["details"] as? String
        let helps = value["helps"] as? String
        
        self.positive_negative = positive_negative ?? "neutral"
        if emotions != nil {
            self.emotions = [emotions!]
        } else {
            self.emotions = []
        }
        self.stressLevel = stressLevel ?? 5
        if reasons != nil {
            self.reasons = [reasons!]
        } else {
            self.reasons = []
        }
        self.details = details ?? ""
        if helps != nil {
            self.helps = [helps!]
        } else {
            self.helps = []
        }
    }
}
