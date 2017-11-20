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
    
    func getLabelHeight(text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let lbl = UILabel(frame: .zero)
        lbl.frame.size.width = width
        lbl.font = font
        lbl.numberOfLines = 0
        lbl.text = text
        lbl.sizeToFit()
        
        return lbl.frame.size.height
    }
    
    func getLabelWidth(text: String,font: UIFont) -> CGFloat {
        
        let size = text.size(attributes: [NSFontAttributeName: font])
        return size.width
    }
    
    func getNumberoflines(text: String, width: CGFloat, font: UIFont)-> Int {
        
        let lbl = UILabel(frame: .zero)
        lbl.frame.size.width = width
        lbl.frame.size.height = 44
        lbl.font = font
        lbl.text = text
        return lbl.numberOfVisibleLines
        
    }
    
}
