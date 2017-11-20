//
//  SettingsTableViewCell.swift
//  Numnu
//
//  Created by Gowdhaman on 02/11/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet var rightarrowButton: UIButton!
    @IBAction func didTappedRightArrow(_ sender: Any) {
        
    }
    @IBOutlet var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
