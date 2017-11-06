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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    foodtagLabel.layer.cornerRadius = 10
    foodtagLabel.clipsToBounds = true

    
    }
}
