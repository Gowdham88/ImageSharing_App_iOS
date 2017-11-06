//
//  loginMainVC.swift
//  Numnu
//
//  Created by CZ Ltd on 10/8/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import WebKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth


class loginMainVC: UIViewController, UIWebViewDelegate {
    
    var webView: UIWebView!
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    @IBAction func createAccount(_ sender: Any) {
        
        self.performSegue(withIdentifier: "signupwithEmail", sender: self)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
                if closed == "signUp" {
            
                           closed = String()
                
                            self.performSegue(withIdentifier: "signupwithEmail", sender: self)
                
                   } else if closed == "signIn" {
            
                            closed = String()
                
                           self.performSegue(withIdentifier: "signIn", sender: self)
                
                    } else {
            
                            print("Nothing")
                
                    }
        
    }

    @IBAction func signInPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "signIn", sender: self)
    }
    
    @IBAction func facebookLoginPressed(_ sender: Any) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }


            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }

            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)

            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)

                    return
                }

//                 Present the main view
                    self.openStoryBoard(name: Constants.Main, id: Constants.TabStoryId)
                })

        }

    }
    
    func openStoryBoard(name: String,id : String) {
        
        window                          = UIWindow(frame: UIScreen.main.bounds)
        let storyboard                  = UIStoryboard(name: name, bundle: nil)
        let initialViewController       = storyboard.instantiateViewController(withIdentifier: "profileid") as! Edit_ProfileVC
        initialViewController.show      = true
        self.navigationController!.pushViewController(initialViewController, animated: true)
//        window?.rootViewController = initialViewController
//        window?.makeKeyAndVisible()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}



