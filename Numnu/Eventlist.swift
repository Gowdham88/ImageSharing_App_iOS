//
//  Eventlist.swift
//  Numnu
//
//  Created by Suraj B on 11/21/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct  EventList {
    
    var id              : Int?
    var businessuserid  : Int?
    var eventtypeid     : Int?
    var isdetailedcontentpublished   : Int?
    var ispublished     : Int?
    var startsat        : String?
    var endsat          : String?
    var name            : String?
    var description     : String?
    var locationid      : String?
    var locationsummary : String?
    var createdat       : String?
    var updatedat       : String?
    var eventLinkList   : [EventlinkList]?
    var taglist         : [TagList]?
    var loclist         : LocList?
    var imagelist       : [ImgList]?
    
    var name_Str : String?
    var id_Str   : Int?
    
    
    
    init?(json: JSON) {
    
        if let id = json["id"].int {
            
            self.id  = id
        }
        
        if let businessuserid = json["businessuserid"].int {
            
            self.businessuserid = businessuserid
            
        }
        
        if let eventtypeid = json["eventtypeid"].int {
            
            self.eventtypeid = eventtypeid
            
        }
        
        if let isdetailedcontentpublished = json["isdetailedcontentpublished"].int {
            
            self.isdetailedcontentpublished = isdetailedcontentpublished
        }
        
        if let startsat = json["startsat"].string {
            
            self.startsat = startsat
            
        }
        if let endsat = json["endsat"].string {
            
            self.endsat = endsat
            
        }
        
        if let name = json["name"].string {
            
            self.name = name
        }
        
        if let description = json["description"].string {
            
            self.description = description
            
        }
        if let locationid = json["locationid"].string {
            
            self.locationid = locationid
            
        }
        if let locationsummary = json["locationsummary"].string {
            
            self.locationsummary = locationsummary
            
        }
        if let createdat = json["createdat"].string {
            
            self.createdat = createdat
            
        }
        if let updatedat = json["updatedat"].string {
            
            self.updatedat = updatedat
            
        }

        if let eventlinks = json["eventlinks"].array {
            
            for item in eventlinks {
                
                if let eventlinksItem = EventlinkList(json: item) {
                
                if eventLinkList == nil {
                    eventLinkList = []
                    
                }
                
                eventLinkList?.append(eventlinksItem)
                    
                }
                
                
            }
            
        }
        
        if let tagitems = json["tags"].array {
            
            for item in tagitems {
                
                 let taglistItem = TagList(array: item)
                    
                    if taglist == nil {
                        taglist = []
                        
                    }
                    
                    taglist?.append(taglistItem)
                print("taglists::::::",taglist)
                    
                }
            
        }
        
        if let imgitems = json["eventimages"].array {
            
            for item in imgitems {
                
                let imglistItem = ImgList(array: item)
                
                if imagelist == nil {
                    imagelist = []
                    
                }
                
                imagelist?.append(imglistItem)
                
            }
            
        }
        
        let jsoncity = JSON(json["location"])
        if let citylocation = LocList(array: jsoncity) {
            
            self.loclist = citylocation
            
        }
        
    }
    
    init?(array : JSON) {
    
        if let name_Str = array["name"].string {
            
            self.name_Str = name_Str
        }
        
        if let id_Str = array["id"].int {
            
            self.id_Str = id_Str
        }
    
    }
        
}

