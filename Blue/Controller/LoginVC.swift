//
//  LoginVC.swift
//  Blue
//
//  Created by sHiKoOo on 2/17/19.
//  Copyright © 2019 sHiKoOo. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTxt: InsetTextField!
    @IBOutlet weak var passwordTxt: InsetTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxt.delegate = self
        passwordTxt.delegate = self
    }
    
    @IBAction func closeBtn(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
    }
    
    // login -> if not a user , register -> if ok , login
    @IBAction func signInBtn(_ sender: Any) {
        if emailTxt.text != nil && passwordTxt.text != nil {
            AuthService.instance.loginUser(withEmail: emailTxt.text!, andPassword: passwordTxt.text!) { (success, error) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                }else {
                    print(error?.localizedDescription ?? "")
                    AuthService.instance.registerUser(withEmail: self.emailTxt.text!, andPassword: self.passwordTxt.text!, userCreationComplete: { (success, error) in
                        if success {
                            AuthService.instance.loginUser(withEmail: self.emailTxt.text!, andPassword: self.passwordTxt.text!, loginComplete: { (success, nil) in
                                self.dismiss(animated: true, completion: nil)
                                print("registered")
                            })
                        }else {
                            print(error?.localizedDescription ?? "")
                        }
                    })
                }
            }
        }
    }
    


}

extension LoginVC: UITextFieldDelegate {}
