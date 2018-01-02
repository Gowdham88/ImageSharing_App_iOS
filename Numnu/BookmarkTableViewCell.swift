//
//  BookmarkTableViewCell.swift
//  Numnu
//
//  Created by Siva on 02/01/18.
//  Copyright © 2018 czsm. All rights reserved.
//

import UIKit

class BookmarkTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var item : BookmarksDataItems! {
        didSet {
            if let name = item.entityname {
                nameLabel.text = name
            }
            
            
        }
        
        
        
        
        
    }
}
