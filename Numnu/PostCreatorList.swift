//
//  PostCreatorList.swift
//  Numnu
//
//  Created by Siva on 14/12/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PostCreatorList {
    
    var id         : Int?
    var name       : String?
    var username   : String?
    var userimages : [ImgList]?
    
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
        
        if let imgArray = json["userimages"].array {
            
            for item in imgArray {
                
                let imgItem = ImgList(array: item)
                if userimages == nil {
                    userimages = []
                }
                
                userimages?.append(imgItem)
                
            }
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
}
