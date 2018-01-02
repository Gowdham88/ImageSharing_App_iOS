//
//  BookmarksDataItems.swift
//  Numnu
//
//  Created by Siva on 02/01/18.
//  Copyright © 2018 czsm. All rights reserved.
//

import Foundation
import SwiftyJSON

struct BookmarksDataItems {
   var id           : Int?
   var type         : String?
   var entityid     : Int?
   var entityname   : String?
   var userid       : Int?
   var createdat    : String?
   var updatedat    : String?
   var createdby    : Int?
   var updatedby    : Int?
    
    init?(json: JSON) {
        
      
        if let id    = json["id"].int {
            
            self.id  = id
        }
        if let type    = json["type"].string {
            
            self.type  = type
        }
        if let entityid    = json["entityid"].int {
            
            self.entityid  = entityid
        }
        if let entityname    = json["entityname"].string {
            
            self.entityname  = entityname
        }
        if let userid    = json["userid"].int {
            
            self.userid  = userid
        }
        if let createdat = json["createdat"].string {
            
            self.createdat = createdat
            
        }
        
        if let updatedat = json["updatedat"].string {
            
            self.updatedat = updatedat
            
        }
        if let createdby    = json["createdby"].int {
            
            self.createdby  = createdby
        }
        if let updatedby    = json["updatedby"].int {
            
            self.updatedby  = updatedby
        }
        
        
        
    }
}
