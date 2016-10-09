//
//  LoginVC.swift
//  wishlist-ios-app
//
//  Created by Wellison Pereira on 10/8/16.
//  Copyright © 2016 Tora Cross. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //This will check for existing credentials, including Facebook, if present it will redirect the user to their Wish List.
        if (FBSDKAccessToken.current() != nil) {
            print(FBSDKAccessToken.self)
        }
        
        if let _ = KeychainWrapper.defaultKeychainWrapper().stringForKey(KEY_UID) {
            print("TC: ID Found in Keychain.")
            performSegue(withIdentifier: "goToWishList", sender: nil)
        } else {
            print("TC: No IDs found in Keychain.")
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    //Facebook Login
    @IBAction func facebookBtnTapped(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("TC: Unable to authenticate with Facebook")
            } else if result?.isCancelled == true {
                print("TC: User cancelled Facebook authentication")
            } else {
                print("TC: Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    
    //Tapping this button will sign the user up.
    @IBAction func signInTapped(_ sender: AnyObject) {
        if let email = emailTextField.text, let pwd = pwTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("TC: Email user authenticated with Firebase.")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    print("Missing information")
                    let alert = UIAlertController(title: "Incorrect Email/Passowrd", message: "Please enter your username or password.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    //Completes the sign in, stores the data in keychain (and if possible, Firebase).
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.defaultKeychainWrapper().setString(id, forKey: KEY_UID)
        print("TC: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToWishList", sender: nil)
    }
    
    //Runs the Firebase SDK for storing credentials.
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("TC: Unable to authenticate with Firebase - \(error)")
            } else {
                print("TC: Successfully authenticated with Firebase.")
                if let user = user {
                    let userData = ["provider": credential.provider, "userName": "\(user.displayName)", "userEmail": "\(user.email)", "usePhoto": "\(user.photoURL)"]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    //Adjust the text fields to the correct view method.
    override func viewDidLayoutSubviews() {
        //The email field
        let emailBorder = CALayer()
        let emailWidth = CGFloat(2.0)
        emailBorder.borderColor = UIColor.black.cgColor
        emailBorder.frame = CGRect(x: 0, y: emailTextField.frame.size.height - emailWidth, width:  emailTextField.frame.size.width, height: emailTextField.frame.size.height)
        
        emailBorder.borderWidth = emailWidth
        emailTextField.layer.addSublayer(emailBorder)
        emailTextField.layer.masksToBounds = true
        
        //The password field
        let pwBorder = CALayer()
        let pwWidth = CGFloat(2.0)
        pwBorder.borderColor = UIColor.black.cgColor
        pwBorder.frame = CGRect(x: 0, y: pwTextField.frame.size.height - pwWidth, width:  pwTextField.frame.size.width, height: pwTextField.frame.size.height)
        
        pwBorder.borderWidth = pwWidth
        pwTextField.layer.addSublayer(pwBorder)
        pwTextField.layer.masksToBounds = true
    }
    
}
