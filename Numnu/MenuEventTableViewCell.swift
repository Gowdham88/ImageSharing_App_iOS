//
//  MenuEventTableViewCell.swift
//  Numnu
//
//  Created by CZ Ltd on 10/25/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

class MenuEventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuImageview: ImageExtender!
    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var menuTagCollectionView: UICollectionView!
    @IBOutlet weak var menuDateLabel: UILabel!
    
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

}
