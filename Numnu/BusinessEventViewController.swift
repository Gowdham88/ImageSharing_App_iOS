//
//  BusinessEventViewController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/26/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip

protocol  BusinessEventViewControllerDelegate {
    
    func BusinessTableHeight(height : CGFloat)
    
}

class BusinessEventViewController: UIViewController,IndicatorInfoProvider {
    
    var tagarray = ["Festival","Wine","Party","Rum","Barbaque","Pasta","Sandwich","Burger"]

    @IBOutlet weak var businessEventTableView: UITableView!
    @IBOutlet weak var businessCategoryTableView : UITableView!
    
    var showentity : Bool = false
    var businesdelegate : BusinessEventViewControllerDelegate?
    var viewState       : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        businessEventTableView.delegate   = self
        businessEventTableView.dataSource = self
        
        businessCategoryTableView.delegate   = self
        businessCategoryTableView.dataSource = self
       
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        viewState = true
        businessCategoryTableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    
        
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: Constants.EventTab1)
    }
    
    func openStoryBoard (name : String,id : String) {
        
        let storyboard      = UIStoryboard(name: name, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: id)
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
            
            if showentity {
                
                openStoryBoard(name: Constants.BusinessDetail, id: Constants.BusinessDetailId)
                
            } else {
                
                openStoryBoard(name: Constants.BusinessDetailTab, id: Constants.BusinessCompleteId)
                
            }
            
            
            
         } else {
            
            businessEventTableView.isHidden    = false
            businessCategoryTableView.isHidden = true
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        if indexPath.row == lastRowIndex - 1 && viewState {
           businesdelegate?.BusinessTableHeight(height: businessEventTableView.contentSize.height)
           viewState = false
        }
    }
    
}

extension BusinessEventViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tagarray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventBusTagCell", for: indexPath) as! EventTagCollectionCell
        
        let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: tagarray[indexPath.row], fontname: "Avenir-Medium", size: 12)
        
        cell.tagnamelabel.text = tagarray[indexPath.row]
        
        cell.setLabelSize(size: textSize)
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: tagarray[indexPath.row], fontname: "Avenir-Medium", size: 12)
        
        return CGSize(width: textSize.width+20, height: 22)
    }
    
    
    
}
