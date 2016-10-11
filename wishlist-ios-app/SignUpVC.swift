//
//  SignUpVC.swift
//  wishlist-ios-app
//
//  Created by Wellison Pereira on 10/7/16.
//  Copyright © 2016 Tora Cross. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignUpVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Stuff goes here, but we don't want things to disappear. So really, don't put anything here.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //This will check for existing credentials, including Facebook, if present it will redirect the user to their Wish List.
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
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (facebookResult, facebookError) -> Void in
            if facebookError != nil {
                print("TC: Unable to authenticate with Facebook. Reason: \(facebookError)")
                let alert = UIAlertController(title: "Oops.", message: "Sorry, something went wrong. It's not you, we promise. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            } else if facebookResult?.isCancelled == true {
                print("TC: User cancelled Facebook authentication. Error Detail: \(facebookError)")
                let alert = UIAlertController(title: "Login Cancelled.", message: "Facebook login has been cancelled.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            } else {
                print("TC: Successfully authenticated with Facebook.")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    
    @IBAction func signUpTapped(_ sender: AnyObject) {
        let username = nameTextField.text
        if let email = emailTextField.text, let pwd = pwTextField.text {
            FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                if error != nil {
                    print("TC: Unable to create user in Firebase using this email address. ERR: \(error)")
                    //Presents an alert to the user that they need to enter information in all fields.
                    let alert = UIAlertController(title: "Missing information.", message: "Please be sure to fill in all fields.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    print("TC: Successfully authenticated with Firebase.")
                    if let user = user {
                        let userData = ["provider": user.providerID, "userName": "\(username)", "userEmail": "\(user.email)"]
                        self.completeSignIn(id: user.uid, userData: userData)
                        
                    }
                }
            })
        }
    }
    
    //Saves the data service from Firebase to iOS keychain, remembers user login.
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
                print("TC: Successfully authenticated with Firebase. - \(error)")
                if let user = user {
                    let userData = ["provider": credential.provider, "userName": "\(self.emailTextField.text)", "userEmail": "\(user.email)"]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
    }
    
    //This will add the white underline to the text fields.
    override func viewDidLayoutSubviews() {
        //The email field
        let nameBorder = CALayer()
        let nameWidth = CGFloat(2.0)
        nameBorder.borderColor = UIColor.black.cgColor
        nameBorder.frame = CGRect(x: 0, y: emailTextField.frame.size.height - nameWidth, width:  nameTextField.frame.size.width, height: emailTextField.frame.size.height)
        
        nameBorder.borderWidth = nameWidth
        nameTextField.layer.addSublayer(nameBorder)
        nameTextField.layer.masksToBounds = true
        
        //The password field
        let emailBorder = CALayer()
        let emailWidth = CGFloat(2.0)
        emailBorder.borderColor = UIColor.black.cgColor
        emailBorder.frame = CGRect(x: 0, y: emailTextField.frame.size.height - emailWidth, width:  emailTextField.frame.size.width, height: emailTextField.frame.size.height)
        
        emailBorder.borderWidth = emailWidth
        emailTextField.layer.addSublayer(emailBorder)
        emailTextField.layer.masksToBounds = true
        
        //The confirm password field
        let pwBorder = CALayer()
        let pwWidth = CGFloat(2.0)
        pwBorder.borderColor = UIColor.black.cgColor
        pwBorder.frame = CGRect(x: 0, y: pwTextField.frame.size.height - pwWidth, width:  pwTextField.frame.size.width, height: pwTextField.frame.size.height)
        
        pwBorder.borderWidth = pwWidth
        pwTextField.layer.addSublayer(pwBorder)
        pwTextField.layer.masksToBounds = true
    }

}

