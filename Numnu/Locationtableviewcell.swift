//
//  Locationtableviewcell.swift
//  Numnu
//
//  Created by CZ Ltd on 11/1/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

class Locationtableviewcell: UITableViewCell {
    
    
    @IBOutlet weak var locationPlace: UILabel!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locationImage: ImageExtender!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
   
}
