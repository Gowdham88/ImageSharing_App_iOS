//
//  PrefsManager.swift
//  Numnu
//
//  Created by CZ Ltd on 11/17/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation

struct PrefsManager {
    
    static var sharedinstance = PrefsManager()
    
    /*Check object prefes*/
    
    func checkprefsobject(object : String) -> Bool {
        
        if UserDefaults.standard.object(forKey: object) != nil {
            
            return true
            
        } else {
            
            return false
            
        }
        
    }

    var isLoginned : Bool {
        
        get {
            
            if checkprefsobject(object: Constants.loginstatus) {
                
                return UserDefaults.standard.bool(forKey: Constants.loginstatus)
                
            } else {
                
                return false
            }
            
            
        }
        
        set {
            
            UserDefaults.standard.set(newValue, forKey: Constants.loginstatus)
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    
    
    
    
}
