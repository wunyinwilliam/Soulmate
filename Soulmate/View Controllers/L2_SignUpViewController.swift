//
//  L2_SignUpViewController.swift
//  Soulmate
//
//  Created by Will Lam on 22/2/2021.
//

import UIKit
import RealmSwift
import MaterialComponents


class L2_SignUpViewController: UIViewController {

    // MARK: - Variables
    
//    @IBOutlet weak var tf_name: UITextField!
//    @IBOutlet weak var tf_email: UITextField!
//    @IBOutlet weak var tf_password: UITextField!
//    @IBOutlet weak var tf_confirmPassword: UITextField!
    
    let tf_name = MDCOutlinedTextField()
    let tf_email = MDCOutlinedTextField()
    let tf_password = MDCOutlinedTextField()
    let tf_confirmPassword = MDCOutlinedTextField()
    
    
    // MARK: - Actions
    
    @IBAction func pressed_bn_cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressed_bn_save(_ sender: UIBarButtonItem) {
        if validatedInfo() {
            addNewUsers()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.hideKeyboardWhenTappedAround()
    }
    
    
    // MARK: - Private Functions
    private func setupUI() {
        let y_distance = 20.0
        
        tf_name.frame = CGRect(x: 60.0, y: 180.0, width: 255.0, height: 30.0)
        tf_name.center.x = self.view.center.x
        tf_name.label.text = "Name"
        tf_name.applyTheme(withScheme: globalContainerScheme())
        tf_name.sizeToFit()
        self.view.addSubview(tf_name)
        
        tf_email.frame = CGRect(x: 60.0, y: Double(tf_name.frame.maxY)+y_distance, width: 255.0, height: 30.0)
        tf_email.center.x = self.view.center.x
        tf_email.label.text = "Email"
        tf_email.applyTheme(withScheme: globalContainerScheme())
        tf_email.sizeToFit()
        self.view.addSubview(tf_email)
        
        tf_password.frame = CGRect(x: 60.0, y: Double(tf_email.frame.maxY)+y_distance, width: 255.0, height: 30.0)
        tf_password.center.x = self.view.center.x
        tf_password.label.text = "Password"
        tf_password.applyTheme(withScheme: globalContainerScheme())
        tf_password.isSecureTextEntry = true
        tf_password.sizeToFit()
        self.view.addSubview(tf_password)
        
        tf_confirmPassword.frame = CGRect(x: 60.0, y: Double(tf_password.frame.maxY)+y_distance, width: 255.0, height: 30.0)
        tf_confirmPassword.center.x = self.view.center.x
        tf_confirmPassword.label.text = "Re-enter Password"
        tf_confirmPassword.applyTheme(withScheme: globalContainerScheme())
        tf_confirmPassword.isSecureTextEntry = true
        tf_confirmPassword.sizeToFit()
        self.view.addSubview(tf_confirmPassword)
    }
    
    
    private func validatedInfo() -> Bool {
        let predicate = NSPredicate(format: "email = %@", tf_email.text!)
        let user = try! Realm().objects(User.self).filter(predicate)
        if !validateEmail() {
            self.showAlert(title: "Warning", msg: "The email format is incorrect. Please input a valid email address.")
            return false
        }
        if user.count != 0 {
            self.showAlert(title: "Warning", msg: "This email has been register. Please use another email.")
            return false
        }
        if tf_password.text != tf_confirmPassword.text {
            self.showAlert(title: "Warning", msg: "The passwords are different. Please input again.")
            return false
        }
        return true
    }
    
    private func validateEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: tf_email.text)
    }
    
    private func addNewUsers() {
        let realm = try! Realm()
        
        try! realm.write {
            let newUser = User()
            newUser.userID = generateNewUserID()
            newUser.name = tf_name.text!
            newUser.email = tf_email.text!
            newUser.password = tf_password.text!
            realm.add(newUser)
        }
    }
    
    private func generateNewUserID() -> Int {
        let userList = try! Realm().objects(User.self).sorted(byKeyPath: "userID", ascending: false)
        let newUserID = userList[0].userID + 1
        return newUserID
    }
    
    private func showAlert(title: String, msg: String?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        self.present(alert, animated: true)
    }
}



extension L2_SignUpViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(L1_LoginPageViewController.dismissKeyboard1))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard1() {
        view.endEditing(true)
    }
}
