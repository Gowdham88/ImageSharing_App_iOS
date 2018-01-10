//
//  MenuItemEventCell.swift
//  Numnu
//
//  Created by CZ Ltd on 10/30/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import Nuke

class MenuItemEventCell: UITableViewCell {
    
    @IBOutlet weak var eventMenImageView: ImageExtender!
    @IBOutlet weak var eventMenLabel: UILabel!
    @IBOutlet weak var eventMenCollectionView: UICollectionView!
    @IBOutlet weak var priceLabel: UILabel!

    @IBOutlet weak var priceConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var tagConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var tagConstarintTop: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if eventMenLabel.numberOfVisibleLines > 1 {
            tagConstarintTop.constant = 30
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        eventMenCollectionView.delegate   = dataSourceDelegate
        eventMenCollectionView.dataSource = dataSourceDelegate
        eventMenCollectionView.tag        = row
        eventMenCollectionView.reloadData()
        
    }
    
    var item : ItemList! {
        
        didSet {
            
            if let name = item.businessname {
                
                eventMenLabel.text =  name
                
            } else {
                
                tagConstarintTop.constant = 0
                
                
            }
            
            if let userimageList = item.itemImageList {
                
                if userimageList.count > 0 {
                    
                    let apiclient = ApiClient()
                    apiclient.getFireBaseImageUrl(imagepath: userimageList[userimageList.count-1].imageurl!, completion: { url in
                        
                        self.eventMenImageView.image = nil
                        Manager.shared.loadImage(with: URL(string : url)!, into: self.eventMenImageView)
                        
                    })
                    
                }
                
            }
            
            if item.tagList == nil {
                
                tagConstarintTop.constant = 0
                tagConstraintHeight.constant = 0
            }
            
            
        }
        
        
    }

}
