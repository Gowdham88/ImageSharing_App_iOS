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
    
    
    
    var userId : String {
        
        get {
            

            if checkprefsobject(object: Constants.id) {
                
                return UserDefaults.standard.string(forKey: Constants.id)!

                
            } else {
                
                return "empty"
            }
            
            
        }
        
        set {
            

            UserDefaults.standard.set(newValue, forKey: Constants.id)
            UserDefaults.standard.synchronize()
        }
    }
    
    var userEmail : String {
        
        get {
            
            if checkprefsobject(object: Constants.useremail) {
                
                return UserDefaults.standard.string(forKey: Constants.useremail)!
            } else {
                
                return "empty"
            }
            
        }
        
        set {
            
            UserDefaults.standard.set(newValue, forKey: Constants.useremail)
            UserDefaults.standard.synchronize()
        }
    }
    
    var username : String {
        
        get {
            
            if checkprefsobject(object: Constants.userName) {
                
                return UserDefaults.standard.string(forKey: Constants.userName)!
            } else {
                
                return "empty"
            }
            
        }
        
        set {
            
            UserDefaults.standard.set(newValue, forKey: Constants.userName)
            UserDefaults.standard.synchronize()
        }
    }
    
//    var firstname : String {
//
//        get {
//
//            if checkprefsobject(object: Constants.firstName) {
//
//                return UserDefaults.standard.string(forKey: Constants.firstName)!
//            } else {
//
//                return "empty"
//            }
//
//        }
//
//        set {
//
//            UserDefaults.standard.set(newValue, forKey: Constants.firstName)
//            UserDefaults.standard.synchronize()
//        }
//    }

    var lastname : String {
        
        get {
            
            if checkprefsobject(object: Constants.lastName) {
                
                return UserDefaults.standard.string(forKey: Constants.lastName)!
            } else {
                
                return "empty"
            }
            
        }
        
        set {
            
            UserDefaults.standard.set(newValue, forKey: Constants.lastName)
            UserDefaults.standard.synchronize()
        }
    }
    
    var UIDfirebase : String {
        
        get {
            
            if checkprefsobject(object: Constants.firebaseUID) {
                
                return UserDefaults.standard.string(forKey: Constants.firebaseUID)!
            } else {
                
                return "empty"
            }
            
        }
        
        set {
            
            UserDefaults.standard.set(newValue, forKey: Constants.firebaseUID)
            UserDefaults.standard.synchronize()
        }
    }
    
    var imageURL : String {
        
        get {
            
            if checkprefsobject(object: Constants.imageURLs) {
                
                return UserDefaults.standard.string(forKey: Constants.imageURLs)!
            } else {
                
                return "empty"
            }
            
        }
        
        set {
            
            UserDefaults.standard.set(newValue, forKey: Constants.imageURLs)

            UserDefaults.standard.synchronize()
        }
    }
    
    
    
} // Struct
