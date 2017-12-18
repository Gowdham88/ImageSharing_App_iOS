//
//  BusinessItemtag.swift
//  Numnu
//
//  Created by Paramesh on 18/12/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import SwiftyJSON

struct  BusinessItemtag {
    
    var tagid         : Int?
    var tagtext       : String?
    var itemcount     : Int?
    
    
    
    init?(json: JSON) {
        
        if let tagid = json["tagid"].int {
            
            self.tagid  = tagid
        }
        
        if let tagtext = json["tagtext"].string {
            
            self.tagtext = tagtext
            
        }
        
        if let itemcount = json["itemcount"].int {
            
            self.itemcount = itemcount
            
        }
        
        
    }
    
}
