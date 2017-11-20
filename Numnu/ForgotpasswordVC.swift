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


class ForgotpasswordVC: UIViewController {

    @IBOutlet weak var forgotpassEmail: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true
        
        // Do any additional setup after loading the view.
    }

    @IBAction func resetPassword(_ sender: UIButton) {
               self.view.endEditing(true)
          if let email = forgotpassEmail.text, email != "" {
         
          Auth.auth().sendPasswordReset(withEmail: email) { error in
            
                if let error = error {
    
                } else {
                
                 self.showAlertMessagepop(title: "Password reset email sent")
                 sender.isEnabled = false
                 self.dismiss(animated: true, completion: nil)
                }
            }
            
        } else {
            
            authenticationError(error: Constants.Emailerror)
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
        errorLabel.isHidden = true
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

