//
//  BusinessTypeModel.swift
//  Numnu
//
//  Created by CZ Ltd on 12/15/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import SwiftyJSON

class BusinessTypeModel {
    
    var id           : Int?
    var name         : String?
    var description  : String?
    var imageurl     : String?
    
   
    //    *********************************************************
    init(array : JSON) {
        
        if let id = array["id"].int {
            
            self.id  = id
        }
        
        if let name = array["name"].string {
            
            self.name = name
            
        }
        if let description = array["description"].string {
            
            self.description = description
            
        }
        if let imageurl = array["imageurl"].string {
            
            self.imageurl = imageurl
            
        }
        
        
        
    }
    
    
    
    
}
