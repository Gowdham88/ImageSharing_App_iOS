//
//  NotificationsTableViewCell.swift
//  Numnu
//
//  Created by CZ Ltd on 10/12/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var userDP: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var notificationLabel: UILabel!
    @IBOutlet var accessoryButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userDP.layer.cornerRadius = self.userDP.frame.size.height/2
        userDP.clipsToBounds = true
        accessoryButton.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
