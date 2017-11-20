//
//  EventTagCollectionCell.swift
//  Numnu
//
//  Created by CZ Ltd on 10/22/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

class EventTagCollectionCell: UICollectionViewCell {
  
    @IBOutlet weak var tagnamelabel: UILabel!
    
    func setLabelSize(size : CGSize) {
        
        tagnamelabel.backgroundColor     = UIColor.tagBgColor()
        tagnamelabel.textColor           = UIColor.tagTextColor()
        tagnamelabel.layer.cornerRadius  = 4
        tagnamelabel.layer.masksToBounds = true
        tagnamelabel.textAlignment = .center
        tagnamelabel.frame = CGRect(x: 0, y: 0, width: size.width+20, height: 22)
        
    }
}
