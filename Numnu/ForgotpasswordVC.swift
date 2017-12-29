//
//  ForgotpasswordVC.swift
//  Numnu
//
//  Created by CZ Ltd on 10/8/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import IQKeyboardManagerSwift

class ForgotpasswordVC: UIViewController {

    @IBOutlet weak var forgotpassEmail: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var forgotview: UIView!
    @IBOutlet var emaillabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func resetPassword(_ sender: UIButton) {
               self.view.endEditing(true)
          if let email = forgotpassEmail.text, email != "" {
         
          Auth.auth().sendPasswordReset(withEmail: email) { error in
            
                if let error = error {
                    AlertProvider.Instance.showAlert(title: "Oops...", subtitle: error.localizedDescription, vc: self)
                    print("forgot password error:::::::",error.localizedDescription)

                } else {
                    sender.isEnabled = false

//                 self.showAlertMessagepop(title: "Password reset email sent")
                   let Alert = UIAlertController(title: "Success", message: "A reset link has been sent to your email", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { _ in
                        self.popNav()
                    }
                    Alert.addAction(okAction)
                    self.present(Alert, animated: true, completion:nil )
                    
//                 self.dismiss(animated: true, completion: nil)
                }
            }
            
        } else {
            
            authenticationError(error: Constants.Emailerror)
        }
  
        
    }
    func popNav () {
        
        self.navigationController?.popViewController(animated: true)

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorLabel.isHidden = true
        
        //        passwordInfoLabel.isHidden = true
        
        if textField == forgotpassEmail  {
            
            emaillabel.textColor = UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1.0)
            forgotview.backgroundColor = UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1.0)
        }else{}
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == forgotpassEmail {
            
            emaillabel.textColor = UIColor(red: 129/255.0, green: 125/255.0, blue: 144/255.0, alpha: 1.0)
            forgotview.backgroundColor = UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1.0)
        } else{}
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func ButtonClose(_ sender: UIButton) {
        
        _ = self.navigationController?.popViewController(animated: true)
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
    
    /***************Authenticate popup********************/
    
    func authenticationError(error : String){
        
        errorLabel.text     = error
        errorLabel.isHidden = false
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.errorLabel.center.x - 10, y: self.errorLabel.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.errorLabel.center.x + 10, y: self.errorLabel.center.y))
        self.errorLabel.layer.add(animation, forKey: "position")
        
        
    }
    
   

}

