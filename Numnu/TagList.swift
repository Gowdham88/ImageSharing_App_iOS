//
//  TagList.swift
//  Numnu
//
//  Created by CZ Ltd on 11/20/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import SwiftyJSON

class TagList: NSObject,NSCoding {
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id_str,   forKey: "id_str")
        aCoder.encode(text_str, forKey: "text_str")
    
    }
    
    var id    : [Int]?
    var text  : [String]?
    
    var id_str   : Int?
    var text_str : String?
    
    override init() {
        
    }
    
    init(id_str : Int, text_str : String) {
        
        self.id_str     = id_str
        self.text_str   = text_str
     
    }
    
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
    
    
    required convenience init(coder aDecoder: NSCoder) {
        
        let id_str      = aDecoder.decodeObject(forKey: "id_str") as! Int
        let text_str    = aDecoder.decodeObject(forKey: "text_str") as! String
        self.init(id_str: id_str, text_str: text_str)
        
    }
  
}
