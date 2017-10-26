//
//  businessEventTableViewCell.swift
//  Numnu
//
//  Created by CZ Ltd on 10/26/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

class businessEventTableViewCell : UITableViewCell {

    @IBOutlet weak var eventBusImageView: ImageExtender!
    @IBOutlet weak var eventBusLabel: UILabel!
    @IBOutlet weak var eventBusCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        eventBusCollectionView.delegate   = dataSourceDelegate
        eventBusCollectionView.dataSource = dataSourceDelegate
        eventBusCollectionView.tag        = row
        eventBusCollectionView.reloadData()
        
    }

}
