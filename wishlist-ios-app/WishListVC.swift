//
//  WishListVC.swift
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
import SideMenu

class WishListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    

    
    //Signs the user out.
    @IBAction func signOutTapped(_ sender: AnyObject) {
        let keychainResult = KeychainWrapper.defaultKeychainWrapper().removeObjectForKey(KEY_UID)
        print("TC: Successfully removed ID from keychain \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToLogin", sender: nil)
    }
}
