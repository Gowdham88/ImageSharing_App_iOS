//
//  EventListItem.swift
//  Numnu
//
//  Created by CZ Ltd on 12/11/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import SwiftyJSON


struct EventTypeListItem {
    
    var id              : Int?
    var name            : String?
    var description     : String?
    var imageurl        : String?
    
    init?(json : JSON){
        
        if let id = json["id"].int {
            
            self.id  = id
        }
        
        if let name = json["name"].string {
            
            self.name = name
            
        }
        
        if let description = json["description"].string {
            
            self.description = description
            
        }
        
        if let imageurl = json["imageurl"].string {
            
            self.imageurl = imageurl
        }
        
        
        
    }
}

