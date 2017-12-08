//
//  DBProvider.swift
//  Numnu
//
//  Created by CZ Ltd on 9/18/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class DBProvider {
    
    
    private static let _instance = DBProvider()
   
    private init() {}
    
    static var Instance: DBProvider {
        
        return _instance
        
    }
    
    
    var dbref: DatabaseReference {
        
        return Database.database().reference()
        
    }
    
    
    var postsRef : DatabaseReference {
        
        return Database.database().reference().child(Constants.POST)
        
    }
    
    var handlerPost : DatabaseHandle!
    
    func firebaseLogout() {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
}
