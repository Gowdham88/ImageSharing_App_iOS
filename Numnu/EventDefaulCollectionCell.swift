//
//  EventDefaulCollectionCell.swift
//  Numnu
//
//  Created by CZ Ltd on 10/24/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import Nuke

class EventDefaulCollectionCell : UICollectionViewCell {
    
    
    @IBOutlet weak var eventLocationname: UILabel!
    @IBOutlet weak var eventLabelname: UILabel!
    @IBOutlet weak var eventImage: ImageExtender!
    @IBOutlet weak var eventdate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.eventImage.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.eventImage.layer.shadowOpacity = 0.75
        self.eventImage.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        self.eventImage.layer.shadowRadius = 7.0
        self.eventImage.layer.cornerRadius = 5.0
        self.eventImage.layer.masksToBounds = false
        self.eventImage.clipsToBounds = true
//        self.eventImage.clipsToBounds = true
    }

    var item : HomeSearchItem! {
        didSet {
            if let eventname = item.name {
                eventLabelname.text = eventname
                
            }
           
            if let userimageList = item.imgList {
                
                if userimageList.count > 0 {
                    
                    let apiclient = ApiClient()
                    apiclient.getFireBaseImageUrl(imagepath: userimageList[userimageList.count-1].imageurl_str!, completion: { url in
                        
                        self.eventImage.image = nil
                        Manager.shared.loadImage(with: URL(string : url)!, into: self.eventImage)
                        
                    })
                    
                }
                
            }
            
            guard let start_date =  item.startsat,let end_date =  item.endsat else {
                
                return
            }
            
            let startdate = DateFormatterManager.sharedinstance.stringtoDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", date: start_date)
            let enddate   = DateFormatterManager.sharedinstance.stringtoDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", date: end_date)
            
            guard let start = DateFormatterManager.sharedinstance.datetoString(format: "MMM dd", date: startdate), let end = DateFormatterManager.sharedinstance.datetoString(format: "MMM dd", date: enddate) else {
                
                return
            }
            
            eventdate.text = "\(start) - \(end)"
            
        }
    }
    
}
