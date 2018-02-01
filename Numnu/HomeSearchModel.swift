//
//  HomeSearchModel.swift
//  Numnu
//
//  Created by CZ Ltd on 1/5/18.
//  Copyright © 2018 czsm. All rights reserved.
//

import Foundation
import SwiftyJSON


struct  HomeSearchModel{
    
    var currentPage : Int?
    var limit       : Int?
    var hasPreviousPages : Bool?
    var hasMore : Bool?
    var totalRows : Int?
    var totalPages : Int?
    var previousPage_l : String?
    var currentPage_l  : String?
    var nextPage_l     : String?
    var itemList    : [ItemList]?
    var eventList   : [EventTypeListItem]?
    var postList    : [PostListDataItems]?
    var businessList : [BussinessEventList]?
    var userList     : [UserHomeList]?
    
    init?(json : JSON,type : String){
        
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
        
        /*****************Item Models******************************/
        
        if let datas = json["data"].array {
            
            for item in datas {
                
               switch  type {
                
               case "events":
                
                if let Item = EventTypeListItem(json: item) {
                    
                    if eventList == nil {
                        eventList = []
                        
                    }
                    
                    eventList?.append(Item)
                    
                }
                
               case "items":
                
                if let Item = ItemList(json: item) {
                    
                    if itemList == nil {
                        itemList = []
                        
                    }
                    
                    itemList?.append(Item)
                    
                }
                
               case "businesses":
                
                if let Item = BussinessEventList(json: item) {
                    
                    if businessList == nil {
                        businessList = []
                        
                    }
                    
                    businessList?.append(Item)
                    
                }
                
               case "posts":
                
                if let Item = PostListDataItems(json: item) {
                    
                    if postList == nil {
                        postList = []
                        
                    }
                    
                    postList?.append(Item)
                    
                }
               
                
               case "users":
                
                if let Item = UserHomeList(json: item) {
                    
                    if userList == nil {
                        userList = []
                        
                    }
                    
                    userList?.append(Item)
                    
                }
                
                default:
                
                    if let Item = ItemList(json: item) {
                        
                        if itemList == nil {
                            itemList = []
                            
                        }
                        
                        itemList?.append(Item)
                        
                 }
                
            }
                
                
            }
            
        }
        
    }
    
}
