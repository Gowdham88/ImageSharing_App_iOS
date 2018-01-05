//
//  MenuEventTableViewCell.swift
//  Numnu
//
//  Created by CZ Ltd on 10/25/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import Nuke

class MenuEventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuImageview: ImageExtender!
    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var menuTagCollectionView: UICollectionView!
    @IBOutlet weak var menuDateLabel: UILabel!
    
    /*******************constaints************************/
    
    @IBOutlet weak var tagcollectionTop: NSLayoutConstraint!
    @IBOutlet weak var tagcollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var datacollectionheight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        menuTagCollectionView.delegate   = dataSourceDelegate
        menuTagCollectionView.dataSource = dataSourceDelegate
        menuTagCollectionView.tag        = row
        menuTagCollectionView.reloadData()
        
    }
    
    var item : ItemList! {
        
        didSet {
            
            if let name = item.businessname {
                
                menuNameLabel.text =  name
                
            } else {
                
                tagcollectionTop.constant = 0
                
                
            }
            
            if let userimageList = item.itemImageList {
                
                if userimageList.count > 0 {
                    
                    let apiclient = ApiClient()
                    apiclient.getFireBaseImageUrl(imagepath: userimageList[userimageList.count-1].imageurl!, completion: { url in
                        
                        self.menuImageview.image = nil
                        Manager.shared.loadImage(with: URL(string : url)!, into: self.menuImageview)
                        
                    })
                    
                }
                
            }
            
            if item.tagList == nil {
                
                tagcollectionTop.constant = 0
                tagcollectionHeight.constant = 0
            }
            
            guard let start_date =  item.createdat,let end_date =  item.createdat else {
                
                return
            }
            
            let startdate = DateFormatterManager.sharedinstance.stringtoDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", date: start_date)
            let enddate   = DateFormatterManager.sharedinstance.stringtoDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", date: end_date)
            
            guard let start = DateFormatterManager.sharedinstance.datetoString(format: "MMM dd,h:mm a", date: startdate), let end = DateFormatterManager.sharedinstance.datetoString(format: "MMM dd,h:mm a", date: enddate) else {
                
                return
            }
            
            menuDateLabel.text = "\(start) - \(end)"
            
            
        }
        
        
    }

}
