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
                                self.revealviewLogin()
                                
                                self.emailAddressTF.text = ""
                                self.passwordTF.text  = ""
                            
                    }
                
                print("Login FIRAuth Sign in called")
            })
            
        } else {
            
            HUD.hide()
            self.showAlertMessagepop(title: "Hey! Enter email and password.")
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
    
    
    func revealviewLogin() {
        
        self.window                     = UIWindow(frame: UIScreen.main.bounds)
        let storyboard                  = UIStoryboard(name: Constants.Main, bundle: nil)
        let initialViewController       = storyboard.instantiateViewController(withIdentifier: Constants.TabStoryId)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
