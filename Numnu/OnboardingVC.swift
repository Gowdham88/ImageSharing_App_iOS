//
//  OnboardingVC.swift
//  Numnu
//
//  Created by CZ Ltd on 10/8/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import GoogleMaps


class OnboardingVC: UIViewController {
   
    @IBOutlet var letmeinButtonoutlet: UIButton!
    @IBOutlet var notificationsAlert: ViewExtender!
    @IBOutlet var onboardingText: UILabel!
    var window : UIWindow?
    
    @IBOutlet weak var shadowview: UIView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.notificationsAlert.frame.origin.y += self.view.frame.height
        shadowview.isHidden = true
    }

    @IBAction func okPressed(_ sender: Any) {
        
        shadowview.isHidden = true
        notificationsAlert.isHidden = true
        
        self.openStoryBoard(name: Constants.Main, id: Constants.TabStoryId)

    
    }
    
    @IBAction func ignorePressed(_ sender: Any) {
        
        notificationsAlert.isHidden = true
        letmeinButtonoutlet.isUserInteractionEnabled = true
        onboardingText.isHidden      = false
        letmeinButtonoutlet.isHidden = false
        
    }
    
    @IBAction func letmeinPressed(_ sender: Any) {
        
        onboardingText.isHidden      = true
        letmeinButtonoutlet.isHidden = true
        UIView.animate(withDuration: 0.5, animations: {
            self.notificationsAlert.frame.origin.y -= self.view.frame.height
            self.shadowview.isHidden = false
        }, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        
    }
    
    func openStoryBoard(name: String,id : String) {
        
        window         = UIWindow(frame: UIScreen.main.bounds)

        let storyboard                  = UIStoryboard(name: name, bundle: nil)
        let initialViewController       = storyboard.instantiateViewController(withIdentifier: id)
        self.present(initialViewController, animated: false, completion: nil)
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//
//        UIView.transition(with: appDelegate.window!, duration: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
//            appDelegate.window!.rootViewController = initialViewController
//        }, completion:nil)
//
    }
    

}//class

