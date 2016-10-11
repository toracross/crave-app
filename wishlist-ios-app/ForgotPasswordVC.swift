//
//  ForgotPasswordVC.swift
//  wishlist-ios-app
//
//  Created by Wellison Pereira on 10/8/16.
//  Copyright © 2016 Tora Cross. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidLayoutSubviews() {
        //Customize the text entry field with emails.
        let emailBorder = CALayer()
        let emailWidth = CGFloat(2.0)
        emailBorder.borderColor = UIColor.black.cgColor
        emailBorder.frame = CGRect(x: 0, y: emailTextField.frame.size.height - emailWidth, width:  emailTextField.frame.size.width, height: emailTextField.frame.size.height)
        
        emailBorder.borderWidth = emailWidth
        emailTextField.layer.addSublayer(emailBorder)
        emailTextField.layer.masksToBounds = true
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func resetPassBtnPressed (_ sender: AnyObject!) {
        let email = emailTextField.text
        FIRAuth.auth()?.sendPasswordReset(withEmail: email!) { error in
            if error != nil {
                print("Missing information. User did not enter something.")
                let alert = UIAlertController(title: "Invalid Email Address", message: "Please enter your email address.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                print("Password reset sent.")
                let alert = UIAlertController(title: "Password Sent", message: "We've sent you a temporary password, please check your email.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        dismissKeyboard()
    }
    

}
