//
//  EventItemTagModel.swift
//  Numnu
//
//  Created by CZ Ltd on 12/12/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import SwiftyJSON


struct EventItemTagModel {
    
    
    var currentPage : Int?
    var limit       : Int?
    var hasPreviousPages : Bool?
    var hasMore : Bool?
    var totalRows : Int?
    var totalPages : Int?
    var previousPage_l : String?
    var currentPage_l  : String?
    var nextPage_l     : String?
    var tagItemList    : [EventItemtag]?
    
    init?(json : JSON){
        
        let jsonpage = JSON(json["pagination"])
        
        if let currentPage = jsonpage["currentPage"].int {
            
            self.currentPage  = currentPage
        }
        
        if let limit = jsonpage["limit"].int {
            
            self.limit = limit
            
        }
        
        if let hasPreviousPages = jsonpage["hasPreviousPages"].bool {
            
            self.hasPreviousPages = hasPreviousPages
            
        }
        
        if let hasMore = jsonpage["hasMore"].bool {
            
            self.hasMore = hasMore
        }
        
        if let totalRows = jsonpage["totalRows"].int {
            
            self.totalRows = totalRows
            
        }
        if let totalPages = jsonpage["totalPages"].int {
            
            self.totalPages = totalPages
            
        }
        
        if let previousPage_l = jsonpage["previousPage_l"].string {
            
            self.previousPage_l = previousPage_l
        }
        
        if let currentPage_l = jsonpage["currentPage_l"].string {
            
            self.currentPage_l = currentPage_l
            
        }
        if let nextPage_l = jsonpage["nextPage_l"].string {
            
            self.nextPage_l = nextPage_l
            
        }
        
        if let events = json["data"].array {
            
            for item in events {
                
                if let tagItem = EventItemtag(json: item) {
                    
                    if tagItemList == nil {
                        tagItemList = []
                        
                    }
                    
                    tagItemList?.append(tagItem)
                    
                }
                
                
            }
            
        }
        
    }
    
}
