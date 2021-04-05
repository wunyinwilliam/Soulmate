//
//  A4d_ExpressionStructureViewController.swift
//  Soulmate
//
//  Created by Will Lam on 30/3/2021.
//

import UIKit

class A4d_ExpressionStructureViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    // MARK: - Variables
    @IBOutlet weak var expressionTextView: UITextView!
    @IBOutlet weak var expressionTableView: UITableView!
    var expression: [NSMutableAttributedString] = []
    
    
    // MARK: - Actions
    @IBAction func pressed_AddButton(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Enter New Expression Structure Name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            var expression: [NSMutableAttributedString] = []
            expression.append(NSMutableAttributedString(string: answer.text!))
            expressionsList.append(expression)
            self.expressionTableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addAction(confirmAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
    
    @IBAction func pressed_PosNeg(_ sender: UIButton) {
        if let selectedRange = self.expressionTextView.selectedTextRange {
            let cursorPosition = self.expressionTextView.offset(from: self.expressionTextView.beginningOfDocument, to: selectedRange.start)
            let str = self.expressionTextView.text!
            let start = str.startIndex
            let mid = str.index(str.startIndex, offsetBy: cursorPosition)
            let end = str.endIndex
            
            let startString = str[start..<mid]
            let endString = str[mid..<end]
            let incString = "(positive/neutral/negative)"
            
            let newString = startString + incString + endString
            self.setupExpression(String(newString))
            self.updateExpression()
            
            if let newPosition = self.expressionTextView.position(from: self.expressionTextView.beginningOfDocument, offset: startString.count+incString.count) {
                self.expressionTextView.selectedTextRange = self.expressionTextView.textRange(from: newPosition, to: newPosition)
            }
        }
    }
    
    @IBAction func pressed_Emotions(_ sender: UIButton) {
        if let selectedRange = self.expressionTextView.selectedTextRange {
            let cursorPosition = self.expressionTextView.offset(from: self.expressionTextView.beginningOfDocument, to: selectedRange.start)
            let str = self.expressionTextView.text!
            let start = str.startIndex
            let mid = str.index(str.startIndex, offsetBy: cursorPosition)
            let end = str.endIndex
            
            let startString = str[start..<mid]
            let endString = str[mid..<end]
            let incString = "(emotions)"
            
            let newString = startString + incString + endString
            self.setupExpression(String(newString))
            self.updateExpression()
            
            if let newPosition = self.expressionTextView.position(from: self.expressionTextView.beginningOfDocument, offset: startString.count+incString.count) {
                self.expressionTextView.selectedTextRange = self.expressionTextView.textRange(from: newPosition, to: newPosition)
            }
        }
    }
    
    @IBAction func pressed_StressLevel(_ sender: UIButton) {
        if let selectedRange = self.expressionTextView.selectedTextRange {
            let cursorPosition = self.expressionTextView.offset(from: self.expressionTextView.beginningOfDocument, to: selectedRange.start)
            let str = self.expressionTextView.text!
            let start = str.startIndex
            let mid = str.index(str.startIndex, offsetBy: cursorPosition)
            let end = str.endIndex
            
            let startString = str[start..<mid]
            let endString = str[mid..<end]
            let incString = "(stress level)"
            
            let newString = startString + incString + endString
            self.setupExpression(String(newString))
            self.updateExpression()
            
            if let newPosition = self.expressionTextView.position(from: self.expressionTextView.beginningOfDocument, offset: startString.count+incString.count) {
                self.expressionTextView.selectedTextRange = self.expressionTextView.textRange(from: newPosition, to: newPosition)
            }
        }
    }
    
    @IBAction func pressed_Reasons(_ sender: UIButton) {
        if let selectedRange = self.expressionTextView.selectedTextRange {
            let cursorPosition = self.expressionTextView.offset(from: self.expressionTextView.beginningOfDocument, to: selectedRange.start)
            let str = self.expressionTextView.text!
            let start = str.startIndex
            let mid = str.index(str.startIndex, offsetBy: cursorPosition)
            let end = str.endIndex
            
            let startString = str[start..<mid]
            let endString = str[mid..<end]
            let incString = "(reasons)"
            
            let newString = startString + incString + endString
            self.setupExpression(String(newString))
            self.updateExpression()
            
            if let newPosition = self.expressionTextView.position(from: self.expressionTextView.beginningOfDocument, offset: startString.count+incString.count) {
                self.expressionTextView.selectedTextRange = self.expressionTextView.textRange(from: newPosition, to: newPosition)
            }
        }
    }
    
    @IBAction func pressed_Details(_ sender: UIButton) {
        if let selectedRange = self.expressionTextView.selectedTextRange {
            let cursorPosition = self.expressionTextView.offset(from: self.expressionTextView.beginningOfDocument, to: selectedRange.start)
            let str = self.expressionTextView.text!
            let start = str.startIndex
            let mid = str.index(str.startIndex, offsetBy: cursorPosition)
            let end = str.endIndex
            
            let startString = str[start..<mid]
            let endString = str[mid..<end]
            let incString = "(details)"
            
            let newString = startString + incString + endString
            self.setupExpression(String(newString))
            self.updateExpression()
            
            if let newPosition = self.expressionTextView.position(from: self.expressionTextView.beginningOfDocument, offset: startString.count+incString.count) {
                self.expressionTextView.selectedTextRange = self.expressionTextView.textRange(from: newPosition, to: newPosition)
            }
        }
    }
    
    @IBAction func pressed_Helps(_ sender: UIButton) {
        if let selectedRange = self.expressionTextView.selectedTextRange {
            let cursorPosition = self.expressionTextView.offset(from: self.expressionTextView.beginningOfDocument, to: selectedRange.start)
            let str = self.expressionTextView.text!
            let start = str.startIndex
            let mid = str.index(str.startIndex, offsetBy: cursorPosition)
            let end = str.endIndex
            
            let startString = str[start..<mid]
            let endString = str[mid..<end]
            let incString = "(helps)"
            
            let newString = startString + incString + endString
            self.setupExpression(String(newString))
            self.updateExpression()
            
            if let newPosition = self.expressionTextView.position(from: self.expressionTextView.beginningOfDocument, offset: startString.count+incString.count) {
                self.expressionTextView.selectedTextRange = self.expressionTextView.textRange(from: newPosition, to: newPosition)
            }
        }
    }
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.expressionTableView.delegate = self
        self.expressionTableView.dataSource = self
        self.navigationController?.delegate = self
        self.expressionTextView.delegate = self
        self.expressionTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        self.updateExpression()
    }
    
    
    // MARK: - Private Functions
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    private func setupExpression(_ str: String) {
        var newExpression: [NSMutableAttributedString] = [expression.first!]
        var subStr = ""
        for char in str {
            if char == "(" {
                newExpression.append(NSMutableAttributedString(string: subStr))
                subStr = ""
                subStr.append(char)
            } else if char == ")" {
                subStr.append(char)
                let exp = NSMutableAttributedString(string: subStr)
                exp.addAttribute(.backgroundColor, value: UIColor(hex: "#FEC89AFF")!, range: NSRange(location: 0, length: exp.string.count))
                newExpression.append(exp)
                subStr = ""
            } else {
                subStr.append(char)
            }
        }
        newExpression.append(NSMutableAttributedString(string: subStr))
        self.expression = newExpression
    }
    
    private func updateExpression() {
        let sentence = NSMutableAttributedString()
        for phrase in self.expression.dropFirst() {
            if phrase.string == "(positive/neutral/negative)" || phrase.string == "(emotions)" || phrase.string == "(stress level)" || phrase.string == "(reasons)" || phrase.string == "(details)" || phrase.string == "(helps)" {
                phrase.addAttribute(.backgroundColor, value: UIColor(hex: "#FEC89AFF")!, range: NSRange(location: 0, length: phrase.string.count))
            }
            phrase.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: NSRange(location: 0, length: phrase.string.count))
            sentence.append(phrase)
        }
        self.expressionTextView.attributedText = sentence
    }
    
    
    // MARK: - Text View Delegate
    
    func textViewDidChange(_ textView: UITextView) {
        self.setupExpression(textView.text)
        self.updateExpression()
    }
    
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expressionsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "A4dTableCell", for: indexPath)
        if let textLabel = cell.textLabel {
            textLabel.text = expressionsList[indexPath.row].first!.string
        } else {
            print("ERROR: There is no textLabel in the cell")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        expression = expressionsList[indexPath.row]
        self.updateExpression()
    }
}


// MARK: - Navigation

extension A4d_ExpressionStructureViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        (viewController as? A4_ExpressionsViewController)?.expression = expression
    }
}
