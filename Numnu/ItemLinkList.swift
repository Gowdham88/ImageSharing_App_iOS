//
//  ItemLinkList.swift
//  Numnu
//
//  Created by CZ Ltd on 11/21/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ItemLinkList {
    
    var id              : Int?
    var itemid          : Int?
    var weblink         : String?
    var linktext        : String?
    var updatedat       : String?
    var createdat       : String?
    var createdby       : Int?
    var updatedby       : Int?
    
    init?(json: JSON) {
        
        if let id = json["id"].int {
            
            self.id  = id
        }
        
        if let itemid = json["itemid"].int {
            
            self.itemid = itemid
            
        }
        
        if let weblink = json["weblink"].string {
            
            self.weblink = weblink
            
        }
        
        if let linktext = json["linktext"].string {
            
            self.linktext = linktext
            
        }
        
        if let createdat = json["createdat"].string {
            
            self.createdat = createdat
            
        }
        if let updatedat = json["updatedat"].string {
            
            self.updatedat = updatedat
            
        }
        
        if let createdby = json["createdby"].int {
            
            self.createdby = createdby
        }
        
        if let updatedby = json["updatedby"].int {
            
            self.updatedby = updatedby
            
        }
        
    }
    
}
