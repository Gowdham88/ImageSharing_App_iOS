//
//  OnboardingVC.swift
//  Numnu
//
//  Created by CZ Ltd on 10/8/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

class OnboardingVC: UIViewController {
   
    @IBOutlet var letmeinButtonoutlet: UIButton!
    @IBOutlet var notificationsAlert: ViewExtender!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        letmeinButtonoutlet.isUserInteractionEnabled = false
        
    }

    @IBAction func okPressed(_ sender: Any) {
        
        notificationsAlert.isHidden = true
    letmeinButtonoutlet.isUserInteractionEnabled = true
        
    }
    
    @IBAction func ignorePressed(_ sender: Any) {
        
        notificationsAlert.isHidden = true
    letmeinButtonoutlet.isUserInteractionEnabled = true
        
    }
    
    @IBAction func letmeinPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "letmein", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        
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

