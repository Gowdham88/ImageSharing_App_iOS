//
//  EventDefaulCollectionCell.swift
//  Numnu
//
//  Created by CZ Ltd on 10/24/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

class EventDefaulCollectionCell : UICollectionViewCell {
    
    
    @IBOutlet weak var eventLocationname: UILabel!
    @IBOutlet weak var eventLabelname: UILabel!
    @IBOutlet weak var eventImage: ImageExtender!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.eventImage.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.eventImage.layer.shadowOpacity = 0.75
        self.eventImage.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        self.eventImage.layer.shadowRadius = 7.0
        self.eventImage.layer.cornerRadius = 5.0
        self.eventImage.layer.masksToBounds = false
        self.eventImage.clipsToBounds = true
//        self.eventImage.clipsToBounds = true
    }

    
}
