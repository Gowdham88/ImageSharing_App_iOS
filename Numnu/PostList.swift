//
//  PostList.swift
//  Numnu
//
//  Created by CZ Ltd on 9/18/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


class PostList : NSObject {
    
    var id                : String?
    var userid            : String?
    var name              : String?
    var postdatetime      : String?
    var rating            : String?
    var comment           : String?
    var photourl          : String?
    var cityname          : String?
    var taglist           : String?
    var itemlist          = [NSDictionary]()
    var bussinesslist     = [NSDictionary]()
    var eventlist         = [NSDictionary]()
    
    override init() {
        
    }
    
    
    init(dictionary : [String : AnyObject]) {
        super.init()
        
        id             = dictionary["id"] as? String   ?? "error"
        userid         = dictionary["userid"] as? String   ?? "error"
        name           = dictionary["name"] as? String   ?? "error"
        postdatetime   = dictionary["postdatetime"] as? String ?? "error"
        rating         = dictionary["rating"] as? String ?? "error"
        comment        = dictionary["comment"] as? String ?? "error"
        photourl       = dictionary["photourl"] as? String ?? "error"
        cityname       = dictionary["cityname"] as? String ?? "error"
        taglist        = dictionary["taglist"] as? String ?? "error"
        if let itemdic = dictionary["itemlist"] as? [NSDictionary] {
            
            itemlist   = itemdic
        }
        
        if let bussinessdic = dictionary["bussinesslist"] as? [NSDictionary] {
            
            bussinesslist    = bussinessdic
        }
        
        if let eventdic = dictionary["eventlist"] as? [NSDictionary] {
            
            eventlist    = eventdic
        }
        
    }
}
