//
//  Locationtableviewcell.swift
//  Numnu
//
//  Created by CZ Ltd on 11/1/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import Nuke

class Locationtableviewcell: UITableViewCell {
    
    
    @IBOutlet weak var locationPlace: UILabel!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locationImage: ImageExtender!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    var itemm : LocList!{
        didSet{
            if let locname = itemm.name_str {
                if itemm.name_str != nil {
                    locationName.text = locname

                }
            }
            
            if let locplace = itemm.address_str {
                if itemm.address_str != nil {
                    locationPlace.text = locplace
                }
            }
            
            if let imagelist = itemm.imageurl {
                
                if imagelist.count > 0 {
                    
                    let apiclient = ApiClient()
                    apiclient.getFireBaseImageUrl(imagepath: imagelist[imagelist.count-1], completion: { url in
                        
                        self.locationImage.image = nil
                        Manager.shared.loadImage(with: URL(string : url)!, into: self.locationImage)
                        
                    })
                    
                }
                
            }
            
            

            
        }
    }
}
