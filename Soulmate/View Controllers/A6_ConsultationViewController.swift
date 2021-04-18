//
//  A6_ConsultationViewController.swift
//  Soulmate
//
//  Created by Will Lam on 24/3/2021.
//

import UIKit
import FirebaseDatabase

class A6_ConsultationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let ref = Database.database().reference()
        ref.observe(.value, with: { snapshot in
          print(snapshot.value as Any)
        })
        
        ref.observe(.value, with: { snapshot in
          var newIssue: [Issue] = []
            if let groceryItem = Issue(snapshot: snapshot) {
                newIssue.append(groceryItem)
            }
            print(newIssue)
            print(newIssue[0].emotions)
            print(newIssue[0].reasons)
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
