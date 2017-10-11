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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forgotpassEmail.useUnderline()

        // Do any additional setup after loading the view.
    }

    @IBAction func resetPassword(_ sender: Any) {
        
        let email = forgotpassEmail.text
        
        Auth.auth().sendPasswordReset(withEmail: email!) { error in
            
            if let error = error {
                
                self.showAlertMessagepop(title: "Password reset failed \(error)")
                
            } else {
                
                 self.showAlertMessagepop(title: "Password reset email sent")
                
                self.dismiss(animated: true, completion: nil)
                
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func ButtonClose(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
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

