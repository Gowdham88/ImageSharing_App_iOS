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
import PKHUD

var closed = String()

class signInVC: UIViewController, UITextFieldDelegate {

    var idprim = [String]()
    var window: UIWindow?
    var credential: AuthCredential?
    var userprofilename : String = ""
    var userprofileimage : String = ""

    
    @IBOutlet weak var emailAddressTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet var passwordInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordInfoLabel.isHidden = true
        
        // Do any additional setup after loading the view.
    }
   
    @IBAction func dismissPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
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
     
        closed = "signUp"
        dismiss(animated: true, completion: nil)

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
    
   
}
