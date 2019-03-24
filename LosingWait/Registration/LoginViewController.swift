//
//  LoginViewController.swift
//  PTSD
//
//  Created by Mike Choi on 4/20/18.
//  Copyright © 2018 Mike Choi. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire

final class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet private weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var passwordTextField: SkyFloatingLabelTextField!
    
    var textFields: [SkyFloatingLabelTextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFields = [emailTextField, passwordTextField]
        for tf in textFields {
            tf.delegate = self
            tf.tintColor = UIColor.blue
            tf.selectedTitleColor = UIColor.blue
            tf.selectedLineColor = UIColor.blue
        }
        
        emailTextField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            validateEmailField()
        }
        
        // When pressing return, move to the next field
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder? {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    @IBAction func validateEmailField() {
        validateEmailTextField(with: emailTextField.text)
    }
    
    func validateEmailTextField(with email: String?) {
        guard let email = email else {
            emailTextField.errorMessage = nil
            return
        }
        
        if email.count == 0 {
            emailTextField.errorMessage = nil
        } else if !validateEmail(email) {
            emailTextField.errorMessage = NSLocalizedString(
                "Email not valid",
                tableName: "SkyFloatingLabelTextField",
                comment: " "
            )
        } else {
            emailTextField.errorMessage = nil
        }
    }
    
    func validateEmail(_ candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    @IBAction private func confirm() {
        let invalidEmail = BannerNotification.fatalError(msg: "Invalid email")
        let loginFailed = BannerNotification.fatalError(msg: "Login failed")
        
        guard let email = emailTextField.text else {
            invalidEmail.show()
            return
        }
        
        if email.count == 0 || !validateEmail(email) {
            invalidEmail.show()
            return
        }
        
        if let password = passwordTextField.text {
            if password.count < 5 {
                BannerNotification.fatalError(msg: "Password must be longer than 5 characters").show()
                return
            }
        }

        let endpoint = URL(string: "https://losing-wait.herokuapp.com/users/login")!
        let parameters: Parameters = ["email": email, "password": passwordTextField.text!]
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
            case .failure(let error):
                BannerNotification.fatalError(msg: "Could not access server").show()
                print(error)
            }
            
            let code = response.response?.statusCode
            if(code == 401) {
                loginFailed.show()
                return
            }
            
            guard let json = response.value as? [String : String] else { return }
            
            print("Login Successful")
            UserDefaults.standard.set(json["email"], forKey: "email")
            UserDefaults.standard.set(json["_id"], forKey: "id")
            UserDefaults.standard.set(json["name"], forKey: "name")
            UserDefaults.standard.set(true, forKey: "loggedIn")
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainTabBarController")
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
}
