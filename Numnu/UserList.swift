//
//  UserList.swift
//  
//
//  Created by Gowdhaman on 11/10/17.
//

import Foundation
import UIKit
import SwiftyJSON

struct  UserList {

    var tagList            :   [TagList]?
    var imgList            :   [ImgList]?
    var locList            :   [LocList]?
    
    var id                 :    Int?
    var username           :    String?
    var description        :    String?
    var firebaseuid        :    String?
    var dateofbirth        :    String?
    var gender             :    Int?
    var citylocationid     :    Int?
    var email              :    String?
    var isemailverified    :    String?
    var isbusiness         :    Int?
    var businessusername   :    String?
    var businessuserphone  :    String?
    var businessdescription:    String?
    var createdat          :    String?
    var updatedat          :    String?
    var createdby          :    String?
    var updatedby          :    String?
    var businessuseraddresslocationid: String?

    
    
    init?(json: JSON) {
        if let id = json["id"].int {
            
            self.id  = id
        }
        
        if let username = json["username"].string {
            
            self.username = username
            
        }
        
        if let description = json["description"].string {
            
            self.description = description
            
        }
        
        if let firebaseuid = json["firebaseuid"].string {
            
            self.firebaseuid = firebaseuid
        }
        
        if let dateofbirth = json["dateofbirth"].string {
            
            self.dateofbirth = dateofbirth
            
        }
        if let gender = json["gender"].int {
            
            self.gender = gender
            
        }
        
        if let citylocationid = json["citylocationid"].int {
            
            self.citylocationid = citylocationid
        }
        
        if let email = json["email"].string {
            
            self.email = email
            
        }
        if let isemailverified = json["isemailverified"].string {
            
            self.isemailverified = isemailverified
            
        }
        if let isbusiness = json["isbusiness"].int {
            
            self.isbusiness = isbusiness
            
        }
        if let businessusername = json["businessusername"].string {
            
            self.businessusername = businessusername
            
        }
        if let businessuserphone = json["businessuserphone"].string {
            
            self.businessuserphone = businessuserphone
            
        }
        if let businessdescription = json["businessdescription"].string {
            
            self.businessdescription = businessdescription
            
        }
        if let businessuseraddresslocationid = json["businessuseraddresslocationid"].string {
            
            self.businessuseraddresslocationid = businessuseraddresslocationid
            
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
        if let updatedby = json["updatedby"].string {
            
            self.updatedby = updatedby
            
        }
    
  //  ****************************************** image *********************************************************
        
        if let imgArray = json["userimages"].array {
          
            for item in imgArray {
                
                let imgItem = ImgList(array: item)
                if imgList == nil {
                    imgList = []
                }
                imgList?.append(imgItem)
       
            }
        }

//  ****************************************** tag *********************************************************
        if let tagArray = json["tags"].array {
            
            for item in tagArray {
                
                let tagItem = TagList(array: item)
                if tagList == nil {
                    tagList = []
                }
                tagList?.append(tagItem)
                
                
            }
        }
//  ****************************************** location *********************************************************
        
        if let locArray = json["citylocation"].array {
            
            for item in locArray {
                
                let locItem = LocList(array: item)
                if locList == nil {
                    locList = []
                }
                locList?.append(locItem)
                
                }
            }
        
         }
    
      }//class
