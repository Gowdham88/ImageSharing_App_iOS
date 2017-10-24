//
//  PostEventTableViewCell.swift
//  Numnu
//
//  Created by CZ Ltd on 10/24/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

class PostEventTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var postEventTagCollectionview: UICollectionView!
    @IBOutlet weak var postEventImage: ImageExtender!
    @IBOutlet weak var postEventLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        postEventTagCollectionview.delegate   = dataSourceDelegate
        postEventTagCollectionview.dataSource = dataSourceDelegate
        postEventTagCollectionview.tag        = row
        postEventTagCollectionview.reloadData()
        
    }

}
