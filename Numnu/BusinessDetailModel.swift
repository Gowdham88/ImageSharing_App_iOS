//
//  businessapi.swift
//  Numnu
//
//  Created by CZ Ltd on 12/15/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct  BusinessDetailModel {
    
    var id              : Int?
    var name            : String?
    var username        : String?
    var description     : String?
    var firebaseuid     : String?
    var dateofbirth     : String?
    var gender          : Int?
    var email            : String?
    var isemailverified  : Bool?
    var businessname     : String?
    var businessusername : String?
    var businessuserphone  : String?
    var businessdescription : String?
    var eventLinkList   : [EventlinkList]?
    var taglist         : [TagList]?
    var loclist         : LocList?
    var businessloclist : LocList?
    var imagelist       : [ImgList]?
    var bussinessTypeList : [BusinessTypeModel]?
    
    var name_Str : String?
    var id_Str   : Int?
    
    
    
    init?(json: JSON) {
        
        if let id = json["id"].int {
            
            self.id  = id
        }
        
        if let name = json["name"].string {
            
            self.name = name
            
        }
        
        if let username = json["username"].string {
            
            self.username = username
            
        }
        
        if let description = json["description"].string {
            
            self.description = description
        }
        
        if let firebaseuid = json["firebaseuid"].string {
            
            self.firebaseuid = firebaseuid
            
        }
        if let dateofbirth = json["dateofbirth"].string {
            
            self.dateofbirth = dateofbirth
            
        }
        
        if let businessname = json["businessname"].string {
            
            self.businessname = businessname
        }
        
        if let businessusername = json["businessusername"].string {
            
            self.businessusername = businessusername
            
        }
        
        if let businessuserphone = json["businessuserphone"].string {
            
            self.businessuserphone = businessuserphone
            
        }
        
        if let businessdescription = json["businessdescription"].string {
            
            self.businessdescription = businessdescription
            
        }
        if let gender = json["gender"].int {
            
            self.gender = gender
            
        }
        if let email = json["email"].string {
            
            self.email = email
            
        }
        if let isemailverified = json["isemailverified"].bool {
            
            self.isemailverified = isemailverified
            
        }
        
        if let eventlinks = json["businesslinks"].array {
            
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
                
            }
            
        }
        
        if let imgitems = json["businessimages"].array {
            
            for item in imgitems {
                
                let imglistItem = ImgList(array: item)
                
                if imagelist == nil {
                    imagelist = []
                    
                }
                
                imagelist?.append(imglistItem)
                
            }
            
        }
        
        if let typeitems = json["businessimages"].array {
            
            for item in typeitems {
                
                let typlelistItem = BusinessTypeModel(array: item)
                
                if bussinessTypeList == nil {
                    bussinessTypeList = []
                    
                }
                
                bussinessTypeList?.append(typlelistItem)
                
            }
            
        }
        
        let jsoncity = JSON(json["citylocation"])
        if let citylocation = LocList(array: jsoncity) {
            
            self.loclist = citylocation
            
        }
        
        let jsonbusinesscity = JSON(json["businessuseraddresslocation"])
        if let businscitylocation = LocList(array: jsonbusinesscity) {
            
            self.businessloclist = businscitylocation
            
        }
        
    }
    
    
    
}
