//
//  PostListByEventId.swift
//  Numnu
//
//  Created by Siva on 14/12/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct  PostListByEventId {
    
    var currentPage      : Int?
    var limit            : Int?
    var hasPreviousPages : Bool?
    var hasMore          : Bool?
    var totalRows        : Int?
    var totalPages       : Int?
    
    var data  : [PostListDataItems]?
    
    init?(json: JSON) {
        let jsonpage = JSON(json["pagination"])
  
        if let currentPage = jsonpage["currentPage"].int {
            
            self.currentPage  = currentPage
        }
    
        if let limit = jsonpage["limit"].int {
            
            self.limit  = limit
        }
        
        if let hasPreviousPages = jsonpage["hasPreviousPages"].bool {
            
            self.hasPreviousPages  = hasPreviousPages
        }
        
        if let hasMore = jsonpage["hasMore"].bool {
            
            self.hasMore  = hasMore
        }
        
        if let totalRows = jsonpage["totalRows"].int {
            
            self.totalRows  = totalRows
        }
        
        if let totalPages = jsonpage["totalPages"].int {
            
            self.totalPages  = totalPages
        }
        
        if let datalinks = json["data"].array {
            
            for item in datalinks {
                
                if let datalinksItem = PostListDataItems(json: item) {
                    
                    if data == nil {
                        data = []
                        
                    }
                    
                    data?.append(datalinksItem)
                    
                }
                
                
            }
            
        }
    }
   
    
}
