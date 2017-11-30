//
//  LocList.swift
//  Numnu
//
//  Created by Suraj B on 11/29/17.
//  Copyright © 2017 czsm. All rights reserved.
//


import Foundation
import SwiftyJSON

class LocList {
    
    var id               : [Int]?
    var name             : [String]?
    var address          : [String]?
    var lattitude        : [String]?
    var longitude        : [String]?
    var isgoogleplace    : [Int]?
    var googleplaceid    : [String]?
    var googleplacetype  : [String]?
    var createdat        : [String]?
    var updatedat        : [String]?
    var createdby        : [Int]?
    var updatedby        : [Int]?
    
    
    
    var id_str               : Int?
    var name_str             : String?
    var address_str          : String?
    var lattitude_str        : String?
    var longitude_str        : String?
    var isgoogleplace_str    : Int?
    var googleplaceid_str    : String?
    var googleplacetype_str  : String?
    var createdat_str        : String?
    var updatedat_str        : String?
    var createdby_str        : Int?
    var updatedby_str        : Int?
    
    init?(json: JSON) {
        
        if let locArray = json["citylocation"].array {
            
            for item in locArray {
                
                let tag_id   = item["id"].int ?? 0
                let tag_name = item["name"].string ?? "empty"
                let tag_address = item["address"].string ?? "empty"
                let tag_lattitude = item["lattitude"].string ?? "empty"
                let tag_longitude = item["longitude"].string ?? "empty"
                let tag_isgoogleplace = item["isgoogleplace"].int ?? 0
                let tag_googleplaceid = item["googleplaceid"].string ?? "empty"
                let tag_googleplacetype = item["googleplacetype"].string ?? "empty"
                let tag_createdat = item["createdat"].string ?? "empty"
                let tag_updatedat = item["updatedat"].string ?? "empty"
                let tag_createdby = item["createdby"].int ?? 0
                let tag_updatedby = item["updatedby"].int ?? 0




                
                
                if id == nil {
                    id = []
                }
                
                if name == nil {
                    
                    name = []
                    
                }
                if address == nil {
                    
                    address = []
                    
                }
                if lattitude == nil {
                    
                    lattitude = []
                    
                }
                if longitude == nil {
                    
                    longitude = []
                    
                }
                if isgoogleplace == nil {
                    
                    isgoogleplace = []
                    
                }
                if googleplaceid == nil {
                    
                    googleplaceid = []
                    
                }
                if googleplacetype == nil {
                    
                    googleplacetype = []
                    
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
                name?.append(tag_name)
                address?.append(tag_address)
                lattitude?.append(tag_lattitude)
                longitude?.append(tag_longitude)
                isgoogleplace?.append(tag_isgoogleplace)
                googleplaceid?.append(tag_googleplaceid)
                googleplacetype?.append(tag_googleplacetype)
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
        
        if let name = array["name"].string {
            
            self.name_str = name
            
        }
        if let address = array["address"].string {
            
            self.address_str = address
            
        }
        if let lattitude = array["lattitude"].string {
            
            self.lattitude_str = lattitude
            
        }
        if let longitude = array["longitude"].string {
            
            self.longitude_str = longitude
            
        }
        if let isgoogleplace = array["isgoogleplace"].int {
            
            self.isgoogleplace_str = isgoogleplace
            
        }
        if let googleplaceid = array["googleplaceid"].string {
            
            self.googleplaceid_str = googleplaceid
            
        }
        if let googleplacetype = array["googleplacetype"].string {
            
            self.googleplacetype_str = googleplacetype
            
        }
        if let createdat = array["createdat"].string {
            
            self.createdat_str = createdat
            
        }
        if let updatedat = array["updatedat"].string {
            
            self.updatedat_str = updatedat
            
        }
        if let createdby = array["createdby"].int {
            
            self.createdby_str = createdby
            
        }
        if let updatedby = array["updatedby"].int {
            
            self.updatedby_str = updatedby
            
        }
   
    }
 
}//class


