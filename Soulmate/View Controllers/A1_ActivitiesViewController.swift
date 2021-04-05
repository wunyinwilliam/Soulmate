//
//  A1_ActivitiesViewController.swift
//  Soulmate
//
//  Created by Will Lam on 2/3/2021.
//

import UIKit

class A1_ActivitiesViewController: UIViewController {
    
    // MARK: - Variables
    @IBOutlet weak var relaxingTipsView: UIView!
    @IBOutlet weak var goalsView: UIView!
    @IBOutlet weak var expressionView: UIView!
    @IBOutlet weak var activitiesView: UIView!
    @IBOutlet weak var consultationView: UIView!
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    
    
    // MARK: - Actions
    
    @IBAction func pressed_leftButton(_ sender: UIButton) {
        print("LEFT")
    }
    
    @IBAction func pressed_rightButton(_ sender: UIButton) {
        print("RIGHT")
    }
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "ACTIVITIES"
        navigationController?.title = "Activities"
        
        self.setupUserIconButton()
        self.setupUI()
        self.addGestureRecognizer()
    }
    
    
    // MARK: - Private Functions

    private func setupUserIconButton() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "S1Nav") as! UINavigationController
        let userIconButton = UIButton(primaryAction: UIAction(title: "", handler: { _ in
            self.present(vc, animated: true, completion: nil)
        }))
        userIconButton.setBackgroundImage(UIImage(named: "Person"), for: .normal)
        
        let segmentBarItem = UIBarButtonItem(customView: userIconButton)
        // Add constraints to the bar buttion item
        let currWidth = segmentBarItem.customView?.widthAnchor.constraint(equalToConstant: 40)
        currWidth?.isActive = true
        let currHeight = segmentBarItem.customView?.heightAnchor.constraint(equalToConstant: 40)
        currHeight?.isActive = true
        navigationItem.rightBarButtonItem = segmentBarItem
    }
    
    
    private func setupUI() {
        let lb_logo_soulmate = UILabel()
        lb_logo_soulmate.text = "Soulmate"
        lb_logo_soulmate.font = UIFont(name: "American Typewriter Bold", size: 18.0)
        lb_logo_soulmate.textAlignment = .center
        lb_logo_soulmate.textColor = UIColor(hex: "#FF9587FF")
        lb_logo_soulmate.frame = CGRect(x: 10.0, y: 20.0, width: 100.0, height: 50.0)
        lb_logo_soulmate.center.x = self.view.center.x
        self.view.addSubview(lb_logo_soulmate)
        
        for view in [relaxingTipsView, goalsView, expressionView, activitiesView, consultationView] {
            view?.layer.borderWidth = 1.0
            view?.layer.borderColor = UIColor.systemPink.cgColor
            view?.layer.cornerRadius = 5.0
        }
    }


    private func addGestureRecognizer() {
        let tap_relaxingTips = UILongPressGestureRecognizer(target: self, action: #selector(self.didTapView_relaxingTips(_:)))
        tap_relaxingTips.minimumPressDuration = 0.01
        self.relaxingTipsView.addGestureRecognizer(tap_relaxingTips)

        let tap_goals = UILongPressGestureRecognizer(target: self, action: #selector(self.didTapView_goals(_:)))
        tap_goals.minimumPressDuration = 0.01
        self.goalsView.addGestureRecognizer(tap_goals)

        let tap_expressions = UILongPressGestureRecognizer(target: self, action: #selector(self.didTapView_expressions(_:)))
        tap_expressions.minimumPressDuration = 0.01
        self.expressionView.addGestureRecognizer(tap_expressions)

        let tap_activities = UILongPressGestureRecognizer(target: self, action: #selector(self.didTapView_activities(_:)))
        tap_activities.minimumPressDuration = 0.01
        self.activitiesView.addGestureRecognizer(tap_activities)

        let tap_consultation = UILongPressGestureRecognizer(target: self, action: #selector(self.didTapView_consultation(_:)))
        tap_consultation.minimumPressDuration = 0.01
        self.consultationView.addGestureRecognizer(tap_consultation)
    }
    
    @objc func didTapView_relaxingTips(_ sender: UITapGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            sender.view?.backgroundColor = UIColor(hex: "#FFB5A7FF")
        } else if sender.state == .ended {
            self.performSegue(withIdentifier: "A1ToA2Segue", sender: self)
            sender.view?.backgroundColor = UIColor(hex: "#FCD5CEFF")
        }
    }
    
    @objc func didTapView_goals(_ sender: UITapGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            sender.view?.backgroundColor = UIColor(hex: "#FFB5A7FF")
        } else if sender.state == .ended {
            self.performSegue(withIdentifier: "A1ToA3Segue", sender: self)
            sender.view?.backgroundColor = UIColor(hex: "#FCD5CEFF")
        }
    }
    
    @objc func didTapView_expressions(_ sender: UITapGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            sender.view?.backgroundColor = UIColor(hex: "#FFB5A7FF")
        } else if sender.state == .ended {
            self.performSegue(withIdentifier: "A1ToA4Segue", sender: self)
            sender.view?.backgroundColor = UIColor(hex: "#FCD5CEFF")
        }
    }
    
    @objc func didTapView_activities(_ sender: UITapGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            sender.view?.backgroundColor = UIColor(hex: "#FFB5A7FF")
        } else if sender.state == .ended {
            self.performSegue(withIdentifier: "A1ToA5Segue", sender: self)
            sender.view?.backgroundColor = UIColor(hex: "#FCD5CEFF")
        }
    }
    
    @objc func didTapView_consultation(_ sender: UITapGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            sender.view?.backgroundColor = UIColor(hex: "#FFB5A7FF")
        } else if sender.state == .ended {
            self.performSegue(withIdentifier: "A1ToA6Segue", sender: self)
            sender.view?.backgroundColor = UIColor(hex: "#FCD5CEFF")
        }
    }
    
}
