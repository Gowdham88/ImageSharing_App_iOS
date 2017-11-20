//
//  EventTableViewCell.swift
//  Numnu
//
//  Created by CZ Ltd on 10/11/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

class EventTableViewCell : UITableViewCell {
    
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventImageView: ImageExtender!
    @IBOutlet weak var eventTagCollectionView: UICollectionView!
  
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
 

}
