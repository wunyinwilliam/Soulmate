//
//  A5_ActivitiesViewController.swift
//  Soulmate
//
//  Created by Will Lam on 24/3/2021.
//

import UIKit

class A5_ActivitiesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let center = UNUserNotificationCenter.current()
        print(" ******* PENDING NOTIFICATIONS *******")
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(request)
            }
        })
        // Do any additional setup after loading the view.
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
