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
//        let fbLoginManager = FBSDKLoginManager()
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
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }

            })

        }

    }
}//class






//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */



