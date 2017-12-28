//
//  EventTableViewCell.swift
//  Numnu
//
//  Created by CZ Ltd on 10/11/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import Nuke

class EventTableViewCell : UITableViewCell {
    
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventImageView: ImageExtender!
    @IBOutlet weak var eventTagCollectionView: UICollectionView!
  
    @IBOutlet weak var dateTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tagTopConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        eventTagCollectionView.delegate   = dataSourceDelegate
        eventTagCollectionView.dataSource = dataSourceDelegate
        eventTagCollectionView.tag        = row
        eventTagCollectionView.reloadData()
        
    }
    
    var item : EventTypeListItem! {
        didSet {
            if let eventname = item.name {
                eventNameLabel.text = eventname

            }
            
            
            if item.taglist == nil {
                dateTopConstraint.constant = 5
            } else {
                
                dateTopConstraint.constant = 32
            }
            
            
            if let userimageList = item.imgList {
                
                if userimageList.count > 0 {
                    
                    let apiclient = ApiClient()
                    apiclient.getFireBaseImageUrl(imagepath: userimageList[userimageList.count-1].imageurl_str!, completion: { url in
                        
                        self.eventImageView.image = nil
                        Manager.shared.loadImage(with: URL(string : url)!, into: self.eventImageView)
                        
                    })
                    
                }
                
            }
            
            guard let start_date =  item.startsat,let end_date =  item.endsat else {
                
                return
            }
            
            let startdate = DateFormatterManager.sharedinstance.stringtoDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", date: start_date)
            let enddate   = DateFormatterManager.sharedinstance.stringtoDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", date: end_date)
            
            guard let start = DateFormatterManager.sharedinstance.datetoString(format: "MMM dd,h:mm a", date: startdate), let end = DateFormatterManager.sharedinstance.datetoString(format: "MMM dd,h:mm a", date: enddate) else {
                
                return
            }
            
            eventDateLabel.text = "\(start) - \(end)"
            
        }
    }

 

}
