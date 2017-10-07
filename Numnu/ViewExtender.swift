//
//  ViewExtender.swift
//  Numnu
//
//  Created by CZ Ltd on 10/7/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import UIKit



@IBDesignable
class ViewExtender : UIView {
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var backgroundcolor: UIColor = UIColor.white {
        didSet {
            layer.backgroundColor = backgroundcolor.cgColor
        }
    }
    
    
    @IBInspectable var cornurRadius: CGFloat = 1.0 {
        didSet {
            layer.cornerRadius = cornurRadius
            clipsToBounds = true
        }
    }
    
    //MARK: Initializers
    override init(frame : CGRect) {
        super.init(frame : frame)
        setup()
        configure()
    }
    
    convenience init() {
        self.init(frame:CGRect.zero)
        setup()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        configure()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        configure()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
        configure()
    }
    
    func setup() {
        layer.backgroundColor = UIColor.white.cgColor
        layer.cornerRadius = 1.0
    }
    
    func configure() {
        layer.backgroundColor = backgroundcolor.cgColor
        layer.cornerRadius = cornurRadius
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
