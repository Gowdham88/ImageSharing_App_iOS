//
//  ImgList.swift
//  Numnu
//
//  Created by Suraj B on 11/29/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import SwiftyJSON

class ImgList {
    
    var id         : [Int]?
    var userid     : [Int]?
    var imageurl   : [String]?
    var createdat  : [String]?
    var updatedat  : [String]?
    var createdby  : [String]?
    var updatedby  : [String]?

    var id_str        : Int?
    var userid_str    : Int?
    var imageurl_str  : String?
    var createdat_str : String?
    var updatedat_str : String?
    var createdby_str : String?
    var updatedby_str : String?

    /***************Tag Auto complete Api**********************/
    
    init?(json: JSON) {
        
        if let imgArray = json["userimages"].array {
            
            for item in imgArray {
                
                let tag_id   = item["id"].int ?? 0
                let tag_userid = item["userid"].int ?? 0
                let tag_imageurl = item["imageurl"].string ?? "empty"
                let tag_createdat = item["createdat"].string ?? "empty"
                let tag_updatedat = item["updatedat"].string ?? "empty"
                let tag_createdby = item["createdby"].string ?? "empty"
                let tag_updatedby = item["updatedby"].string ?? "empty"

        
                if id == nil {
                    id = []
                }
                
                if userid == nil {
                    
                    userid = []
                    
                }
                if imageurl == nil {
                    
                    imageurl = []
                    
                }
                if createdat == nil {
                    
                    createdat = []
                    
                }
                if updatedat == nil {
                    
                    updatedat = []
                    
                }
                if createdby == nil {
                    
                    createdby = []
                    
                }
                if updatedby == nil {
                    
                    updatedby = []
                    
                }
    
                id?.append(tag_id)
                userid?.append(tag_userid)
                imageurl?.append(tag_imageurl)
                createdat?.append(tag_createdat)
                updatedat?.append(tag_updatedat)
                createdby?.append(tag_createdby)
                updatedby?.append(tag_updatedby)

            }
        }
        
    }
    
    
//    *********************************************************
    init(array : JSON) {
        
        if let id = array["id"].int {
            
            self.id_str  = id
        }
        
        if let userid = array["userid"].int {
            
            self.userid_str = userid
            
        }
        if let imageurl = array["imageurl"].string {
            
            self.imageurl_str = imageurl
            
        }
        if let createdat = array["createdat"].string {
            
            self.createdat_str = createdat
            
        }
        if let updatedat = array["updatedat"].string {
            
            self.updatedat_str = updatedat
            
        }
        if let createdby = array["createdby"].string {
            
            self.createdby_str = createdby
            
        }
        if let updatedby = array["updatedby"].string {
            
            self.updatedby_str = updatedby
            
        }
        
        
    }
    
    
    
    
}

