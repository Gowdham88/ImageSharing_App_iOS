//
//  feedTableViewCell.swift
//  Numnu
//
//  Created by Paramesh on 18/09/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

class feedTableViewCell: UITableViewCell {

    
    @IBOutlet var userpic : UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var location: UILabel!
    @IBOutlet var postedTime: UILabel!
    @IBOutlet var postDetail: UILabel!
    @IBOutlet var postImg: UIImageView!
    @IBOutlet var likeBtn: UIButton!
    @IBOutlet var commentBtn: UIButton!
    @IBOutlet var cottage: UIImageView!
    
    @IBOutlet var cloche: UIImageView!
    
    @IBOutlet var eventList: UILabel!
    
    @IBOutlet var cottageLbl: UILabel!
    @IBOutlet var clochelbl: UILabel!
    
    @IBOutlet var Usertags: UIButton!
    @IBOutlet weak var tagCounts: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
