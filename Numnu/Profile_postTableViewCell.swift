//
//  Profile_postTableViewCell.swift
//  Numnu
//
//  Created by Gowdhaman on 06/11/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

protocol  Profile_postTableViewCellDelegate {
    
    func popup()
    
}

class Profile_postTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postUsernameLabel: UILabel!
    @IBOutlet weak var postUserImage: ImageExtender!
    @IBOutlet weak var postUserplaceLabbel: UILabel!
    @IBOutlet weak var postUserTime: UILabel!
    @IBOutlet weak var postCommentLabel: UILabel!
    @IBOutlet weak var postEventImage: ImageExtender!
    @IBOutlet weak var postLikeImage: ImageExtender!
    @IBOutlet weak var postEventName: UILabel!
    @IBOutlet weak var postEventPlace: UILabel!
    @IBOutlet weak var postEventDishLabel: UILabel!
    @IBOutlet weak var postEventBookMark: UIButton!
    
    @IBOutlet weak var maincontentView: UIView!
    @IBOutlet weak var dishwidthConstaint: NSLayoutConstraint!
    @IBOutlet weak var placeWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var dishRightLayoutConstraint: NSLayoutConstraint!
    
    var delegate : Profile_postTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func ButtonBookmark(_ sender: UIButton) {
        
        delegate?.popup()
    }
}
