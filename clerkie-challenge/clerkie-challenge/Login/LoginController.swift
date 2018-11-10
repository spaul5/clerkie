//
//  LoginController.swift
//  clerkie-challenge
//
//  Created by Shouvik Paul on 11/6/18.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {
    private unowned let utility = Utilities.shared
    private unowned let core = CoreDataModel.shared
    
    @IBOutlet weak var gradientView: GradientView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var usernameError: UILabel!
    @IBOutlet weak var loginError: UILabel!
    
    @IBOutlet weak var signupOuterView: UIView!
    @IBOutlet weak var signupInnerView: UIView!
    @IBOutlet weak var signupUsername: UITextField!
    @IBOutlet weak var signupPassword: UITextField!
    @IBOutlet weak var signupRepeatPassword: UITextField!
    @IBOutlet weak var signupGoButton: UIButton!
    @IBOutlet weak var signupUsernameError: UILabel!
    @IBOutlet weak var signupError: UILabel!
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var signupViewHeight: NSLayoutConstraint!
    @IBOutlet weak var signupViewWidth: NSLayoutConstraint!
    @IBOutlet weak var signupViewBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        
        signupUsername.delegate = self
        signupPassword.delegate = self
        signupRepeatPassword.delegate = self
        signupPassword.isSecureTextEntry = true
        signupRepeatPassword.isSecureTextEntry = true
        
        signupOuterView.layer.borderColor = UIColor.clerkieRed.cgColor
        signupOuterView.layer.borderWidth = 1
        showHideSignupView(false, animate: false)
    }
    
    @IBAction func goTap(_ sender: Any) {
        attemptLogin()
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            if !usernameValid(usernameTextField.text) {
                print("username not valid")
                showError(usernameError, nil)
                return false
            }
            print("username valid")
//            if usernameValid(usernameTextField.text) {
                usernameError.isHidden = true
                usernameError.alpha = 0.0
//            } else {
//                showError(usernameError, nil)
//            }
            
            usernameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            attemptLogin()
            self.view.endEditing(true)
            return true
        } else if textField == signupUsername {
            if !usernameValid(signupUsername.text) {
                showError(signupUsernameError, nil)
                return false
            }
//            if usernameValid(signupUsername.text) {
                signupUsernameError.isHidden = true
                signupUsernameError.alpha = 0.0
//            } else {
//                showError(signupUsernameError, nil)
//            }
            
            signupUsername.resignFirstResponder()
            signupPassword.becomeFirstResponder()
        } else if textField == signupPassword {
            signupPassword.resignFirstResponder()
            signupRepeatPassword.becomeFirstResponder()
        } else if textField == signupRepeatPassword {
            if let p = signupPassword.text, !p.isEmpty, let p2 = signupRepeatPassword.text, !p2.isEmpty, p == p2 {
                attemptSignup()
                self.view.endEditing(true)
                return true
            }
            showError(signupError, "Passwords don't match")
        }
        return false
    }
    
    @IBAction func usernameEditChanged(_ sender: Any) {
        guard let textField = sender as? UITextField else {
            return
        }
        if textField == usernameTextField {
            checkShowGoButton()
        } else if textField == signupUsername {
            checkShowSignupGoButton()
        }
    }
    
    @IBAction func passwordEditChanged(_ sender: Any) {
        guard let textField = sender as? UITextField else {
            return
        }
        if textField == passwordTextField {
            checkShowGoButton()
        } else if textField == signupPassword || textField == signupRepeatPassword {
            checkShowSignupGoButton()
        }
    }
    
    func checkShowGoButton() {
        if usernameValid(usernameTextField.text), let t = passwordTextField.text, t != "" {
            showHideGoButton(goButton, true)
        } else {
            showHideGoButton(goButton, false)
        }
    }
    
    func checkShowSignupGoButton() {
        if usernameValid(signupUsername.text), let p = signupPassword.text, !p.isEmpty, let p2 = signupRepeatPassword.text, !p2.isEmpty, p == p2 {
            showHideGoButton(signupGoButton, true)
        } else {
            showHideGoButton(signupGoButton, false)
        }
    }
    
    func showHideGoButton(_ goButton: UIButton, _ show: Bool) {
        if show {
            if goButton.isHidden {
                goButton.isHidden = false
                UIView.animate(withDuration: 0.15) {
                    goButton.alpha = 1.0
                }
            }
        } else {
            if !goButton.isHidden {
                UIView.animate(withDuration: 0.15, animations: {
                    goButton.alpha = 0.0
                }) { _ in
                    goButton.isHidden = true
                }
            }
        }
    }
    
    func attemptLogin() {
        print("attempting login")
        guard let password = passwordTextField.text, !password.isEmpty, usernameValid(usernameTextField.text) else {
            print("username or password empty or username is not valid email or phone")
            showError(loginError, "Please correctly fill in fields")
            return
        }
        
        let err = core.findUser(usernameTextField.text!, password: password)
        if err == nil {
            print("login successful")
            performSegue(withIdentifier: "loginSegue", sender: nil)
            return
        }
        
        if err == .DNE {
            showError(loginError, "Username does not exist. Try again or sign up")
        } else if err == .PasswordError {
            showError(loginError, "Incorrect password")
        } else if err == .Unknown {
            showError(loginError, "Error logging in. Please try again.")
        }
       
    }
    
    @IBAction func signupButtonTap(_ sender: Any) {
        performSegue(withIdentifier: "loginSegue", sender: nil)
//        showHideSignupView(true)
    }
    
    @IBAction func signupCloseTap(_ sender: Any) {
        showHideSignupView(false)
        self.view.endEditing(true)
    }
    
    @IBAction func signupGoTap(_ sender: Any) {
        attemptSignup()
        self.view.endEditing(true)
    }
    
    func showHideSignupView(_ show: Bool, animate: Bool = true) {
        let duration = (animate) ? 0.25 : 0.0
        if show {
            self.signupInnerView.isHidden = false
            signupViewBottom.constant = self.view.frame.height / 2 - 160//270
            self.signupViewHeight.constant = 320
            self.signupViewWidth.constant = self.view.frame.width - 60
            UIView.animate(withDuration: duration, animations: {
                self.signupOuterView.layer.cornerRadius = 10
                self.signupButton.alpha = 0
                self.signupInnerView.alpha = 1
                self.signupOuterView.layoutIfNeeded()
                self.gradientView.updateConstraints()
                self.gradientView.layoutIfNeeded()
            }) { _ in
                self.signupButton.isHidden = true
                
            }
        } else {
            self.signupButton.isHidden = false
            signupViewBottom.constant = 80
            self.signupViewHeight.constant = 50
            self.signupViewWidth.constant = 120
            UIView.animate(withDuration: duration, animations: {
                self.signupOuterView.layer.cornerRadius = 25
                self.signupButton.alpha = 1
                self.signupInnerView.alpha = 0
                self.signupOuterView.layoutIfNeeded()
                self.gradientView.updateConstraints()
                self.gradientView.layoutIfNeeded()
            }) { _ in
                self.signupInnerView.isHidden = true
            }
        }
    }
    
    func attemptSignup() {
        print("attempting signup")
        guard let p = signupPassword.text, !p.isEmpty, let p2 = signupRepeatPassword.text, !p2.isEmpty, usernameValid(signupUsername.text) else {
            print("username or password empty or username is not valid email or phone")
            showError(signupError, "Please correctly fill in fields")
            return
        }
        
        guard p == p2 else {
            showError(signupError, "Passwords don't match")
            return
        }
        
        let createSuccess = core.createUser(signupUsername.text!, password: p)
        if createSuccess {
            print("signup success")
            performSegue(withIdentifier: "loginSegue", sender: nil)
            return
        }
        
        print("signup fail")
        showError(signupError, "Error creating account. Please try again.")
    }
    
    func showError(_ error: UILabel, _ text: String?) {
        if let t = text { error.text = t }
        if !error.isHidden {
            error.isHidden = true
            error.alpha = 0.0
        }
        error.isHidden = false
        UIView.animate(withDuration: 0.1, animations: {
            error.alpha = 1.0
        })
    }
    
    func usernameValid(_ str: String?) -> Bool {
        if let username = str, (username.isValidEmail() || username.isValidPhone()) { return true }
        return false
    }
    
}
