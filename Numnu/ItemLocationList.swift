//
//  ItemLocationList.swift
//  Numnu
//
//  Created by Siva on 26/12/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ItemLocationList {
    
    var location         : [LocList]?
    var createdat        : [String]?
    var currentPage      : Int?
    var limit            : Int?
    var hasPreviousPages : Bool?
    var hasMore          : Bool?
    var totalRows        : Int?
    var totalPages       : Int?

    
    
    init?(json: JSON) {
        let jsonpage          = JSON(json["pagination"])
        
        if let currentPage    = jsonpage["currentPage"].int {
            
            self.currentPage  = currentPage
        }
        
        if let limit          = jsonpage["limit"].int {
            
            self.limit        = limit
        }
        
        if let hasPreviousPages    = jsonpage["hasPreviousPages"].bool {
            
            self.hasPreviousPages  = hasPreviousPages
        }
        
        if let hasMore      = jsonpage["hasMore"].bool {
            
            self.hasMore    = hasMore
        }
        
        if let totalRows    = jsonpage["totalRows"].int {
            
            self.totalRows  = totalRows
        }
        
        if let totalPages   = jsonpage["totalPages"].int {
            
            self.totalPages = totalPages
        }
        

        
        if let jsoncity = json["data"].array {
            
            for item in jsoncity {
                if let citylocation = LocList(array: item) {
                    
                    if location == nil {
                        location = []
                    }
                    
                    self.location?.append(citylocation)
            }
       
            
        }
        }
    }
    
    
    
}

