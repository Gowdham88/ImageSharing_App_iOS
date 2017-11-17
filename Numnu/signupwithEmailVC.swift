//
//  signupwithEmailVC.swift
//  Numnu
//
//  Created by CZ Ltd on 10/8/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import PKHUD

class signupwithEmailVC: UIViewController, UITextFieldDelegate {

    var idprim = [String]()
    var window: UIWindow?
    var credential: AuthCredential?
    var userprofilename : String = ""
    var userprofileimage : String = ""
    var ViewMoved = true

    
    @IBOutlet weak var orLbl: UILabel!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet var labelcredentials: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
  
      labelcredentials.isHidden = true

//        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
//
        
       
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        
        //        self.view.frame = offsetBy(self.view.frame, 0, movement)
        
        UIView.commitAnimations()
    }
    
    var iconClick = Bool()
    
    @IBAction func passwordHideButton(_ sender: Any) {
        
        if(iconClick == true) {
            
            passwordTextfield.isSecureTextEntry = false
            iconClick = false
            
        } else {
            
            passwordTextfield.isSecureTextEntry = true
            iconClick = true
            
        }
        
    }
    
    @IBAction func signinPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: Constants.Auth, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "signInVC")
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        labelcredentials.isHidden = true

    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        animateViewMoving(up: false, moveValue: 0)


    }
    @IBAction func signupPressed(_ sender: Any) {
        
        Login()
    }
    
    func isPasswordValid(_ password : String) -> Bool{
//        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{2,}")
        //        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "")
        return true
//        return passwordTest.evaluate(with: password)
    }
    
    func Login() {
        
        //Make sure there is an email and a password
        if let email = emailTextfield.text , email != "", let pwd = passwordTextfield.text , pwd != "" {
            
        if ValidationHelper.Instance.isValidEmail(email:email) && pwd.count < 3 {
            
            HUD.show(.labeledProgress(title: "Loading...", subtitle: ""))
            
            
            Auth.auth().createUser(withEmail: email, password: pwd) { (user: User?, error) in
                
                if user == nil {
  
                    self.authenticationError(error: "Oops! Invalid login.")
                    HUD.hide()
 
                    return
                    
                }
               
                HUD.hide()
                
                self.openStoryBoard(name: Constants.Main, id: Constants.TabStoryId)
                
                
                self.idprim.removeAll()
 
                print(" App Delegate SignIn with credential called")
                
               }
                
            } else {
                
                if !ValidationHelper.Instance.isValidEmail(email:email) {
                
                authenticationError(error: Constants.Emailerror)
                
                } else {
                
                authenticationError(error: Constants.Passworderror)
                
                }
              
            }
         } else {
            
            authenticationError(error: Constants.Emailpasserror)
            print("Please fill in all the fields")
        }
        
    }
    
    @IBAction func dismissPressed(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    func authenticationError(error : String) {
        
        labelcredentials.text     = error
        labelcredentials.isHidden = false
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.labelcredentials.center.x - 10, y: self.labelcredentials.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.labelcredentials.center.x + 10, y: self.labelcredentials.center.y))
        self.labelcredentials.layer.add(animation, forKey: "position")
        HUD.hide()
        
    }
    
    func openStoryBoard(name: String,id : String) {
        
//        window                          = UIWindow(frame: UIScreen.main.bounds)
//        let storyboard                  = UIStoryboard(name: name, bundle: nil)
//        let initialViewController       = storyboard.instantiateViewController(withIdentifier: "profileid") as! Edit_ProfileVC
//        initialViewController.show      = true
//        self.navigationController!.pushViewController(initialViewController, animated: true)
//        window?.rootViewController = initialViewController
//        window?.makeKeyAndVisible()
        
        
//        window                          = UIWindow(frame: UIScreen.main.bounds)
        let storyboard                  = UIStoryboard(name: name, bundle: nil)
        let initialViewController       = storyboard.instantiateViewController(withIdentifier: "profileid") as! Edit_ProfileVC
        initialViewController.show      = true
        self.navigationController!.pushViewController(initialViewController, animated: true)
        
        
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
    
    @IBAction func fbSignup(_ sender: Any) {
        
        let fbLoginmanager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginmanager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
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
}

extension UITextField {
    
    func useUnderline() {
        
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: self.frame.size.width, height: self.frame.size.height)
        
        //CGRect(0, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height)
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

