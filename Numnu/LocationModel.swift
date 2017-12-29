//
//  LocationModel.swift
//  Numnu
//
//  Created by Suraj B on 12/29/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct LocationModel {
    
    var id              : Int?
    var name            : String?
    var address         : String?
    var lattitude       : String?
    var longitude       : String?
    var isgoogleplace   : Bool?
    var googleplaceid   : String?
    var googleplacetype : String?
    var type            : Int?
    var createdat       : String?
    var updatedat       : String?
    
    
    var imageurl         : [String]?
    var imagecreatedat        : [String]?


    var createdby       : String?
    var updatedby       : String?


    var locationimages   : [ItemImageList]?
    var tag              : [TagList]?
    var business         : BusinessDetailModel?
    
    init?(json: JSON) {
        
        if let id = json["id"].int {
            
            self.id  = id
        }
        
        if let name = json["name"].string {
            
            self.name = name
            
        }
        
        if let address = json["address"].string {
            
            self.address = address
            
        }
        
        if let lattitude = json["displayorder"].string {
            
            self.lattitude = lattitude
        }
        
        if let longitude = json["longitude"].string {
            
            self.longitude = longitude
        }
        
        if let isgoogleplace  = json["isgoogleplace"].bool {
            
            self.isgoogleplace = isgoogleplace
        }
        
        if let googleplaceid = json["googleplaceid"].string {
            
            self.googleplaceid = googleplaceid
            
        }
        if let googleplacetype = json["googleplacetype"].string {
            
            self.googleplacetype = googleplacetype
            
        }
        
        if let type = json["type"].int {
            
            self.type = type
        }
        
        if let createdat = json["createdat"].string {
            
            self.createdat = createdat
            
        }
        if let updatedat = json["updatedat"].string {
            
            self.updatedat = updatedat
            
        }
        if let createdby = json["createdby"].string {
            
            self.createdby = createdby
            
        }
        
//        if let itemImages  = json["locationimages"].array {
//
//            for item in itemImages {
//                let tag_imageurl  = item["imageurl"].string ??  "empty"
//                let tag_createdat = item["createdat"].string ?? "empty"
//                if let imageItem = locationimages(json: item) {
//
//                    if locationimages == nil {
//
//                        locationimages = []
//                    }
//
//                    locationimages?.append(imageItem)
//                }
//
//            }
//
//        }
        if let imgArray = json["locationimages"].array  {
            
            for item in imgArray {
                
                let tag_imageurl  = item["imageurl"].string ??  "empty"
                let tag_createdat = item["createdat"].string ?? "empty"
                
                if imageurl == nil {
                    
                    imageurl = []
                    
                }
                if imagecreatedat == nil {
                    
                    imagecreatedat = []
                    
                }
                
                imageurl?.append(tag_imageurl)
                createdat?.append(tag_createdat)
                
                
            }
        }

        /********************Business Entity Model***************************/
        
        let jsonpage = JSON(json["business"])
        if let businessEntityItem = BusinessDetailModel(json: jsonpage) {
            
            business = businessEntityItem
            
        }
        
        if let tagArray = json["tags"].array {
            
            for item in tagArray {
                
                let tagItem = TagList(array: item)
                if tag == nil {
                    tag = []
                }
                tag?.append(tagItem)
                
                
            }
        }
        
    }
    
}//class
