//
//  ViewController.swift
//  Soulmate
//
//  Created by Will Lam on 20/2/2021.
//

import RealmSwift
import UIKit
import MaterialComponents
import UserNotifications
import HealthKit


class L1_LoginPageViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    // MARK: - Variables

    let tf_email = MDCOutlinedTextField()
    let tf_password = MDCOutlinedTextField()
    let bn_login = MDCButton()
    let bn_signUp = MDCButton()
    let bn_forgetPassword = MDCButton()
    
    var userList = try! Realm().objects(User.self).sorted(byKeyPath: "name", ascending: true)
    
    
    // MARK: - Actions
    
    @objc func pressed_bn_login(_ sender: UIButton) -> Void {
        if authenticatedUser() {
            calculateAverage_AllHealthData()
            
            self.loggingIn()
        
            self.performSegue(withIdentifier: "loginSuccessfullySegue", sender: self)
        } else {
            showAlert(title: "Wrong email / password", msg: nil)
        }
    }
    
    @objc func pressed_bn_signUp(_ sender: UIButton) -> Void {
        self.performSegue(withIdentifier: "L1ToL2Segue", sender: self)
    }
    
    @objc func pressed_bn_forgetPassword(_ sender: UIButton) -> Void {
        print("pressed_bn_forgetPassword")
    }
    
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
                
        self.hideKeyboardWhenTappedAround()
        if userList.count == 0 {            // TO BE DELETED
            addNewUsers()                   // TO BE DELETED
        }                                   // TO BE DELETED
    }
    
    
    // MARK: - Private Functions
    
    private func setupUI() {
        tf_email.frame = CGRect(x: 60.0, y: 250.0, width: 255.0, height: 30.0)
        tf_email.center.x = self.view.center.x
        tf_email.label.text = "Email"
        tf_email.applyTheme(withScheme: globalContainerScheme())
        tf_email.text = "will@hku.hk"                               // TO BE DELETED
        tf_email.sizeToFit()
        self.view.addSubview(tf_email)
        
        tf_password.frame = CGRect(x: 60.0, y: 330.0, width: 255.0, height: 30.0)
        tf_password.center.x = self.view.center.x
        tf_password.label.text = "Password"
        tf_password.isSecureTextEntry = true
        tf_password.applyTheme(withScheme: globalContainerScheme())
        tf_password.text = "will"                                      // TO BE DELETED
        tf_password.sizeToFit()
        self.view.addSubview(tf_password)
    
        bn_login.frame = CGRect(x: 60.0, y: 420.0, width: 255.0, height: 50.0)
        bn_login.center.x = self.view.center.x
        bn_login.setTitle("Login", for: .normal)
        bn_login.applyContainedTheme(withScheme: globalContainerScheme())
        bn_login.addTarget(self, action: #selector(pressed_bn_login), for: .touchUpInside)
        self.view.addSubview(bn_login)
        
        bn_signUp.frame = CGRect(x: 60.0, y: 490.0, width: 255.0, height: 50.0)
        bn_signUp.center.x = self.view.center.x
        bn_signUp.setBorderWidth(2.0, for: .normal)
        bn_signUp.setTitle("Sign Up", for: .normal)
        bn_signUp.applyOutlinedTheme(withScheme: globalContainerScheme())
        bn_signUp.addTarget(self, action: #selector(pressed_bn_signUp), for: .touchUpInside)
        self.view.addSubview(bn_signUp)
        
        bn_forgetPassword.frame = CGRect(x: 60.0, y: 560.0, width: 200.0, height: 48.0)
        bn_forgetPassword.center.x = self.view.center.x
        bn_forgetPassword.setTitle("Forget Password", for: .normal)
        bn_forgetPassword.setTitleColor(.brown, for: .normal)
        bn_forgetPassword.setBackgroundColor(.clear)
        bn_forgetPassword.addTarget(self, action: #selector(pressed_bn_forgetPassword), for: .touchUpInside)
        self.view.addSubview(bn_forgetPassword)
    }
    
    
    private func authenticatedUser() -> Bool {
        let predicate = NSPredicate(format: "email = %@ AND password = %@", tf_email.text!, tf_password.text!)
        let user = try! Realm().objects(User.self).filter(predicate)
        
        if user.count == 1 {
            currentuser = user[0]
            return true
        } else {
            return false
        }
    }
    
    
    private func loggingIn() {
        let realm = try! Realm()
        let login_results = realm.objects(Login.self)
        if login_results.count == 0 {
            try! realm.write {
                let login = Login()
                login.isLogin = true
                realm.add(login)
            }
        }
        let current_login = login_results.first
        try! realm.write {
            current_login!.isLogin = true
        }
    }
    
    
    private func showAlert(title: String, msg: String?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        self.present(alert, animated: true)
    }
    
    
    // MARK: - TO BE DELETED
    // Add Default Users to Database
    private func addNewUsers() {
        print("addNewUsers")
        let realm = try! Realm()
    
        try! realm.write {
            let newUser = User()

            newUser.userID = 0
            newUser.name = "Will"
            newUser.email = "will@hku.hk"
            newUser.password = "will"

            realm.add(newUser)
        }
    }
}




extension L1_LoginPageViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(L1_LoginPageViewController.dismissKeyboard1))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard1() {
        view.endEditing(true)
    }
}
