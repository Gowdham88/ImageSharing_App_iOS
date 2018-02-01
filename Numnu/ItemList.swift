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
    var itemname        : String?
    var description     : String?
    var itemdescription : String?
    var displayorder    : Int?
    var eventid         : Int?
    var eventname       : String?
    var businessuserid  : Int?
    var priceamount     : String?
    var currencyid      : Int?
    var currencycode    : String?
    var businessname    : String?
    var updatedat       : String?
    var createdat       : String?
    var createdby       : Int?
    var updatedby       : Int?
    var itemImageList   : [ItemImageList]?
    var itemLinkList    : [ItemLinkList]?
    var tagList         : [TagList]?
    var businessEntity  : BusinessDetailModel?
    
    init?(json: JSON) {
        
        if let id = json["id"].int {
            
            self.id  = id
        }
        
        if let name = json["name"].string {
            
            self.name = name
            
        }
        
        if let itemname = json["itemname"].string {
            
            self.itemname = itemname
            
        }
        
        if let description = json["description"].string {
            
            self.description = description
            
        }
        
        if let itemdescription = json["itemdescription"].string {
            
            self.itemdescription = itemdescription
            
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
        
        if let eventid = json["eventid"].int {
            
            self.eventid = eventid
            
        }
        
        if let eventname = json["eventname"].string {
            
            self.eventname = eventname
            
        }
        
        if let priceamount = json["priceamount"].string {
            
            self.priceamount = priceamount
            
        }
        
        if let currencyid = json["currencyid"].int {
            
            self.currencyid = currencyid
            
        }
        
        if let currencycode = json["currencycode"].string {
            
            self.currencycode = currencycode
            
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
        
        /********************Business Entity Model***************************/
        
        let jsonpage = JSON(json["business"])
        if let businessEntityItem = BusinessDetailModel(json: jsonpage) {
            
            businessEntity = businessEntityItem
            
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
        
        
        if let tagArray = json["itemtags"].array {
            
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
