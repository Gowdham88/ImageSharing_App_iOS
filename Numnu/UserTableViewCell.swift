//
//  UserTableViewCell.swift
//  Numnu
//
//  Created by Siva_iOS on 27/11/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import Nuke

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userSublabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var item : UserHomeList! {
        didSet {
            
            if let name = item.username {
                
                userLabel.text = name
                userSublabel.text = "@\(name)"
            } else {
                
//                tagTopConstraint.constant = 0
            }
            
            if let userimageList = item.userImageList {
                
                if userimageList.count > 0 {
                    
                    let apiclient = ApiClient()
                    apiclient.getFireBaseImageUrl(imagepath: userimageList[userimageList.count-1].imageurl!, completion: { url in
                        
                        self.userImage.image = nil
                        Manager.shared.loadImage(with: URL(string : url)!, into: self.userImage)
                        
                    })
                    
                }
                
            }
        }
    }
    
    

}
