//
//  A4_ExpressionsViewController.swift
//  Soulmate
//
//  Created by Will Lam on 24/3/2021.
//

import UIKit

class A4_ExpressionsViewController: UIViewController {

    // MARK: - Variables
    @IBOutlet weak var bn_ExpressionStructure: UIButton!
    @IBOutlet weak var segCon_PosNeg: UISegmentedControl!
    @IBOutlet weak var bn_Emotions: UIButton!
    @IBOutlet weak var slider_StressLevel: UISlider!
    @IBOutlet weak var bn_Reasons: UIButton!
    @IBOutlet weak var bn_Details: UIButton!
    @IBOutlet weak var bn_Helps: UIButton!
    @IBOutlet weak var lb_expression: UILabel!
    
    var tapView = 0
    var positive_negative = currentIssue.positive_negative
    var emotions = currentIssue.emotions
    var stressLevel = String(currentIssue.stressLevel)
    var reasons = currentIssue.reasons
    var details = currentIssue.details
    var helps = currentIssue.helps
    var expression = expressionsList.randomElement()!
    
    var sentence = NSMutableAttributedString()
    
    
    // MARK: - Actions
    @IBAction func pressed_bn_ExpressionStructure(_ sender: UIButton) {
        self.performSegue(withIdentifier: "A4ToA4dSegue", sender: self)
    }
    
    @IBAction func changed_PosNeg(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.positive_negative = "positive"
        case 1:
            self.positive_negative = "neutral"
        default:
            self.positive_negative = "negative"
        }
        self.setupExpression()
    }
    
    @IBAction func pressed_bn_Emotions(_ sender: UIButton) {
        self.tapView = 0
        self.performSegue(withIdentifier: "A4ToA4bSegue", sender: self)
    }
    
    @IBAction func slider_StressLevel(_ sender: UISlider) {
        self.stressLevel = String(Int(sender.value))
        self.setupExpression()
    }
    
    @IBAction func pressed_bn_Reasons(_ sender: UIButton) {
        self.tapView = 1
        self.performSegue(withIdentifier: "A4ToA4bSegue", sender: self)
    }
    
    @IBAction func pressed_bn_Details(_ sender: UIButton) {
        self.performSegue(withIdentifier: "A4ToA4cSegue", sender: self)
    }
    
    @IBAction func pressed_bn_Helps(_ sender: UIButton) {
        self.tapView = 2
        self.performSegue(withIdentifier: "A4ToA4bSegue", sender: self)
    }
    
    @IBAction func pressed_bn_Share(_ sender: UIBarButtonItem) {
        let msg = sentence.string
        print(msg)
        let urlWhats = "whatsapp://send?text=\(msg)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL) {
                    UIApplication.shared.open(whatsappURL, options: .init(), completionHandler: nil)
                } else {
                    print("ERROR: Cannot open whatsapp")
                }
            }
        }
    }
    

    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLoadingIndicator()
    }
    
    
    // MARK: - ViewDidAppear
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        self.setupComponents()
        self.setupExpression()
        self.loadingIndicator.isAnimating = true
        self.view.isUserInteractionEnabled = false
        self.view.mask = UIView(frame: self.view.frame)
        self.view.mask?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadingIndicator.isAnimating = false
            self.view.isUserInteractionEnabled = true
            self.view.mask = nil
        }
    }
    
    
    // MARK: - Private Functions
    
    private func setupComponents() {
        self.bn_ExpressionStructure.setTitle(expression.first!.string, for: .normal)
        switch self.positive_negative {
        case "positive":
            self.segCon_PosNeg.selectedSegmentIndex = 0
        case "neutral":
            self.segCon_PosNeg.selectedSegmentIndex = 1
        default:
            self.segCon_PosNeg.selectedSegmentIndex = 2
        }
        self.slider_StressLevel.value = Float(self.stressLevel)!
        self.bn_Emotions.setTitle(emotions.sentence, for: .normal)
        self.bn_Emotions.titleLabel?.numberOfLines = 0
        self.bn_Reasons.setTitle(reasons.sentence, for: .normal)
        self.bn_Reasons.titleLabel?.numberOfLines = 0
        self.bn_Details.setTitle(details, for: .normal)
        self.bn_Details.titleLabel?.numberOfLines = 0
        self.bn_Helps.setTitle(helps.sentence, for: .normal)
        self.bn_Helps.titleLabel?.numberOfLines = 0
    }
    
    
    private func setupExpression() {
        self.sentence = NSMutableAttributedString()

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .backgroundColor: UIColor(hex: "#FEC89AFF")!,
        ]
            
        let attrString_positive_negative = NSMutableAttributedString(string: positive_negative, attributes: attributes)
        let attrString_emotions = NSMutableAttributedString(string: emotions.sentence, attributes: attributes)
        let attrString_stressLevel = NSMutableAttributedString(string: stressLevel, attributes: attributes)
        let attrString_reasons = NSMutableAttributedString(string: reasons.sentence, attributes: attributes)
        let attrString_details = NSMutableAttributedString(string: details, attributes: attributes)
        let attrString_helps = NSMutableAttributedString(string: helps.sentence, attributes: attributes)
        
        for phrase in expression.dropFirst() {
            if phrase.string == "(positive/neutral/negative)" {
                sentence.append(attrString_positive_negative)
            } else if phrase.string == "(emotions)" {
                sentence.append(attrString_emotions)
            } else if phrase.string == "(stress level)" {
                sentence.append(attrString_stressLevel)
            } else if phrase.string == "(reasons)" {
                sentence.append(attrString_reasons)
            } else if phrase.string == "(details)" {
                sentence.append(attrString_details)
            } else if phrase.string == "(helps)" {
                sentence.append(attrString_helps)
            } else {
                sentence.append(phrase)
            }
        }
        
        self.lb_expression.attributedText = sentence
    }
    
    
    // MARK: - Navigations
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "A4ToA4bSegue" {
            let target = segue.destination as! A4b_ExpressionsDetailsTableViewController
            switch tapView {
            case 0:
                target.title = "Emotions"
                target.navigationController?.title = "Emotions"
                target.selectItems = self.emotions
            case 1:
                target.title = "Reasons"
                target.navigationController?.title = "Reasons"
                target.selectItems = self.reasons
            default:
                target.title = "Helps"
                target.navigationController?.title = "Helps"
                target.selectItems = self.helps
            }
        } else if segue.identifier == "A4ToA4cSegue" {
            let target = segue.destination as! A4c_DetailsViewController
            target.text = self.details
        } else if segue.identifier == "A4ToA4dSegue" {
            let target = segue.destination as! A4d_ExpressionStructureViewController
            target.expression = self.expression
        }
    }

    
    // MARK: - setupLoadingIndicator
    private func setupLoadingIndicator() {
        overrideUserInterfaceStyle = .light
        self.view.backgroundColor = .white
        self.view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: self.view.centerXAnchor),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: self.view.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 50),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }
    
    // MARK: - Properties
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.red, .green, .blue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
}
