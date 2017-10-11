//
//  signInVC.swift
//  Numnu
//
//  Created by Gowdhaman on 10/10/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

class signInVC: UIViewController {

    @IBOutlet weak var emailAddressTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
