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

class signupwithEmailVC: UIViewController, UITextFieldDelegate {

    var idprim = [String]()
    var window: UIWindow?
    var credential: AuthCredential?
    var userprofilename : String = ""
    var userprofileimage : String = ""
    var ViewMoved = true

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
        passwordReveal.setImage(UIImage(named: "Show password icon"), for: .normal)
        passwordReveal.tintColor = UIColor(red: 136/255.0, green: 143/255.0, blue: 158/255.0, alpha: 1.0)
        
        navigationController?.tabBarController?.tabBar.isHidden = true

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
            passwordReveal.setImage(UIImage(named: "eye-off.png"), for: .normal)
            passwordReveal.tintColor = UIColor(red: 42/255.0, green: 42/255.0, blue: 42/255.0, alpha: 1.0)
//                        passwordReveal.setBackgroundImage(UIImage(named:"eye-off.png"), for: .normal)


        }else if iconClick == false {
            
            passwordTextfield.isSecureTextEntry = true
            iconClick = true
            passwordReveal.setImage(UIImage(named: "Show password icon.png"), for: .normal)
            passwordReveal.tintColor = UIColor(red: 136/255.0, green: 143/255.0, blue: 158/255.0, alpha: 1.0)

//            passwordReveal.setBackgroundImage(UIImage(named:"Show password icon.png"), for: .normal)

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
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
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
        
        textField.resignFirstResponder()
        animateViewMoving(up: false, moveValue: 0)
        if textField == emailTextfield {
            emailtitleLAbel.textColor = UIColor(red: 129/255.0, green: 125/255.0, blue: 144/255.0, alpha: 1.0)
            emailLineView.backgroundColor = UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1.0)
        }else{
            passwordtitleLabel.textColor = UIColor(red: 129/255.0, green: 125/255.0, blue: 144/255.0, alpha: 1.0)
            passwordLineView.backgroundColor = UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1.0)
        }

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
            
        if ValidationHelper.Instance.isValidEmail(email:email) && pwd.count > 2 {
            
            HUD.show(.labeledProgress(title: "Loading...", subtitle: ""))
            
            
            Auth.auth().createUser(withEmail: email, password: pwd) { (user: User?, error) in
                
                if user == nil {
  
                    self.authenticationError(error: "Oops! Invalid login.")
                    HUD.hide()

                    return
                    
                }
               
                HUD.hide()
                
                self.openStoryBoard(name: Constants.Main, id: Constants.ProfileId)
                
                
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
        
        
//        window                        = UIWindow(frame: UIScreen.main.bounds)
        let storyboard                  = UIStoryboard(name: name, bundle: nil)
        let initialViewController       = storyboard.instantiateViewController(withIdentifier: id) as! Edit_ProfileVC
        initialViewController.boolForTitle = true
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
                    
                    AlertProvider.Instance.showAlert(title: "Oops!", subtitle: "Facebook login failed.", vc: self)
                   
                    return
                }
                
                self.userLoginApi(uid: user.uid)
                //                 Present the main view
                self.openStoryBoard(name: Constants.Main, id: Constants.ProfileId)
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

extension signupwithEmailVC {
    
    func userLoginApi(uid:String) {
        
        let clientIp = IPChecker.getIP() ?? "1.0.1"
        
        let parameters : Parameters = ["firebaseuid" : uid,"createdByUserId" : "","updatedByUserId" : "","createdTimestamp" : "","updatedTimestamp" : "","clientApp": "iosapp","clientIP":clientIp]
        
        let loginRequest : ApiClient  = ApiClient()
        loginRequest.userLogin(parameters: parameters, completion: { status,userlist in
            
            if status == "success" {
                
                DispatchQueue.main.async {
                    
                    if let user = userlist {
                        
                        print(user.firebaseUID!)
                        print(user.id!)
                        
                    }
                    
                    HUD.hide()
                    //                    self.openStoryBoard(name: Constants.Main, id: Constants.ProfileId)
                    //
                    //                    self.emailAddressTF.text = ""
                    //                    self.passwordTF.text     = ""
                    
                }
                
            } else {
                
                HUD.hide()
                
            }
            
            
        })
        
        
    }
    
    
}


