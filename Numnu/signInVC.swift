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

class signInVC: UIViewController, UITextFieldDelegate {

    var idprim = [String]()
    var window: UIWindow?
    var credential: AuthCredential?
    var userprofilename : String = ""
    var userprofileimage : String = ""
    var handler : DatabaseHandle!
    let dbref   = Database.database().reference().child("UserList")
    
    @IBOutlet weak var emailAddressTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet var passwordInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordInfoLabel.isHidden = true
        emailAddressTF.useUnderline()
        passwordTF.useUnderline()
        
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
                
//                let userprofileimage = UserDefaults.standard
//                userprofileimage.set(self.userprofileimage, forKey: "userprofileimage")
                
                
                self.idprim.removeAll()
                
                print("user?.uid: \(user?.uid)")
                
                self.handler = self.dbref.queryOrdered(byChild: "userid").queryEqual(toValue: user?.uid).observe(.value, with: {
                    (snapshot) in
                    
                    if snapshot.exists() {
                        
                        self.idprim.removeAll()
                        
                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                            
                            print("true rooms exist")
                            
                            let useritem = UserList()
                            
                            for snap in snapshots {
                                
                                autoreleasepool {
                                    
                                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                        let key      = snap.key
                                        
                                        useritem.setValuesForKeys(postDict)
                                        self.idprim.append(key)
                                        
                                        
                                    }
                                    
                                }
                            }
                            
                          
                            
                            self.dbref.removeObserver(withHandle: self.handler)
                            
                            DispatchQueue.main.async {
                                
                                HUD.hide()
                                self.revealviewLogin()
                                
                                self.emailAddressTF.text = ""
                                self.passwordTF.text  = ""
                                
                            }
                            
                        }
                        
                    } else {
                        
                        print("false room doesn't exist")
                        
                        let useritem : [String :AnyObject] = ["useremail" : email as AnyObject]
                        self.dbref.child((user?.uid)!).setValue(useritem, withCompletionBlock:{ (error,ref) in
                            
                            HUD.hide()
                            self.revealviewLogin()
                            
                        })
                        
                    }
                    
                })
                
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
