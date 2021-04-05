//
//  A4c_DetailsViewController.swift
//  Soulmate
//
//  Created by Will Lam on 25/3/2021.
//

import UIKit

class A4c_DetailsViewController: UIViewController {

    // MARK: - Variables
    @IBOutlet weak var detailsTextView: UITextView!
    var text: String = ""
    
    
    // MARK: - Actions
    @IBAction func pressed_DoneButton(_ sender: UIBarButtonItem) {
        self.detailsTextView.endEditing(true)
    }
    
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.delegate = self
        detailsTextView.text = self.text
    }

}


// MARK: - Navigation

extension A4c_DetailsViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        (viewController as? A4_ExpressionsViewController)?.details = self.detailsTextView.text
    }
}
