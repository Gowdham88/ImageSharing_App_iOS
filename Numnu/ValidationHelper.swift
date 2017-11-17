//
//  ValidationHelper.swift
//  Numnu
//
//  Created by CZ Ltd on 11/17/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation


struct ValidationHelper {
    
    private static let _instance = ValidationHelper()
    public var emailRegEx = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
    public var nameRegEx = "[a-zA-Z]+$"
    
    private init() {}
    
    static var Instance: ValidationHelper {
        
        return _instance
        
    }
    
    func isValidEmail(email:String) -> Bool {
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
}
