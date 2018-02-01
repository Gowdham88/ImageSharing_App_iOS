//
//  HomeSearchItem.swift
//  Numnu
//
//  Created by CZ Ltd on 1/11/18.
//  Copyright © 2018 czsm. All rights reserved.
//

import Foundation
import SwiftyJSON


struct HomeSearchItem {
    
//    dsldkskd
    
    var id              : Int?
    var businessuserid  : Int?
    var ispublished     : Int?
    var startsat        : String?
    var endsat          : String?
    var name            : String?
    var description     : String?
   
    var businessname    : String?
    var createdat       : String?
    var updatedat       : String?
    
    var taglist         : [TagList]?
    var imgList         : [ImgList]?
    
    
    init?(json: JSON) {
        
        if let id = json["id"].int {
            
            self.id  = id
        }
        
        if let businessuserid = json["businessuserid"].int {
            
            self.businessuserid = businessuserid
            print("business user id is:::::",businessuserid)
            
        }
        
        if let businessname = json["businessname"].string {
            
            self.businessname = businessname
           
            
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
        
        if let createdat = json["createdat"].string {
            
            self.createdat = createdat
            
        }
        
        if let updatedat = json["updatedat"].string {
            
            self.updatedat = updatedat
            
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
        
        /****************************************** image *********************************************************/
        
        if let imgArray = json["itemimages"].array {
            
            for item in imgArray {
                
                let imgItem = ImgList(array: item)
                if imgList == nil {
                    imgList = []
                }
                
                imgList?.append(imgItem)
                
            }
        }
        
        
        
    }
}
