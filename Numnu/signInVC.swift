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
import Alamofire
import IQKeyboardManagerSwift

var closed = String()

class signInVC: UIViewController, UITextFieldDelegate {

    var idprim = [String]()
    var window: UIWindow?
    var credential: AuthCredential?
    var userprofilename : String = ""
    var userprofileimage : String = ""
    var token_str : String = "empty"

    @IBOutlet weak var passwordReveal: UIButton!
    
    @IBOutlet weak var passwordTitleLabel: UILabel!
    @IBOutlet weak var emailLineView: UIView!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var emailAddressTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordLineview: UIView!
    
    @IBOutlet weak var emailtitleLAbel: UILabel!
    @IBOutlet var passwordInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = 25
        signInButton.clipsToBounds = true
        passwordReveal.setImage(UIImage(named: "Show password icon"), for: .normal)
        passwordReveal.tintColor = UIColor(red: 136/255.0, green: 143/255.0, blue: 158/255.0, alpha: 1.0)
        passwordInfoLabel.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
        
    IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
    }
    func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        emailAddressTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
    }
    @IBAction func dismissPressed(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        
        self.performSegue(withIdentifier: "forgotPassword", sender: self)
        
    }
    
    @IBAction func signinPressed(_ sender: Any) {
        
        if self.currentReachabilityStatus != .notReachable {
            HUD.show(.labeledProgress(title: "Loading...", subtitle: ""))

              login()
            
        } else {
       
            AlertProvider.Instance.showInternetAlert(vc: self)
        
        }
        
    }
    var iconClick = Bool()
    
    func login() {
        
        if let email = emailAddressTF.text , email != "", let pwd = passwordTF.text , pwd != "" {
            
           if ValidationHelper.Instance.isValidEmail(email:email) && pwd.count > 2 {
            
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                
                HUD.show(.labeledProgress(title: "Loading...", subtitle: ""))
                print(error.debugDescription)
                
                if user != nil {
             
                    HUD.hide()
                    self.getFirebaseToken()
                    
                    return
                    
                }
                
                
             
                
            })
                
           } else {
            
            if !ValidationHelper.Instance.isValidEmail(email:email) {
                
                authenticationError(error: Constants.Emailerror)
                
            } else {
                
                authenticationError(error: Constants.Passworderror)
                
            }
            
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
        
        if textField == emailAddressTF  {
            emailtitleLAbel.textColor = UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1.0)
            emailLineView.backgroundColor = UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1.0)
        }else {
            passwordTitleLabel.textColor = UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1.0)
            passwordLineview.backgroundColor = UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1.0)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailAddressTF {
            emailtitleLAbel.textColor = UIColor(red: 129/255.0, green: 125/255.0, blue: 144/255.0, alpha: 1.0)
            emailLineView.backgroundColor = UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1.0)
        }else{
            passwordTitleLabel.textColor = UIColor(red: 129/255.0, green: 125/255.0, blue: 144/255.0, alpha: 1.0)
            passwordLineview.backgroundColor = UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1.0)
        }

    }
    
    
    
    @IBAction func showPassword(_ sender: Any) {
        
        if(iconClick == true) {
            passwordTF.isSecureTextEntry = false
            iconClick = false
            passwordReveal.setImage(UIImage(named: "eye-off.png"), for: .normal)
            passwordReveal.tintColor = UIColor(red: 42/255.0, green: 42/255.0, blue: 42/255.0, alpha: 1.0)
        } else if iconClick == false {
            passwordTF.isSecureTextEntry = true
            iconClick = true
            passwordReveal.setImage(UIImage(named: "Show password icon.png"), for: .normal)
            passwordReveal.tintColor = UIColor(red: 136/255.0, green: 143/255.0, blue: 158/255.0, alpha: 1.0)
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
    
    func openStoryBoard(name: String,id : String,user:UserList) {

        let storyboard                  = UIStoryboard(name: name, bundle: nil)
        let initialViewController       = storyboard.instantiateViewController(withIdentifier: id) as! Profile_PostViewController
        if let taglist = user.tagList {
            initialViewController.itemArray = taglist
        }
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
    
    @IBAction func fbLogin(_ sender: Any) {
        
        if self.currentReachabilityStatus != .notReachable {
            
            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
                if let error = error {
                    print("Failed to login: \(error.localizedDescription)")
                    return
                } else if(result?.isCancelled)! {
                    
                    
                    FBSDKLoginManager().logOut()
                    
                    
                }
                
                
                guard let accessToken = FBSDKAccessToken.current() else {
                    print("Failed to get access token")
                    return
                }
                
                
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                
                // Perform login by calling Firebase APIs
                HUD.show(.labeledProgress(title: "Loading...", subtitle: ""))

                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    
                    if let error = error {
                        HUD.hide()
                        print("Login error: \(error.localizedDescription)")
                        AlertProvider.Instance.showAlert(title: "Oops!", subtitle: error.localizedDescription, vc: self)
                        
                        return
                    }
        
                    self.getFirebaseToken()
                   
                })
                
            }
            
        } else {
            
            AlertProvider.Instance.showInternetAlert(vc: self)
           
        }
  
    }//fb login
    
    
    
}//class

extension signInVC {
   
    func userLoginApi() {
        
        let header     : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token_str)"]
        let loginRequest : ApiClient  = ApiClient()
        loginRequest.userLogin(headers: header, completion: { status,userlist in
            
            if status == "success" {
                
                DispatchQueue.main.async {
                   
                    if let user = userlist {
                        
                        print(user.firebaseuid!)
                        self.getUserDetails(user: user)
                        self.openStoryBoard(name: Constants.Main, id: Constants.Profile_PostViewController,user: user)
                   
                    }
                    
                    HUD.hide()
                   
                    self.emailAddressTF.text = ""
                    self.passwordTF.text     = ""
                    
                }
                
            } else {
                
                 HUD.hide()
                
            }
            
            
        })
        
        
    }
    
    func getFirebaseToken() {
        
        let Request : ApiClient  = ApiClient()
        Request.getFireBaseToken(completion:{ token in
            
            self.token_str = token
            self.userLoginApi()
            
        })
        
    }
    
    func getUserDetails(user:UserList) {
        
        if let firebaseid = user.firebaseuid {
            
            PrefsManager.sharedinstance.UIDfirebase = firebaseid
            
        }
        
        if let userid = user.id {
        
            PrefsManager.sharedinstance.userId = userid
            
        }
        
        if let username = user.username {
            
            PrefsManager.sharedinstance.username = username
            
        }
        
        if let dateofbirth = user.dateofbirth {

            PrefsManager.sharedinstance.dateOfBirth = dateofbirth

        }
        
        if let userEmail = user.email {
            
            PrefsManager.sharedinstance.userEmail = userEmail
            
        }
        
        if let gender = user.gender {
            
            PrefsManager.sharedinstance.gender = gender
            
        }
        
        if let desc = user.description {
            
            PrefsManager.sharedinstance.description = desc
            
        }
        
        if let name = user.name {
            
            PrefsManager.sharedinstance.name = name
            
        }
        
        if let userImagesList = user.imgList {
            
            if userImagesList.count > 0 {
                
                PrefsManager.sharedinstance.imageURL = userImagesList[userImagesList.count-1].imageurl_str ?? "empty"
                
            }
         
        }
        
        if let locitem = user.locItem {
            
            PrefsManager.sharedinstance.userCity = "\(locitem.address_str ?? "Address")"
            
        }
        
        PrefsManager.sharedinstance.isLoginned = true
    
        
    }
 
    
}
