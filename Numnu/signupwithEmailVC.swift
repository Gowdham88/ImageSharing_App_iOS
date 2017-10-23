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
import PKHUD

class signupwithEmailVC: UIViewController, UITextFieldDelegate {

    var idprim = [String]()
    var window: UIWindow?
    var credential: AuthCredential?
    var userprofilename : String = ""
    var userprofileimage : String = ""

    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet var labelcredentials: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
  
        labelcredentials.isHidden = true
        
      
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
        
        closed = "signIn"
        dismiss(animated: true, completion: nil)

        
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
    
    @IBAction func signupPressed(_ sender: Any) {
        
        Login()
    }
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    func Login() {
        
        //Make sure there is an email and a password
        if let email = emailTextfield.text , email != "", let pwd = passwordTextfield.text , pwd != "" { //, let nme = firstnametextfield.text , nme != "" {
            
            let passwordvalid = isPasswordValid(pwd)
            
            if passwordvalid ==  true {
                
            labelcredentials.isHidden = true
                
            HUD.show(.labeledProgress(title: "Loading...", subtitle: ""))
            
            
            Auth.auth().createUser(withEmail: email, password: pwd) { (user: User?, error) in
                
                if user == nil {
                    
                self.labelcredentials.isHidden = false
                    
                    HUD.hide()
                    
                    let animation = CABasicAnimation(keyPath: "position")
                    animation.duration = 0.07
                    animation.repeatCount = 4
                    animation.autoreverses = true
                    animation.fromValue = NSValue(cgPoint: CGPoint(x: self.labelcredentials.center.x - 10, y: self.labelcredentials.center.y))
                    animation.toValue = NSValue(cgPoint: CGPoint(x: self.labelcredentials.center.x + 10, y: self.labelcredentials.center.y))
                    self.labelcredentials.layer.add(animation, forKey: "position")
                    
                    return
                    
                }
               
                HUD.hide()
                
                self.revealviewLogin()
                
                
                self.idprim.removeAll()
 
                print(" App Delegate SignIn with credential called")
                }
                
            } else {
                
                labelcredentials.isHidden = false
              
            }
            
        } else {
            
            labelcredentials.isHidden = false
            
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: self.labelcredentials.center.x - 10, y: self.labelcredentials.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: self.labelcredentials.center.x + 10, y: self.labelcredentials.center.y))
            self.labelcredentials.layer.add(animation, forKey: "position")
            HUD.hide()
            print("Please fill in all the fields")
        }
        
    }
    
    @IBAction func dismissPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func revealviewLogin() {
        
        self.window                     = UIWindow(frame: UIScreen.main.bounds)
        let storyboard                  = UIStoryboard(name: Constants.Main, bundle: nil)
        let initialViewController       = storyboard.instantiateViewController(withIdentifier: Constants.TabStoryId)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
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
