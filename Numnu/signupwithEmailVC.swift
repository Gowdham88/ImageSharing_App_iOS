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
    var handler : DatabaseHandle!
    let dbref   = Database.database().reference().child("UserList")
  
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet var labelcredentials: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextfield.useUnderline()
        passwordTextfield.useUnderline()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        
        Login()
    }
    
    func Login() {
        
        //Make sure there is an email and a password
        if let email = emailTextfield.text , email != "", let pwd = passwordTextfield.text , pwd != "" { //, let nme = firstnametextfield.text , nme != "" {
            
            HUD.show(.labeledProgress(title: "Loading...", subtitle: ""))
            self.labelcredentials.alpha = 0
            
            Auth.auth().createUser(withEmail: email, password: pwd) { (user: User?, error) in
                
                if user == nil {
                    
                    self.labelcredentials.alpha = 1
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
               
               
                
                self.idprim.removeAll()
                self.handler = self.dbref.queryOrdered(byChild: "userid").queryEqual(toValue: user?.uid).observe(.value, with: {
                    (snapshot) in
                    
                    if snapshot.exists() {
                        
                        self.idprim.removeAll()
                        HUD.hide()
                        
                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                            
                            print("true rooms exist")
                            
//                            let useritem = UserList()
//
//                            for snap in snapshots {
//
//                                autoreleasepool {
//
//                                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
//                                        let key      = snap.key
//
//                                        useritem.setValuesForKeys(postDict)
//                                        self.idprim.append(key)
//
//
//                                    }
//
//                                }
//                            }
//
//
//                            self.dbref.removeObserver(withHandle: self.handler)
//
                            self.revealviewLogin()
                            
                        }
                        
                    } else {
                        
                        print("false room doesn't exist")
                       
                        let nme = ""
                        let startdate = ""
                        let enddate = ""
                        let uniquecode = ""
                        
                        let useritem : [String :AnyObject] = ["username" : nme as AnyObject , "useremail" : email as AnyObject , "userid" : (user?.uid)! as AnyObject, "userstartdate" : startdate as AnyObject , "userenddate" : enddate as AnyObject , "userpaymentstatus" : "pending" as AnyObject,"useraccesscount" : "0" as AnyObject,"uniquecode" : uniquecode as AnyObject,"usertransactionid" : "" as AnyObject]
                        
                        
                        self.dbref.childByAutoId().setValue(useritem, withCompletionBlock:{ (error,ref) in
                            
                            HUD.hide()
                            
                            
                        })
                        
                    }
                    
                    
                })
                print(" App Delegate SignIn with credential called")
            }
            
        } else {
            
            self.labelcredentials.alpha = 1
            HUD.hide()
            
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
