//
//  I1_InformationTableViewController.swift
//  Soulmate
//
//  Created by Will Lam on 2/3/2021.
//

import UIKit

class I1_InformationTableViewController: UITableViewController {

    // MARK: - Variables
    

    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "INFORMATION"
        navigationController?.title = "Information"
        
        self.setupUserIconButton()
        self.setupUI()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
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
        lb_logo_soulmate.frame = CGRect(x: 10.0, y: -96.0, width: 100.0, height: 50.0)
        lb_logo_soulmate.center.x = self.view.center.x
        
        self.view.addSubview(lb_logo_soulmate)
    }

}
