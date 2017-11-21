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
    
    var id_str   : Int?
    var text_str : String?
    
    /***************Tag Auto complete Api**********************/
  
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
    
    /*************** sign up**********************/
    
    init(array : JSON) {
        
        if let id = array["id"].int {
            
            self.id_str  = id
        }
        
        if let text = array["text"].string {
            
            self.text_str = text
            
        }
        
    }
    
    
    

}
