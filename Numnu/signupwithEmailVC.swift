//
//  signupwithEmailVC.swift
//  Numnu
//
//  Created by CZ Ltd on 10/8/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
var closed = String()
class signupwithEmailVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextfield.useUnderline()
        passwordTextfield.useUnderline()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }

    
    @IBAction func signInPressed(_ sender: Any) {
        
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
    
    @IBAction func signupPressed(_ sender: Any) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: pwd) { (user: FIRUser?, error) in
            
            print("user right after creating\(user)")
            
            if user == nil {
                
                self.showAlertMessagepop(title: "Oops! Sign up failed.")
                
                HUD.hide()
                return
                
            }
         
            self.idprim.removeAll()
            self.handler = self.dbref.queryOrdered(byChild: "userid").queryEqual(toValue: user?.uid).observe(.value, with: {
                (snapshot) in
                
                if snapshot.exists() {
                    
                    self.idprim.removeAll()
                    
                    if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        
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
                        HUD.hide()
                        self.revealviewLogin()
                        
                    }
                    
                } else {
                    
                    print("false room doesn't exist")
                    print("nme: \(nme)")
                    print("useremail: \(email)")
                    print("user: \(user)")
                    
                    let useritem : [String :AnyObject] = ["username" : "\(nme) \(lastnme)" as AnyObject , "useremail" : email as AnyObject , "userid" : (user?.uid)! as AnyObject, "userstartdate" : startdate as AnyObject , "userenddate" : enddate as AnyObject , "userpaymentstatus" : "pending" as AnyObject,"useraccesscount" : "0" as AnyObject,"uniquecode" : uniquecode as AnyObject,"usertransactionid" : "" as AnyObject]
                    
                    
                    self.dbref.childByAutoId().setValue(useritem, withCompletionBlock:{ (error,ref) in
                        
                        
                        
                        
                    })
                    
                }
                
                
            })
            print(" App Delegate SignIn with credential called")
        }
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
