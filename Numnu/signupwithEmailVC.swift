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
import Alamofire
import IQKeyboardManagerSwift

@available(iOS 10.0, *)
@available(iOS 10.0, *)
@available(iOS 10.0, *)
class signupwithEmailVC: UIViewController, UITextFieldDelegate {

    var idprim = [String]()
    var window: UIWindow?
    var credential: AuthCredential?
    var userprofilename : String = ""
    var userprofileimage : String = ""
    var ViewMoved = true

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var passwordReveal: UIButton!
    @IBOutlet weak var emailtitleLAbel: UILabel!
    @IBOutlet weak var emailLineView: UIView!
    @IBOutlet weak var passwordLineView: UIView!
    @IBOutlet weak var passwordtitleLabel: UILabel!
    
    @IBOutlet weak var orLbl: UILabel!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet var labelcredentials: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        passwordReveal.setImage(UIImage(named: "Show password icon"), for: .normal)
        passwordReveal.tintColor = UIColor(red: 136/255.0, green: 143/255.0, blue: 158/255.0, alpha: 1.0)
        
        navigationController?.tabBarController?.tabBar.isHidden = true
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 10

        labelcredentials.isHidden = true
        signUpButton.layer.cornerRadius = 25
        signUpButton.clipsToBounds = true
        emailTextfield.autocorrectionType = .no
        passwordTextfield.autocorrectionType = .no
        
        if #available(iOS 11, *) {
            emailTextfield.textContentType = UITextContentType.emailAddress
            passwordTextfield.textContentType = UITextContentType("")
        }
       



       
//        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)


    }
//    func animateViewMoving(up:Bool, moveValue :CGFloat) {
//
//        let movementDuration:TimeInterval = 0.3
//        let movement:CGFloat = ( up ? -moveValue : moveValue)
//
//        UIView.beginAnimations("animateView", context: nil)
//        UIView.setAnimationBeginsFromCurrentState(true)
//        UIView.setAnimationDuration(movementDuration)
//
//        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
//
//        //        self.view.frame = offsetBy(self.view.frame, 0, movement)
//
//        UIView.commitAnimations()
//    }
    
    var iconClick = Bool()
    
    @IBAction func passwordHideButton(_ sender: Any) {
        
        if(iconClick == true) {

            passwordTextfield.isSecureTextEntry = false
            iconClick = false
            passwordReveal.setImage(UIImage(named: "eye-off.png"), for: .normal)
            passwordReveal.tintColor = UIColor(red: 42/255.0, green: 42/255.0, blue: 42/255.0, alpha: 1.0)

        } else if iconClick == false {

            passwordTextfield.isSecureTextEntry = true
            iconClick = true
            passwordReveal.setImage(UIImage(named: "Show password icon.png"), for: .normal)
            passwordReveal.tintColor = UIColor(red: 136/255.0, green: 143/255.0, blue: 158/255.0, alpha: 1.0)

        }
        
//        if passwordTextfield.isSecureTextEntry == false {
//            passwordReveal.setImage(UIImage(named: "eye-off.png"), for: .normal)
//        }else {
//            iconClick = true
//            passwordReveal.setImage(UIImage(named: "Show password icon.png"), for: .normal)
//            passwordReveal.setBackgroundImage(UIImage(named:"Show password icon.png"), for: .normal)
//        }
    }
    
    @IBAction func signinPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: Constants.Auth, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "signInVC")
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        dismissKeyboard()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        animateViewMoving(up: true, moveValue: 0)

        
        if textField == emailTextfield {
            emailtitleLAbel.textColor = UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1.0)
            emailLineView.backgroundColor = UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1.0)
        }else {
            passwordtitleLabel.textColor = UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1.0)
            passwordLineView.backgroundColor = UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1.0)
        }
        
        labelcredentials.isHidden = true

    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
//        animateViewMoving(up: false, moveValue: 0)
        if textField == emailTextfield {
            emailtitleLAbel.textColor = UIColor(red: 129/255.0, green: 125/255.0, blue: 144/255.0, alpha: 1.0)
            emailLineView.backgroundColor = UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1.0)
        }else{
            passwordtitleLabel.textColor = UIColor(red: 129/255.0, green: 125/255.0, blue: 144/255.0, alpha: 1.0)
            passwordLineView.backgroundColor = UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1.0)
        }
        textField.resignFirstResponder()


    }
    @IBAction func signupPressed(_ sender: Any) {
        
        if currentReachabilityStatus != .notReachable {
            
            Login()
            
        } else {
            
            AlertProvider.Instance.showInternetAlert(vc: self)
        }
        
        
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
            
        if ValidationHelper.Instance.isValidEmail(email:email) && pwd.count > 2 {
            
            HUD.show(.labeledProgress(title: "Loading...", subtitle: ""))
            
            
            Auth.auth().createUser(withEmail: email, password: pwd) { (user: User?, error) in
                
                if user == nil {
  
                    self.authenticationError(error: "Oops! Invalid login.")
                    HUD.hide()
                    
                    if let errorcontent = error {
                        print("signup error:::::::",errorcontent.localizedDescription)
                        
                        if  errorcontent.localizedDescription == "The email address is already in use by another account."  {
                            
                            AlertProvider.Instance.showAlert(title: "Oops!", subtitle: errorcontent.localizedDescription, vc: self)
                            
                        }
                        
                     
                        
                    }
                    return
                    
                }
                
                self.emailTextfield.text = ""
                self.passwordTextfield.text = ""
  
                HUD.hide()
                self.openStoryBoard(name: Constants.Main, id: Constants.ProfileId,firebaseid: (user?.uid)!)

                
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
    
    func openStoryBoard(name: String,id : String,firebaseid : String) {

        let storyboard                  = UIStoryboard(name: name, bundle: nil)
        let initialViewController       = storyboard.instantiateViewController(withIdentifier: id) as! Edit_ProfileVC
        initialViewController.boolForTitle = true
        initialViewController.firebaseid   = firebaseid
        self.navigationController!.pushViewController(initialViewController, animated: true)
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func fbSignup(_ sender: Any) {

        
        let fbLoginmanager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginmanager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                HUD.hide()
                return
            } else if(result?.isCancelled)! {
                
                HUD.hide()
                FBSDKLoginManager().logOut()
                
                
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                 HUD.hide()
                return
            }

            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    HUD.hide()
                    AlertProvider.Instance.showAlert(title: "", subtitle: error.localizedDescription, vc: self)
                    print("Login error: \(error.localizedDescription)")
                    
                    
                    return
                }
             
                HUD.hide()
                self.openStoryBoard(name: Constants.Main, id: Constants.ProfileId,firebaseid: (user?.uid)!)
                
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




