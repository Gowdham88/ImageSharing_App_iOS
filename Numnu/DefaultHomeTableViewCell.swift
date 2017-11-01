//
//  DefaultHomeTableViewCell.swift
//  Numnu
//
//  Created by CZ Ltd on 11/1/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

protocol  DefaultHomeTableViewCellDelegate {
    
    func openEventList(index : Int)
}

class DefaultHomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventCollectionView: UICollectionView!
    @IBOutlet weak var eventArrowButon: UIButton!
    @IBOutlet weak var eventTypeLabel: UILabel!
    
    var delegate : DefaultHomeTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        eventCollectionView.delegate   = dataSourceDelegate
        eventCollectionView.dataSource = dataSourceDelegate
        eventCollectionView.tag        = row
        eventCollectionView.reloadData()
        
    }
    
    @IBAction func ButtonEventArrow(_ sender: UIButton) {
        
        delegate!.openEventList(index: sender.tag)
        
    }

}
