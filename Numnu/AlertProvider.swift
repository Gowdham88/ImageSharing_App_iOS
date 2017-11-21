//
//  AlertProvider.swift
//  Numnu
//
//  Created by CZ Ltd on 11/17/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

struct AlertProvider {
    
    private static let _instance = AlertProvider()
    
    private init() {}
    
    static var Instance: AlertProvider {
        
        return _instance
        
    }
    
    func showAlert(title:String,subtitle:String,vc:UIViewController) {
        
        let alertController = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        vc.present(alertController, animated: true, completion: nil)
  
    }
    
    
    func showInternetAlert(vc:UIViewController) {
        
        let alertController = UIAlertController(title: "No Internet", message: "Check your internet connection.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        vc.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
   

}
