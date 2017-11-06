//
//  postEventDetailTableViewCell.swift
//  Numnu
//
//  Created by CZ Ltd on 10/27/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

protocol postEventDetailTableViewCellDelegate {
    
    func bookmarkPost(tag : Int)
    
}

class postEventDetailTableViewCell : UITableViewCell {
    
    @IBOutlet weak var postDtUsernameLabel: UILabel!
    @IBOutlet weak var postDtUserImage: ImageExtender!
    @IBOutlet weak var postDtUserplaceLabbel: UILabel!
    @IBOutlet weak var postDtvUserTime: UILabel!
    @IBOutlet weak var postDtvCommentLabel: UILabel!
    @IBOutlet weak var postDtEventImage: ImageExtender!
    @IBOutlet weak var postDtLikeImage: ImageExtender!
    @IBOutlet weak var postDtEventName: UILabel!
    @IBOutlet weak var postDtEventPlace: UILabel!
    @IBOutlet weak var postDtEventDishLabel: UILabel!
    @IBOutlet weak var postDtEventBookMark: UIButton!
    
    @IBOutlet weak var mainDtContentview: UIView!
    @IBOutlet weak var postDtdishwidthConstaint: NSLayoutConstraint!
    @IBOutlet weak var DtplaceWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var DtdishRightLayoutConstraint: NSLayoutConstraint!
    
    var delegate : postEventDetailTableViewCellDelegate?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func ButtonBookmark(_ sender: UIButton) {
        
        delegate!.bookmarkPost(tag: sender.tag)
    }

}
