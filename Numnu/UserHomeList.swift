//
//  UserHomeList.swift
//  Numnu
//
//  Created by CZ Ltd on 1/5/18.
//  Copyright © 2018 czsm. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct UserHomeList {
    
    var id              : Int?
    var name            : String?
    var username        : String?
    var description     : String?
    var userImageList   : [ItemImageList]?
    var tagList         : [TagList]?
   
    
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
       
        
        if let itemImages  = json["userimages"].array {
            
            for item in itemImages {
                
                if let imageItem = ItemImageList(json: item) {
                    
                    if userImageList == nil {
                        
                        userImageList = []
                    }
                    
                    userImageList?.append(imageItem)
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
