//
//  TextSize.swift
//  Numnu
//
//  Created by CZ Ltd on 10/22/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import UIKit


struct TextSize{
    
     static var sharedinstance = TextSize()
    
    func sizeofString(text : String,fontname : String,size : CGFloat) -> CGSize {
        
        if let font = UIFont(name: fontname, size: size)
        {
            let size = text.size(attributes: [NSFontAttributeName: font])
            return size
        }
       
        return CGSize(width: 0, height: 0)
        
    }
    
    
    
    
}
