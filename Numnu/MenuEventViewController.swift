//
//  MenuEventViewController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/26/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MenuEventViewController: UIViewController,IndicatorInfoProvider {
    
    var tagarray = ["Festival","Wine","Party","Rum","Barbaque","Pasta","Sandwich","Burger"]
    
    @IBOutlet weak var menuEventTableview: UITableView!
    @IBOutlet weak var menuCategoryTableview: UITableView!
    var showentity : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuEventTableview.delegate   = self
        menuEventTableview.dataSource = self
        
        menuCategoryTableview.delegate   = self
        menuCategoryTableview.dataSource = self
        
        menuCategoryTableview.isHidden = false
        menuEventTableview.isHidden    = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: Constants.EventTab2)
    }
   
}

extension MenuEventViewController : UITableViewDelegate,UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == menuEventTableview {
            
            return 6
            
        } else {
            
            return 8
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == menuEventTableview {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuEventCell", for: indexPath) as! MenuItemEventCell
            
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "menucategoryCell", for: indexPath) as! MenuCategoryItemCell
            
            cell.eventCategoryLabel.text = tagarray[indexPath.row]
            
            return cell
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.white
        openStoryBoard(name: Constants.EventDetail, id: Constants.MenuItemId)
        
        
//        if tableView == menuEventTableview {
//
//            menuEventTableview.isHidden    = true
//            menuCategoryTableview.isHidden = false
//            if showentity {
//
//
//
//            } else {
//
//                openStoryBoard(name: Constants.ItemDetail, id: Constants.ItemDetailId)
//
//            }
//
//
//        } else {
//
//            menuEventTableview.isHidden    = false
//            menuCategoryTableview.isHidden = true
//
//
//        }
        
    }
    
    func openStoryBoard (name : String,id : String) {
        
        let storyboard      = UIStoryboard(name: name, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: id)
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    
}

extension MenuEventViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tagarray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventMenuTagCell", for: indexPath) as! EventTagCollectionCell
        
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


