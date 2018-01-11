//
//  HomehorizontalListModel.swift
//  Numnu
//
//  Created by CZ Ltd on 1/11/18.
//  Copyright © 2018 czsm. All rights reserved.
//

import Foundation
import SwiftyJSON


struct  HomehorizontalListModel {
    
//    dsdsds
    
    var eventList  : [HomehorizontalModel]?
    
     init?(json : [JSON]) {
        
        for item in json {
            
            if let Item = HomehorizontalModel(json: item) {
                
                if eventList == nil {
                    eventList = []
                    
                }
                
                eventList?.append(Item)
                
            }
            
        }
        
        
    }

}
