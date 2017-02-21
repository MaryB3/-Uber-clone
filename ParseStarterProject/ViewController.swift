/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    
    @IBOutlet var userSignupSwitch: UISwitch!
    
    var signUpMode = true
    
    func displayAlert(title: String, message: String) {
        
        let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertcontroller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertcontroller, animated: true, completion: nil)
        
    }

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var signupOrLoginButton: UIButton!
    @IBAction func signupOrLogin(_ sender: AnyObject) {
        
        if usernameTextField.text == "" || passwordTextField.text == "" {
            
            displayAlert(title: "Error in form", message: "Username and password are required")
            
        } else {
            
            if signUpMode {
                
                let user = PFUser()
                
                user.username = usernameTextField.text
                user.password = passwordTextField.text
                
                
                user["isDriver"] = userSignupSwitch.isOn
                
                user.signUpInBackground(block: { (success, error) in
                    
                    if let error = error {
                        
                        var displayedErrorMessage = "Please try again later"
                        
                        let error = error as NSError
                        
                        if let parseError = error.userInfo["error"] as? String {
                            
                            displayedErrorMessage = parseError
                            
                            
                        }
                        
                        self.displayAlert(title: "Sign Up Failed", message: displayedErrorMessage)
                        
                    } else {
                        
                        print("Sign Up Successful")
                        
                        if let isDriverUser = PFUser.current()?["isDriver"] as? Bool {
                            
                            if isDriverUser {
                                
                                self.performSegue(withIdentifier: "showDriverVC", sender: self)
                                
                            } else {
                                
                                self.performSegue(withIdentifier: "showRiderVC", sender: self)
                                
                            }
                        }
                        
                    }
                    
                    
                })
                
            } else {
                
                PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    
                    if let error = error {
                        
                        var displayedErrorMessage = "Please try again later"
                        
                        let error = error as NSError
                        
                        if let parseError = error.userInfo["error"] as? String {
                            
                            displayedErrorMessage = parseError
                            
                            
                        }
                        
                        self.displayAlert(title: "Sign Up Failed", message: displayedErrorMessage)
                        
                    } else {
                        
                        print("Log In Successful")
                        
                        if let isDriverUser = PFUser.current()?["isDriver"] as? Bool {
                            
                            if isDriverUser {
                                
                                self.performSegue(withIdentifier: "showDriverVC", sender: self)
                                
                                
                            } else {
                                
                                self.performSegue(withIdentifier: "showRiderVC", sender: self)
                                
                            }
                        }
                        
                    }
                    
                    
                })
                
            }
            
        }
        

        
    }
    @IBOutlet var signupSwitchButton: UIButton!
    
    @IBOutlet weak var riderLbl: UILabel!
    @IBOutlet weak var driverLbl: UILabel!
    
    
    @IBAction func switchSignupMode(_ sender: AnyObject) {
        
        
        if signUpMode {
            
            signupOrLoginButton.setTitle("Log In", for: [])
            
            signupSwitchButton.setTitle("Switch To Sign Up", for: [])
            
            signUpMode = false
            
            userSignupSwitch.isHidden = true
            riderLbl.isHidden = true
            driverLbl.isHidden = true
            
            
        } else {
            
            signupOrLoginButton.setTitle("Sign Up", for: [])
            
            signupSwitchButton.setTitle("Switch To Log In", for: [])
            
            signUpMode = true
            
            userSignupSwitch.isHidden = false
            riderLbl.isHidden = false
            driverLbl.isHidden = false
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let isDriverUser = PFUser.current()?["isDriver"] as? Bool {
            
            if isDriverUser {
                
                self.performSegue(withIdentifier: "showDriverVC", sender: self)
                
            } else {
                
                self.performSegue(withIdentifier: "showRiderVC", sender: self)
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        }


}
