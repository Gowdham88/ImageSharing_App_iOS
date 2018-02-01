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
    
    func dateDiff(dateStr:String,Format : String) -> String {
        
        let f:DateFormatter = DateFormatter()
        
        f.timeZone = NSTimeZone.local
        
        f.dateFormat  = Format
        
//        f.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let now = f.string(from: NSDate() as Date)
        
        let startDate = f.date(from: dateStr)
        
        let endDate = f.date(from: now)
        
        let calendar: NSCalendar = NSCalendar.current as NSCalendar
        
        let calendarUnits = NSCalendar.Unit.weekOfMonth.union( NSCalendar.Unit.day).union(NSCalendar.Unit.hour).union(NSCalendar.Unit.minute).union(NSCalendar.Unit.second).union(NSCalendar.Unit.month).union(NSCalendar.Unit.year)
        
        let dateComponents = calendar.components(calendarUnits, from: startDate ?? Date(), to: endDate!, options: [])
        
        let weeks = abs(Int32(dateComponents.weekOfMonth!))
        let days = abs(Int32(dateComponents.day!))
        let hours = abs(Int32(UInt32(dateComponents.hour!)))
        let min = abs(Int32(UInt32(dateComponents.minute!)))
        let sec = abs(Int32(dateComponents.second!))
        let months = abs(Int32(dateComponents.month!))
        let years = abs(Int32(dateComponents.year!))
        
        var timeAgo = ""
        if (sec > 0){
            if (sec > 1) {
                timeAgo = "\(sec) seconds ago"
                
            } else {
                timeAgo = "\(sec) second ago"
            }
            
        }
        if (min > 0){
            if (min > 1) {
                timeAgo = "\(min) minutes ago"
            } else {
                timeAgo = "\(min) minute ago"
            }
        }
        
        if(hours > 0){
            if (hours > 1) {
                timeAgo = "\(hours) hours ago"
            } else {
                timeAgo = "\(hours) hour ago"
            }
        }
        if (days > 0) {
            if (days > 1) {
                timeAgo = "\(days) days ago"
            } else {
                timeAgo = "\(days) day ago"
            }
        }
        
        if(weeks > 0){
            if (weeks > 1) {
                timeAgo = "\(weeks) weeks ago"
            } else {
                timeAgo = "\(weeks) Week ago"
            }
        }
        
        if(months > 0){
            if (months > 1) {
                timeAgo = "\(months) months ago"
            } else {
                timeAgo = "\(months) month ago"
            }
        }
        
        if(years > 0){
            if (years > 1) {
                timeAgo = "\(years) years ago"
            } else {
                timeAgo = "\(years) year ago"
            }
            
        }
        
        print("timeAgo is===> \(timeAgo)")
        return timeAgo;
        
    }
    
    
}
