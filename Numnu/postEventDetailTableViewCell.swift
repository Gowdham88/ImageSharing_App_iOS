//
//  postEventDetailTableViewCell.swift
//  Numnu
//
//  Created by CZ Ltd on 10/27/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import Nuke

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
    var getList = [String]()
    @IBOutlet var itemImageTap: ImageExtender!
    @IBOutlet var businessImageTap: ImageExtender!
    @IBOutlet var eventImageTap: ImageExtender!
    @IBOutlet weak var postusernametag: UILabel!
    @IBOutlet weak var mainDtContentview: UIView!
    @IBOutlet weak var postDtdishwidthConstaint: NSLayoutConstraint!
    @IBOutlet weak var DtplaceWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var DtdishRightLayoutConstraint: NSLayoutConstraint!
    
    var delegate : postEventDetailTableViewCellDelegate?
    
    @IBOutlet weak var eventTopHeight: NSLayoutConstraint!
    
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
    
    func setHeight(heightview : Float) {
        
        if heightview <= 568 {
            
            postDtdishwidthConstaint.constant   = 75
            DtplaceWidthConstraint.constant = 75
            
            
        } else if heightview <= 667 {
            
            postDtdishwidthConstaint.constant   = 99
            DtplaceWidthConstraint.constant = 99
            
        } else if heightview <= 736 {
            
            postDtdishwidthConstaint.constant   = 117
            DtplaceWidthConstraint.constant = 117
            
        } else if heightview <= 812 {
            
            postDtdishwidthConstaint.constant   = 99
            DtplaceWidthConstraint.constant = 99
            
        } else if heightview <= 1024 {
            
            postDtdishwidthConstaint.constant   = 274
            DtplaceWidthConstraint.constant = 274
            
        } else {
            
            postDtdishwidthConstaint.constant   = 387
            DtplaceWidthConstraint.constant = 387
            
        }
        
        if (postDtEventDishLabel.numberOfVisibleLines > 1) {
            
            eventTopHeight.constant = 52
            
        }
        
        if (postDtEventPlace.numberOfVisibleLines > 1) {
            
            eventTopHeight.constant = 52
            
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
                    postDtvUserTime.text =  dateString + "hrs"
                }
            }
            
            if let posttag = item.postcreator{
                if let postuser = posttag.name {
                    postDtUsernameLabel.text = postuser

                }
                if let postusername = posttag.username {
                    postDtUserplaceLabbel.text = "@\(postusername)"
                    
                }
                if let userimageList = posttag.userimages {
                    
                    if userimageList.count > 0 {
                        
                        let apiclient = ApiClient()
                        apiclient.getFireBaseImageUrl(imagepath: userimageList[userimageList.count-1].imageurl_str!, completion: { url in
                            
                            self.postDtUserImage.image = nil
                            Manager.shared.loadImage(with: URL(string : url)!, into: self.postDtUserImage)
                            
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
                        
                        self.postDtEventImage.image = nil
                        Manager.shared.loadImage(with: URL(string : url)!, into: self.postDtEventImage)
                        
                    })
                    
                }
                
            }
            
            if let rating = item.rating {
                if rating == 1 {
                    postDtLikeImage.image = UIImage(named:"rating1")

                }else if rating == 2 {
                    postDtLikeImage.image = UIImage(named:"rating2")
                }else if rating == 3 {
                    postDtLikeImage.image = UIImage(named:"rating3")

                }else{
                    
                }

            }
            
            if let event = item.event{
                if let eventname = event.name {
                    postDtEventName.text = eventname
                    
                }
            }
            
            if let business = item.business{
                if let businessname = business.businessname {
                    postDtEventDishLabel.text = businessname
                    
                }
            }
            
            if let taggeditem = item.taggedItemName{
               
                    postDtEventPlace.text = taggeditem
                
                
            }
            
            if let commentname = item.comment {
                postDtvCommentLabel.text = commentname
                
            }
            
        }
    }

}
