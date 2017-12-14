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
  
        if let currentPage = json["currentPage"].int {
            
            self.currentPage  = currentPage
        }
    
        if let limit = json["limit"].int {
            
            self.limit  = limit
        }
        
        if let hasPreviousPages = json["hasPreviousPages"].bool {
            
            self.hasPreviousPages  = hasPreviousPages
        }
        
        if let hasMore = json["hasMore"].bool {
            
            self.hasMore  = hasMore
        }
        
        if let totalRows = json["totalRows"].int {
            
            self.totalRows  = totalRows
        }
        
        if let totalPages = json["totalPages"].int {
            
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
