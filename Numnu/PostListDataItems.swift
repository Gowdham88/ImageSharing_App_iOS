//
//  PostListDataItems.swift
//  Numnu
//
//  Created by Siva on 14/12/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PostListDataItems {
    
    var id    : Int?
    var rating: Int?
    var comment: String?
    var createdat : String?
    var updatedat : String?
    var location : LocList?
    var tags : [TagList]?
    var postimages : [ImgList]?
    var event : EventList?
    var business : BussinessEventList?
    var postcreator : PostCreatorList?
    var taggedItemName : String?
    var taggedItemId   : Int?
    
    init?(json: JSON) {
    
        if let id    = json["id"].int {
            
            self.id  = id
        }
        
        if let rating    = json["rating"].int {
            
            self.rating  = rating
        }
        if let comment   = json["comment"].string {
            self.comment = comment
        }
        if let createdat = json["createdat"].string {
            
            self.createdat = createdat
            
        }
        
        if let updatedat = json["updatedat"].string {
            
            self.updatedat = updatedat
            
        }
        
      
        if let tagitems = json["tags"].array {
            
            for item in tagitems {
                
                let taglistItem = TagList(array: item)
                
                if tags == nil {
                    tags = []
                    
                }
                
                tags?.append(taglistItem)
                
            }
            
        }
        if let tagitemname = json["taggeditems"].array {
            
            for item in tagitemname {
                
                if let name = item["name"].string {
                    
                    self.taggedItemName = name
                    
                }
                if let taggedid = item["id"].int {
                    
                    self.taggedItemId = taggedid
                    
                }
                
            }
            
        }
    
        if let imgArray = json["postimages"].array {
            
            for item in imgArray {
                
                let imgItem = ImgList(array: item)
                if postimages == nil {
                    postimages = []
                }
                
                postimages?.append(imgItem)
                
            }
        }
    
        let jsoncity = JSON(json["location"])
        if let citylocation = LocList(array: jsoncity) {
            
            self.location = citylocation
            
        }
        
        let event = JSON(json["event"])
        if let event = EventList(json: event) {
            
            self.event = event
            
        }
        
        let business = JSON(json["business"])
        if let business = BussinessEventList(json: business) {
            
            self.business = business
            
        }
        let postr = JSON(json["postcreator"])
        if let postcreator = PostCreatorList(json: postr) {
            
            self.postcreator = postcreator
            
        }
    
    
    }
    
    
    
    
}
