//
//  BusinessTableViewCell.swift
//  Numnu
//
//  Created by CZ Ltd on 10/26/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import Nuke

class BusinessTableViewCell: UITableViewCell {
    
    @IBOutlet weak var businessDateLabel: UILabel!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessImageView: ImageExtender!
    @IBOutlet weak var businessTagCollectionView: UICollectionView!
    
    
    /*******************constaints************************/
    
   
    @IBOutlet weak var tagcollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var datacollectionheight: NSLayoutConstraint!
    @IBOutlet weak var tagTopConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        businessTagCollectionView.delegate   = dataSourceDelegate
        businessTagCollectionView.dataSource = dataSourceDelegate
        businessTagCollectionView.tag        = row
        businessTagCollectionView.reloadData()
        
    }
    
    var item : BussinessEventList! {
        didSet {
            
            if let name = item.businessname {
                
                businessNameLabel.text = name
            } else {
                
                tagTopConstraint.constant = 0
            }
            
            if let userimageList = item.imgList {
                
                if userimageList.count > 0 {
                    
                    let apiclient = ApiClient()
                    apiclient.getFireBaseImageUrl(imagepath: userimageList[userimageList.count-1].imageurl_str!, completion: { url in
                        
                        self.businessImageView.image = nil
                        Manager.shared.loadImage(with: URL(string : url)!, into: self.businessImageView)
                        
                    })
                    
                }
                
            }
            
            businessDateLabel.text = ""
            
//            guard let start_date =  item.createdat,let end_date =  item.createdat else {
//
//                return
//            }
//
//            let startdate = DateFormatterManager.sharedinstance.stringtoDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", date: start_date)
//            let enddate   = DateFormatterManager.sharedinstance.stringtoDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", date: end_date)
//
//            guard let start = DateFormatterManager.sharedinstance.datetoString(format: "MMM dd,h:mm a", date: startdate), let end = DateFormatterManager.sharedinstance.datetoString(format: "MMM dd,h:mm a", date: enddate) else {
//
//                return
//            }
//
//            businessDateLabel.text = "\(start) - \(end)"
            
        }
    }

}
