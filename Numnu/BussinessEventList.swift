//
//  BussinessEventList.swift
//  Numnu
//
//  Created by CZ Ltd on 12/8/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import SwiftyJSON

struct  BussinessEventList {
    
    var id            : Int?
    var username      : String?
    var description   : String?
    var dateofbirth   : String?
    var gender        : Int?
    var email         : String?
    var isemailverified    : Bool?
    var businessusername   : String?
    var businessuserphone  : String?
    var businessdescription : String?
    
    var tagList            :   [TagList]?
    var imgList            :   [ImgList]?
    
    init?(json: JSON) {
        
        if let id = json["id"].int {
            
            self.id  = id
        }
        
        if let username = json["username"].string {
            
            self.username = username
            
        }
        
        if let description = json["description"].string {
            
            self.description = description
            
        }
        
        if let dateofbirth = json["dateofbirth"].string {
            
            self.dateofbirth = dateofbirth
            
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
        
        if let businessusername = json["businessusername"].string {
            
            self.businessusername = businessusername
        }
        
        if let businessuserphone = json["businessuserphone"].string {
            
            self.businessuserphone = businessuserphone
            
        }
        
        if let businessdescription = json["businessdescription"].string {
            
            self.businessdescription = businessdescription
            
        }
        
        /****************************************** image *********************************************************/
        
        if let imgArray = json["userimages"].array {
            
            for item in imgArray {
                
                let imgItem = ImgList(array: item)
                if imgList == nil {
                    imgList = []
                }
                imgList?.append(imgItem)
                
            }
        }
        
        /****************************************** tag *********************************************************/
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
