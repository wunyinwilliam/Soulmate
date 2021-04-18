//
//  globalVariables.swift
//  Soulmate
//
//  Created by Will Lam on 8/3/2021.
//

import Foundation

let defaultNoOfSamples: Int = 1000
let defaultNoOfDays: Int = 100

var currentuser = User()
var userHealthProfile = UserHealthProfile()

var positiveNeutralNegativeList = ["positive", "neutral", "negative"]
var emotionsList = ["happy", "sad", "angry", "worried", "calm", "satisfied", "confident", "bored", "stressful"]
var reasonsList = ["health", "family", "work", "friendship", "relationship", "personal growth", "society", "finance"]
var helpsList = ["do acts of service", "say encouraging words", "send me a gift", "listen to my feelings", "spend time with me", "pray with me", "express love & gratitude", "frequently find me"]

var currentIssue = Issue(positive_negative: positiveNeutralNegativeList.randomElement()!, emotions: [emotionsList.randomElement()!], stressLevel: 7, reasons: [reasonsList.randomElement()!], details: "my final year project deadline is near", helps: [helpsList.randomElement()!])

var expressionsList: [[NSMutableAttributedString]] = [
    [
        NSMutableAttributedString(string: "Expression Structure 1"),
        NSMutableAttributedString(string: "Hi, recently I have some "),
        NSMutableAttributedString(string: "(positive/neutral/negative)"),
        NSMutableAttributedString(string: " emotions. These emotions are "),
        NSMutableAttributedString(string: "(emotions)"),
        NSMutableAttributedString(string: ". My stress level is estimated as "),
        NSMutableAttributedString(string: "(stress level)"),
        NSMutableAttributedString(string: ". The appearance of the emotions are due to "),
        NSMutableAttributedString(string: "(reasons)"),
        NSMutableAttributedString(string: ". I can tell you some details that "),
        NSMutableAttributedString(string: "(details)"),
        NSMutableAttributedString(string: ". I hope you can "),
        NSMutableAttributedString(string: "(helps)"),
        NSMutableAttributedString(string: ". Thank you, my friend.")
    ],
    [
        NSMutableAttributedString(string: "Expression Structure 2"),
        NSMutableAttributedString(string: "My stress level is "),
        NSMutableAttributedString(string: "(stress level)"),
        NSMutableAttributedString(string: " recently. I feel "),
        NSMutableAttributedString(string: "(emotions)"),
        NSMutableAttributedString(string: ", because of "),
        NSMutableAttributedString(string: "(reasons)"),
        NSMutableAttributedString(string: ". "),
        NSMutableAttributedString(string: "(details)"),
        NSMutableAttributedString(string: ". If you don't mind, can you "),
        NSMutableAttributedString(string: "(helps)"),
        NSMutableAttributedString(string: "? Thank you, my friend.")
    ],
    [
        NSMutableAttributedString(string: "Expression Structure 3"),
        NSMutableAttributedString(string: "Hello my love, "),
        NSMutableAttributedString(string: "(details)"),
        NSMutableAttributedString(string: ". It makes me feel "),
        NSMutableAttributedString(string: "(emotions)"),
        NSMutableAttributedString(string: ". My stress level is "),
        NSMutableAttributedString(string: "(stress level)"),
        NSMutableAttributedString(string: " recently. Can you "),
        NSMutableAttributedString(string: "(helps)"),
        NSMutableAttributedString(string: "? Thank you.")
    ]
]

var quotesList = [
    """
    ”The best and most beautiful things in the world cannot be seen or even touched - they must be felt with the heart.”
    --- Helen Keller
    """,
    """
    ”Don’t limit yourself. Many people limit themselves to what they think they can do. You can go as far as your mind lets you. What you believe, remember, you can achieve.”
    --- Mary Kay Ash
    """,
    """
    ”It’s no use going back to yesterday, because I was a different person then.”
    --- Lewis Carroll
    """,
    """
    “When you want something, all the universe conspires in helping you to achieve it.”
    --- Paulo Coelho, <The Alchemist>
    """,
    """
    ”You have brains in your head. You have feet in your shoes. You can steer yourself any direction you choose. You’re on your own. And you know what you know. And YOU are the one who’ll decide where to go…”
    --- Dr. Seuss, <Oh, the Places You’ll Go!>
    """,
    """
    “You’ll have bad times, but it’ll always wake you up to the good stuff you weren’t paying attention to.”
    --– Good Will Hunting
    """,
    """
    “Opportunity does not knock, it presents itself when you beat down the door.”
    --- Kyle Chandler
    """,
    """
    “I've learned that people will forget what you said, people will forget what you did, but people will never forget how you made them feel.”
    --- Maya Angelou
    """,
    """
    “If you can't fly then run, if you can't run then walk, if you can't walk then crawl, but whatever you do, you have to keep moving forward.“
    --- Martin Luther King Jr.
    """,
    """
    “Do not give way to useless alarm; though it is right to be prepared for the worst, there is no occasion to look on it as certain.“
    --- Jane Austen, <Pride and Prejudice>
    """,
    
]
