//
//  TagList.swift
//  Numnu
//
//  Created by CZ Ltd on 11/20/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import SwiftyJSON

class TagList {
    
    var id    : [Int]?
    var text  : [String]?
  
    init?(json: JSON) {
   
        if let tagArray = json["tagsuggestions"].array {
            
            for item in tagArray {
                
                let tag_id   = item["id"].int ?? 0
                let tag_name = item["text"].string ?? "empty"
                
                if id == nil {
                    id = []
                }
                
                if text == nil {
                    
                    text = []
                    
                }
                
                id?.append(tag_id)
                text?.append(tag_name)
                
            }
        }
        
    }
    

}
