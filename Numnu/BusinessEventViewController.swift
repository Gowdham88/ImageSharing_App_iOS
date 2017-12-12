//
//  BusinessEventViewController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/26/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import PKHUD

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
    
    /************************Api***************************/
    
    var apiClient : ApiClient!
    var bussinessList = [BussinessEventList]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        businessEventTableView.delegate   = self
        businessEventTableView.dataSource = self
        
        businessCategoryTableView.delegate   = self
        businessCategoryTableView.dataSource = self
        
        
        apiClient = ApiClient()
        getBussinessevent()
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        reloadTable()
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        viewState = true
       
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
            
            return bussinessList.count
            
        } else {
            
             return 8
            
        }
   
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == businessEventTableView {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessEventCell", for: indexPath) as! businessEventTableViewCell
        
        cell.item = bussinessList[indexPath.row]
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
        
        if let tagItem = bussinessList[collectionView.tag].tagList {
            
            return tagItem.count
       
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventBusTagCell", for: indexPath) as! EventTagCollectionCell
        
        if let tagItem = bussinessList[collectionView.tag].tagList {
            
            let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: tagItem[indexPath.row].text_str ?? "", fontname: "Avenir-Medium", size: 12)
            
            cell.tagnamelabel.text = tagItem[indexPath.row].text_str ?? ""
            
            cell.setLabelSize(size: textSize)
            
        }
     
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let tagItem = bussinessList[collectionView.tag].tagList {
           
            let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: tagItem[indexPath.row].text_str ?? "", fontname: "Avenir-Medium", size: 12)
            
            return CGSize(width: textSize.width+20, height: 22)
            
        }
       
        return CGSize(width:0, height: 0)
    }
    
    
    
}

extension BusinessEventViewController {
    
    func getBussinessevent() {
        
        HUD.show(.progress)
        
        apiClient.getFireBaseToken(completion: { token in
            
            let header : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
            
            self.apiClient.getBussinessEvent(id: 34, headers: header, completion: { status,bussinesslist in
                
                if status == "success" {
                    
                    if let itemlist = bussinesslist {
                        
                        self.bussinessList = itemlist
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.businessEventTableView.reloadData()
                        
                    }
                  
                    self.reloadTable()
                    
                } else {
                    
                    HUD.hide()
                    self.reloadTable()
                    
                }
                
                
            })
            
            
        })
  
        
    }
    
    
    func reloadTable() {
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            self.businesdelegate?.BusinessTableHeight(height: self.businessEventTableView.contentSize.height)
            HUD.hide()
        }
     
    }
    
    
}
