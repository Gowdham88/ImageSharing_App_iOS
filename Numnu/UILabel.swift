//
//  UILabel.swift
//  Numnu
//
//  Created by CZ Ltd on 10/22/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }
}
