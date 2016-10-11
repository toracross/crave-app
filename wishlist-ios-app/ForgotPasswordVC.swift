//
//  ForgotPasswordVC.swift
//  wishlist-ios-app
//
//  Created by Wellison Pereira on 10/8/16.
//  Copyright © 2016 Tora Cross. All rights reserved.
//

import UIKit

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
        
        
        
        dismissKeyboard()
    }
    

}
