//
//  MenuItemEventCell.swift
//  Numnu
//
//  Created by CZ Ltd on 10/30/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

class MenuItemEventCell: UITableViewCell {
    
    @IBOutlet weak var eventMenImageView: ImageExtender!
    @IBOutlet weak var eventMenLabel: UILabel!
    @IBOutlet weak var eventMenCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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

}
