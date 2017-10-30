//
//  BusinessEventViewController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/26/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class BusinessEventViewController: UIViewController,IndicatorInfoProvider {
    
    var tagarray = ["Festival","Wine","Party","Rum","Barbaque","Pasta","Sandwich","Burger"]

    @IBOutlet weak var businessEventTableView: UITableView!
    @IBOutlet weak var businessCategoryTableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        businessEventTableView.delegate   = self
        businessEventTableView.dataSource = self
        
        businessCategoryTableView.delegate   = self
        businessCategoryTableView.dataSource = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: Constants.EventTab1)
    }
    
    func openStoryBoard () {
        
        let storyboard      = UIStoryboard(name: Constants.BusinessDetail, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: Constants.BusinessDetailId) 
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    

}

extension BusinessEventViewController : UITableViewDelegate,UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == businessEventTableView {
            
            return 6
            
        } else {
            
             return 8
            
        }
   
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == businessEventTableView {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessEventCell", for: indexPath) as! businessEventTableViewCell
        
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            
        return cell
            
        } else {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryEventCell", for: indexPath) as! BusinessCategoryEventViewCellTableViewCell
            
        cell.eventCategoryLabel.text = tagarray[indexPath.row]
            
        return cell
            
        }
    
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         if tableView == businessEventTableView {
            
            openStoryBoard()
            
         } else {
            
            businessEventTableView.isHidden    = false
            businessCategoryTableView.isHidden = true
            
        }
        
    }
    
    
}

extension BusinessEventViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tagarray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventBusTagCell", for: indexPath) as! EventTagCollectionCell
        
        let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: tagarray[indexPath.row], fontname: "AvenirNext-Regular", size: 15)
        
        cell.tagnamelabel.text = tagarray[indexPath.row]
        
        cell.setLabelSize(size: textSize)
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: tagarray[indexPath.row], fontname: "AvenirNext-Regular", size: 15)
        
        return CGSize(width: textSize.width+20, height: 30)
    }
    
    
    
}
