//
//  loginMainVC.swift
//  Numnu
//
//  Created by CZ Ltd on 10/8/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

class loginMainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func createAccount(_ sender: Any) {
        
        self.performSegue(withIdentifier: "signupwithEmail", sender: self)
        
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "signIn", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if closed == "signUp" {
            
            closed = String()
            
            self.performSegue(withIdentifier: "signupwithEmail", sender: self)
            
        } else if closed == "signIn" {
            
            closed = String()

            self.performSegue(withIdentifier: "signIn", sender: self)
            
        } else {
            
            print("Nothing")
            
        }
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
