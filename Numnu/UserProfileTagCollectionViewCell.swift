//
//  UserProfileTagCollectionViewCell.swift
//  Numnu
//
//  Created by CZSM3 on 16/11/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

class UserProfileTagCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tagLabel: UILabel!
    func setLabelSize(size : CGSize) {
        
        tagLabel.backgroundColor     = UIColor.tagBgColor()
        tagLabel.textColor           = UIColor.tagTextColor()
        tagLabel.layer.cornerRadius  = 4
        tagLabel.layer.masksToBounds = true
        tagLabel.textAlignment = .center
        tagLabel.frame = CGRect(x: 0, y: 0, width: size.width+20, height: 22)
        
    }
    
}
