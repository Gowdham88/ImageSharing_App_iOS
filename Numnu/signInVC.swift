//
//  signInVC.swift
//  Numnu
//
//  Created by Gowdhaman on 10/10/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit
import PKHUD
import FBSDKLoginKit

var closed = String()

class signInVC: UIViewController, UITextFieldDelegate {

    var idprim = [String]()
    var window: UIWindow?
    var credential: AuthCredential?
    var userprofilename : String = ""
    var userprofileimage : String = ""

    
    
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var emailAddressTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet var passwordInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordInfoLabel.isHidden = true
        
        // Do any additional setup after loading the view.
    }
   
    @IBAction func dismissPressed(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        
        self.performSegue(withIdentifier: "forgotPassword", sender: self)
        
    }
    
    @IBAction func signinPressed(_ sender: Any) {
        
        login()
        
    }
    var iconClick = Bool()
    
    func login() {
        
        if let email = emailAddressTF.text , email != "", let pwd = passwordTF.text , pwd != "" {
            
           if isPasswordValid(pwd) {
            
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                
                HUD.show(.labeledProgress(title: "Loading...", subtitle: ""))
                
                if user == nil {
                    
                    self.showAlertMessagepop(title: "Oops! Invalid login.")
                    
                    HUD.hide()
                    
                    return
                    
                }
                
                self.idprim.removeAll()
                
                print("user?.uid: \(user?.uid)")
                
                DispatchQueue.main.async {
                    
                    HUD.hide()
                     self.openStoryBoard(name: Constants.Main, id: Constants.TabStoryId)
                    
                    self.emailAddressTF.text = ""
                    self.passwordTF.text     = ""
                    
                }
                
                print("Login FIRAuth Sign in called")
            })
                
           } else {
            
              authenticationError(error: Constants.Passworderror)
//            authenticationError(error: "Please check password")

            
           }
       
        } else {
            
            
            authenticationError(error: Constants.Emailpasserror)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        passwordInfoLabel.isHidden = true
    }
    
    
    
    @IBAction func showPassword(_ sender: Any) {
        
        if(iconClick == true) {
            passwordTF.isSecureTextEntry = false
            iconClick = false
        } else {
            passwordTF.isSecureTextEntry = true
            iconClick = true
        }
        
    }
    
    @IBAction func signupPressed(_ sender: Any) {
     self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /***************Password validation********************/
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
     /***************Authenticate popup********************/
    
    func authenticationError(error : String){
        
        passwordInfoLabel.text     = error
        passwordInfoLabel.isHidden = false
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.passwordInfoLabel.center.x - 10, y: self.passwordInfoLabel.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.passwordInfoLabel.center.x + 10, y: self.passwordInfoLabel.center.y))
        self.passwordInfoLabel.layer.add(animation, forKey: "position")
        HUD.hide()
        
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
    
    @IBAction func fbLogin(_ sender: Any) {
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

    
    }//fb login
    
    
    
}//class
