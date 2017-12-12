//
//  MenuCategoryItemCell.swift
//  Numnu
//
//  Created by CZ Ltd on 10/30/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

class MenuCategoryItemCell: UITableViewCell {
    
   @IBOutlet weak var eventCategoryLabel: UILabel!
   @IBOutlet weak var eventCategoryCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var item : EventItemtag! {
        
        didSet {
            
            eventCategoryLabel.text = item.tagtext ?? "Tag"
            eventCategoryCount.text = "\(item.itemcount ?? 0)"
            
        }
        
    }

}
