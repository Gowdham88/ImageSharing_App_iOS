//
//  DateFormatterManager.swift
//  Numnu
//
//  Created by CZ Ltd on 12/7/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation



class DateFormatterManager: NSObject {
    
    static let sharedinstance = DateFormatterManager()
    let dateformat = DateFormatter()
    let gregorian = Calendar(identifier: .gregorian)
    
    
    func datetoString(format : String,date : Date?) -> String? {
        
        dateformat.dateFormat = format
        return dateformat.string(from: date!)
    
      
    }
    
    
    func stringtoDate(format : String,date : String) -> Date {
        
        dateformat.dateFormat = format
    
        
        if let dateCon = dateformat.date(from: date) {
            
            return dateCon
            
        } else {
            
            return Date()
        }
        
        
    }
    
    func stringtoDateTimeStamp(date : String) -> Date? {
        
        dateformat.dateStyle = .medium
        dateformat.timeStyle = .short
        
        if let dateCon = dateformat.date(from: date) {
            
            return dateCon
            
        } else {
            
            return Date()
        }
        
        
    }
    
    func CheckValidDate(date : Date?) -> Date {
        
        if let datePic = date {
            
            return datePic
            
        } else {
            
            return Date()
        }
        
        
    }
    
    
}
