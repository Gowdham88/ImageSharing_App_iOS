//
//  EventModelList.swift
//  Numnu
//
//  Created by CZ Ltd on 11/21/17.
//  Copyright © 2017 czsm. All rights reserved.
//



import Foundation
import UIKit
import SwiftyJSON

struct EventModelList {
    
    var eventList   : [EventList]?
   
    init?(json: JSON) {
        
        if let eventlist = json[""].array {
            
            for item in eventlist {
                
                if let eventItem = EventList(json: item) {
                
                if eventList == nil {
                    
                    eventList = []
                }
                
                eventList?.append(eventItem)
                    
                }
                
            }
          
            
            
        }


    }

}
