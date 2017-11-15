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
    
//        eventImage.layer.cornerRadius = 5.0
        
    }

    
}
