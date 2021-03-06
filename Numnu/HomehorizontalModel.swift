//
//  HomehorizontalModel.swift
//  Numnu
//
//  Created by CZ Ltd on 1/11/18.
//  Copyright © 2018 czsm. All rights reserved.
//

import Foundation
import SwiftyJSON


struct  HomehorizontalModel {
    
    var currentPage : Int?
    var limit       : Int?
    var hasPreviousPages : Bool?
    var hasMore : Bool?
    var totalRows : Int?
    var totalPages : Int?
    var previousPage_l : String?
    var currentPage_l  : String?
    var nextPage_l     : String?
    var listTitle      : String?
    var listIndex      : Int?
    var eventHorizontalList : [HomeSearchItem]?
    
//    sjdklsjdljk
    
    init?(json : JSON) {
        
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
        
        if let listTitle = json["listTitle"].string {
            
            self.listTitle = listTitle
        }
        
        if let listIndex = json["listIndex"].int {
            
            self.listIndex = listIndex
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
        
        /*****************Item Models******************************/
        
        if let datas = json["data"].array {
            
            for item in datas {
            
            if let Item = HomeSearchItem(json: item) {
                
                if eventHorizontalList == nil {
                    eventHorizontalList = []
                    
                }
                
                eventHorizontalList?.append(Item)
                
            }
                
            }
            
            
            
        }
        
    }
    
}
