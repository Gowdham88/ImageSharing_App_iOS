//
//  ItemList.swift
//  Numnu
//
//  Created by CZ Ltd on 11/21/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct ItemList {
    
    var id              : Int?
    var name            : String?
    var description     : String?
    var displayorder    : Int?
    var businessuserid  : Int?
    var businessname    : String?
    var updatedat       : String?
    var createdat       : String?
    var createdby       : Int?
    var updatedby       : Int?
    var itemImageList   : [ItemImageList]?
    var itemLinkList    : [ItemLinkList]?
    var tagList         : [TagList]?
    
    
    init?(json: JSON) {
        
        if let id = json["id"].int {
            
            self.id  = id
        }
        
        if let name = json["name"].string {
            
            self.name = name
            
        }
        
        if let description = json["description"].string {
            
            self.description = description
            
        }
        
        if let displayorder = json["displayorder"].int {
            
            self.displayorder = displayorder
        }
        
        if let businessuserid = json["businessuserid"].int {
            
            self.businessuserid = businessuserid
        }
        
        if let businessname  = json["businessname"].string {
            
            self.businessname = businessname
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
        
        if let itemImages  = json["itemimages"].array {
            
            for item in itemImages {
                
                if let imageItem = ItemImageList(json: item) {
                    
                    if itemImageList == nil {
                        
                        itemImageList = []
                    }
                    
                    itemImageList?.append(imageItem)
                }
                
            }
            
        }
        
        if let itemLinks  = json["itemlinks"].array {
            
            for item in itemLinks {
                
                if let linksItem = ItemLinkList(json: item) {
                    
                    if itemLinkList == nil {
                        
                        itemLinkList = []
                    }
                    
                    itemLinkList?.append(linksItem)
                }
                
            }
            
        }
        
        if let tagArray = json["tags"].array {
            
            for item in tagArray {
                
                let tagItem = TagList(array: item)
                if tagList == nil {
                    tagList = []
                }
                tagList?.append(tagItem)
                
                
            }
        }
        
    }
    
}
