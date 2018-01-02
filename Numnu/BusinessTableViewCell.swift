//
//  BusinessTableViewCell.swift
//  Numnu
//
//  Created by CZ Ltd on 10/26/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

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

}
