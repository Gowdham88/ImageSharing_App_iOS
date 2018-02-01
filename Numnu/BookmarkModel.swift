//
//  BookmarkModel.swift
//  Numnu
//
//  Created by CZ Ltd on 12/26/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import SwiftyJSON

struct  BookmarkModel {
    
    var id             : Int?
    var entityid       : String?
    var entityname     : String?
    var type           : String?
    var userid         : String?
   
    
    
    
    init?(json: JSON) {
        
        if let id = json["id"].int {
            
            self.id  = id
        }
        
        if let entityid = json["entityid"].string {
            
            self.entityid = entityid
            
        }
        
        if let entityname   = json["entityname"].string {
            
            self.entityname = entityname
            
        }
        
        if let type = json["type"].string {
            
            self.type = type
        }
        
        if let userid = json["userid"].string {
            
            self.userid = userid
        }
        
    }
            
}
