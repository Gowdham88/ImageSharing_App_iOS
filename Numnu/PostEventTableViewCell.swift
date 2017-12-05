//
//  PostEventTableViewCell.swift
//  Numnu
//
//  Created by CZ Ltd on 10/24/17.
//  Copyright © 2017 czsm. All rights reserved.
import UIKit

protocol PostEventTableViewCellDelegate {
    
    func bookmarkPost(tag : Int)
    
}




class PostEventTableViewCell: UITableViewCell {
 
    
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
    
    @IBOutlet weak var postusernametag: UILabel!
    @IBOutlet weak var maincontentView: UIView!
    @IBOutlet weak var dishwidthConstaint: NSLayoutConstraint!
    @IBOutlet weak var placeWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var dishRightLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var eventTopConstraint: NSLayoutConstraint!
    var delegate : PostEventTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setHeight(heightview : Float){
        
        if heightview <= 568 {
            
            dishwidthConstaint.constant   = 75
            placeWidthConstraint.constant = 75
            
            
        } else if heightview <= 667 {
            
            dishwidthConstaint.constant   = 99
            placeWidthConstraint.constant = 99
            
        } else if heightview <= 736 {
            
            dishwidthConstaint.constant   = 117
            placeWidthConstraint.constant = 117
            
        } else if heightview <= 812 {
            
            dishwidthConstaint.constant   = 99
            placeWidthConstraint.constant = 99
            
        } else if heightview <= 1024 {
            
            dishwidthConstaint.constant   = 274
            placeWidthConstraint.constant = 274
            
        } else {
            
            dishwidthConstaint.constant   = 387
            placeWidthConstraint.constant = 387
            
        }
        
        if (postEventDishLabel.numberOfVisibleLines > 1) {
            
            eventTopConstraint.constant = 52
            
        }
        
        if (postEventPlace.numberOfVisibleLines > 1) {
            
            eventTopConstraint.constant = 52
            
        }
        
        
        
    }
    
    
    @IBAction func ButtonBookmark(_ sender: UIButton) {
        
        delegate!.bookmarkPost(tag: sender.tag)
    }

}
