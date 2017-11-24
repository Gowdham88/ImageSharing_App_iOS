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

    var id         : String?
    var useremail  : String?
    var userName   : String?
    var firstName  : String?
    var lastName   : String?
    var firebaseUID  : String?
    var imageURLs   : String?
    var dateOfBirth   : String?
    var gender  : String?
    var userCity   : String?
    var tagidArray : [Int]?
    var tagNameArray    : [String]?
    var tagList : [TagList]?
    
    init?(json: JSON) {
        if let id = json["id"].string {
            
            self.id  = id
        }
        
        if let userName = json["userName"].string {
            
            self.userName = userName
            
        }
        
        if let firstName = json["firstName"].string {
            
            self.firstName = firstName
            
        }
        
        if let lastName = json["lastName"].string {
            
            self.lastName = lastName
        }
        
        if let firebaseUID = json["firebaseUID"].string {
            
            self.firebaseUID = firebaseUID
            
        }
        if let imageURLs = json["imageURLs"].string {
            
            self.imageURLs = imageURLs
            
        }
        
        if let dateOfBirth = json["dateOfBirth"].string {
            
            self.dateOfBirth = dateOfBirth
        }
        
        if let gender = json["gender"].string {
            
            self.gender = gender
            
        }
        if let userCity = json["userCity"].string {
            
            self.userCity = userCity
            
        }
        
        /******************sign up************************/
        
        if let tagArray = json["userTags"].array {
          
            for item in tagArray {
                
                let tagItem = TagList(array: item)
                if tagList == nil {
                    tagList = []
                }
                tagList?.append(tagItem)
       
            }
        }
        
        /******************Complete sign up************************/
        
        if let tagArray = json["tags"].array {
            
            for item in tagArray {
                
                let tagItem = TagList(array: item)
                if tagList == nil {
                    tagList = []
                }
                tagList?.append(tagItem)
                
                
            }
        }
       
    }
}
