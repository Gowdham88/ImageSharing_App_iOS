//
//  DefaultHomeControllerViewController.swift
//  Numnu
//
//  Created by CZ Ltd on 11/1/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class DefaultHomeController: UIViewController,IndicatorInfoProvider {

    @IBOutlet weak var eventDefaultTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventDefaultTableview.delegate   = self
        eventDefaultTableview.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: Constants.Tab1)
    }
    

}

extension DefaultHomeController : UITableViewDelegate,UITableViewDataSource,DefaultHomeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "defaultTableCell", for: indexPath) as! DefaultHomeTableViewCell
        
        cell.eventArrowButon.tag = indexPath.row
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        cell.selectionStyle = .none
        cell.delegate       = self
        return cell
    }
    
    func openEventList(index: Int) {
        
        openStoryBoard(name: Constants.Tab, id: Constants.Tabid1)
        
    }
    
}

extension DefaultHomeController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventcell1", for: indexPath) as! EventDefaulCollectionCell
        return cell
   
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    
        openStoryBoard(name: Constants.Event, id: Constants.EventStoryId)
        
    }
    
    
    
    func openStoryBoard(name: String,id : String) {
        
        let storyboard                  = UIStoryboard(name: name, bundle: nil)
        
        if id == Constants.Tabid1 {
            
            let eventVc        = storyboard.instantiateViewController(withIdentifier: id) as! EventTabController
            eventVc.showNavBar = true
            self.navigationController!.pushViewController(eventVc, animated: true)
            
        } else {
            
            let initialViewController       = storyboard.instantiateViewController(withIdentifier: id)
            self.navigationController!.pushViewController(initialViewController, animated: true)
            
        }
        
    }
    
    
    
}
