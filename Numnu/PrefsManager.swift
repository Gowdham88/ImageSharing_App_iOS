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
    
    
    
    var userId : Int {
        
        get {
            

            if checkprefsobject(object: Constants.id) {
                
                return UserDefaults.standard.integer(forKey: Constants.id)

                
            } else {
                
                return 0
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
    
    var name : String {
        
        get {
            
            if checkprefsobject(object: Constants.name) {
                
                return UserDefaults.standard.string(forKey: Constants.name)!
            } else {
                
                return "empty"
            }
            
        }
        
        set {
            
            UserDefaults.standard.set(newValue, forKey: Constants.name)
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
    
    var dateOfBirth : String {
        
        get {
            
            if checkprefsobject(object: Constants.dateOfBirth) {
                
                return UserDefaults.standard.string(forKey: Constants.dateOfBirth)!
            } else {
                
                return "empty"
            }
            
        }
        
        set {
            
            UserDefaults.standard.set(newValue, forKey: Constants.dateOfBirth)
            
            UserDefaults.standard.synchronize()
        }
    }
    
    var gender : Int {
        
        get {
            
            if checkprefsobject(object: Constants.gender) {
                
                return UserDefaults.standard.integer(forKey: Constants.gender)
                
            } else {
                
                return 0
            }
            
        }
        
        set {
            
            UserDefaults.standard.set(newValue, forKey: Constants.gender)
            
            UserDefaults.standard.synchronize()
        }
    }
    
    var userCity : String {
        
        get {
            
            if checkprefsobject(object: Constants.userCity) {
                
                return UserDefaults.standard.string(forKey: Constants.userCity)!
            } else {
                
                return "empty"
            }
            
        }
        
        set {
            
            UserDefaults.standard.set(newValue, forKey: Constants.userCity)
            
            UserDefaults.standard.synchronize()
        }
    }
    
    var description : String {
        
        get {
            
            if checkprefsobject(object: Constants.description) {
                
                return UserDefaults.standard.string(forKey: Constants.description)!
            } else {
                
                return "empty"
            }
            
        }
        
        set {
            
            UserDefaults.standard.set(newValue, forKey: Constants.description)
            
            UserDefaults.standard.synchronize()
        }
    }
    
    var lastlocation : String? {
        
        get {
            
            if checkprefsobject(object: Constants.lastlocation) {
                
                return UserDefaults.standard.string(forKey: Constants.lastlocation)!
            } else {
                
                return nil
            }
            
        }
        
        set {
            
            UserDefaults.standard.set(newValue, forKey: Constants.lastlocation)
            
            UserDefaults.standard.synchronize()
        }
    }
    

    var startsat : String {
        
        get {
            
            if checkprefsobject(object: Constants.startsat) {
                
                return UserDefaults.standard.string(forKey: Constants.startsat)!
            } else {
                
                return "empty"
            }
            
        }
        
        set {
            
            UserDefaults.standard.set(newValue, forKey: Constants.startsat)
            UserDefaults.standard.synchronize()
        }
    }
    
    var endsat : String {
        
        get {
            
            if checkprefsobject(object: Constants.endsat) {
                
                return UserDefaults.standard.string(forKey: Constants.endsat)!
            } else {
                
                return "empty"
            }
            
        } set {
                
                
                UserDefaults.standard.set(newValue, forKey: Constants.endsat)
                UserDefaults.standard.synchronize()
            }
        }

    var tagList : [TagList] {
        
        get {
            
            if checkprefsobject(object: Constants.taglist) {
                
                let array         = UserDefaults.standard.object(forKey: Constants.taglist) as! NSData
                return   NSKeyedUnarchiver.unarchiveObject(with: array as Data) as! [TagList]
                
                
            } else {
                
                return []

            }
            } set {
        
            let defaults = UserDefaults.standard
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: newValue)
            defaults.set(encodedData, forKey: Constants.taglist)
            defaults.synchronize()
            
        }
    }
    

    func logoutprefences() {
        
        for key in Array(UserDefaults.standard.dictionaryRepresentation().keys) {
                
                UserDefaults.standard.removeObject(forKey: key)
        }
        
        UserDefaults.standard.synchronize()
          
    }
    
//    var eventLinkList : Array<Any> {
//        
//        get {
//            
//            if checkprefsobject(object: Constants.eventLinkList) {
//                
//                return UserDefaults.standard.array(forKey: Constants.eventLinkList)!
//            } else {
//                
//                return ""
//            }
//            
//        }
//        
//        set {
//            
//            UserDefaults.standard.set(newValue, forKey: Constants.eventLinkList)
//            UserDefaults.standard.synchronize()
//        }
//    }
    
} // Struct
