//
//  FoodPreferenceCollectionViewCell.swift
//  Numnu
//
//  Created by Gowdhaman on 06/11/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

class FoodPreferenceCollectionViewCell: UICollectionViewCell {
    @IBOutlet var foodtagLabel: UILabel!

    @IBOutlet var removetagButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    func setLabelSize(size : CGSize) {
        
        foodtagLabel.backgroundColor     = UIColor.tagBgColor()
        foodtagLabel.textColor           = UIColor.tagTextColor()
        foodtagLabel.layer.cornerRadius  = 4
        foodtagLabel.layer.masksToBounds = true
        foodtagLabel.textAlignment = .center
        foodtagLabel.frame = CGRect(x: 0, y: 0, width: size.width+20, height: 22)
        removetagButton.frame.origin.x = size.width+25

    }
}
