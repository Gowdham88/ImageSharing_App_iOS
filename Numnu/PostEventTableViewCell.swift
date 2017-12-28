//
//  PostEventTableViewCell.swift
//  Numnu
//
//  Created by CZ Ltd on 10/24/17.
//  Copyright © 2017 czsm. All rights reserved.
import UIKit
import Nuke

protocol PostEventTableViewCellDelegate {
    
    func bookmarkPost(tag : Int)
    
}




class PostEventTableViewCell: UITableViewCell {
 
    
    @IBOutlet weak var postUsernameLabel : UILabel!
    @IBOutlet weak var postUserImage    : ImageExtender!
    @IBOutlet weak var postUserplaceLabbel: UILabel!
    @IBOutlet weak var postUserTime: UILabel!
    @IBOutlet weak var postCommentLabel: UILabel!
    @IBOutlet weak var postEventImage: ImageExtender!
    @IBOutlet weak var postLikeImage: ImageExtender!
    @IBOutlet weak var postEventName: UILabel!
    @IBOutlet var postEventNameIcon: ImageExtender!
    @IBOutlet weak var postEventPlace: UILabel!
    @IBOutlet var postEventPlaceIcon: ImageExtender!
    @IBOutlet weak var postEventDishLabel: UILabel!
    @IBOutlet var postEventDishIcon: ImageExtender!
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
    
    var item : PostListDataItems! {
        didSet {
            if let startsat = item.createdat {
                if item.createdat != nil {
                    print("startat time:::",startsat)
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "en_US_POSIX")
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let date = formatter.date(from: startsat)
                    
                    print("date: \(String(describing: date))")
                    
                    formatter.dateFormat = "h "
                    let dateString = formatter.string(from: date!)
                    postUserTime.text =  dateString + "hrs"
                }
            }
            
            if let posttag = item.postcreator{
                if let postuser = posttag.name {
                    postUsernameLabel.text = postuser
                    
                }
                if let postusername = posttag.username {
                    postUserplaceLabbel.text = "@\(postusername)"
                    
                }
                if let userimageList = posttag.userimages {
                    
                    if userimageList.count > 0 {
                        
                        let apiclient = ApiClient()
                        apiclient.getFireBaseImageUrl(imagepath: userimageList[userimageList.count-1].imageurl_str!, completion: { url in
                            
                            self.postUserImage.image = nil
                            Manager.shared.loadImage(with: URL(string : url)!, into: self.postUserImage)
                            
                        })
                        
                    }
                    
                }
                
            }
            //            if let location = item.location{
            //                if let locationame = location.name_str {
            //                    postDtUserplaceLabbel.text = locationame
            //
            //                }
            //            }
            
            
            if let postimagelist = item.postimages {
                
                if postimagelist.count > 0 {
                    
                    let apiclient = ApiClient()
                    apiclient.getFireBaseImageUrl(imagepath: postimagelist[postimagelist.count-1].imageurl_str!, completion: { url in
                        
                        self.postEventImage.image = nil
                        Manager.shared.loadImage(with: URL(string : url)!, into: self.postEventImage)
                        
                    })
                    
                }
                
            }
            
            if let rating = item.rating {
                if rating == 1 {
                    postLikeImage.image = UIImage(named:"rating1")
                    
                }else if rating == 2 {
                    postLikeImage.image = UIImage(named:"rating2")
                }else if rating == 3 {
                    postLikeImage.image = UIImage(named:"rating3")
                    
                }else{
                    
                }
                
            }
            
            if let event = item.event{
                if let eventname = event.name {
                    postEventName.text = eventname
                    
                }
            }
            
            if let business = item.business{
                if let businessname = business.businessname {
                    postEventDishLabel.text = businessname
                    
                }
            }
            
            if let taggeditem = item.taggedItemName{
                
                postEventPlace.text = taggeditem
                
                
            }
            
            if let commentname = item.comment {
                postCommentLabel.text = commentname
                
            }
            
        }
    }
    
    @IBAction func ButtonBookmark(_ sender: UIButton) {
        
        delegate!.bookmarkPost(tag: sender.tag)
    }

}
