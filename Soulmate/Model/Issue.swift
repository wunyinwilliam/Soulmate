//
//  Issue.swift
//  Soulmate
//
//  Created by Will Lam on 24/3/2021.
//


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
}
