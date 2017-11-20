//
//  ImageExtender.swift
//  Numnu
//
//  Created by CZ Ltd on 10/11/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ImageExtender : UIImageView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat = 2.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            clipsToBounds = true
        }
    }
    
}
