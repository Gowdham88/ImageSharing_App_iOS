//
//  MenuEventViewController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/26/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import PKHUD

protocol MenuEventViewControllerDelegate {
   
    func menuTableHeight(height : CGFloat)
}

class MenuEventViewController: UIViewController,IndicatorInfoProvider,UITableViewDelegate,UITableViewDataSource {
    
    var tagarray = ["Festival","Wine","Party","Rum","Barbaque","Pasta","Sandwich","Burger"]
    
    
    @IBOutlet weak var menuCategoryTableview: UITableView!
    var showentity : Bool = false
    var menuDelegate : MenuEventViewControllerDelegate?
    var viewState    : Bool = false
    
    /********************Api client********************************/
    var apiClient : ApiClient!
    var itemTagList = [EventItemtag]()
    var tagModel  : EventItemTagModel?
    var pageno  : Int = 1
    var limitno : Int = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuCategoryTableview.delegate   = self
        menuCategoryTableview.dataSource = self
        menuCategoryTableview.isHidden = false
        menuCategoryTableview.isScrollEnabled = false
        
        /********************Api client********************************/
        apiClient = ApiClient()
        
        
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        viewState = true
        itemTagList.removeAll()
        pageno  = 1
        limitno = 25
        getItemTag(pageno: pageno, limit: limitno)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title: Constants.EventTab2)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemTagList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menucategoryCell", for: indexPath) as! MenuCategoryItemCell
        cell.item = itemTagList[indexPath.row]
        return cell
      
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == itemTagList.count - 1 && viewState {
            
            if let pageItem = tagModel {
                
                if itemTagList.count  < pageItem.totalRows ?? 0 {
                    pageno += 1
                    limitno = 25 * pageno
                    getItemTag(pageno: pageno, limit: limitno)
                }
                
            }
            
        }
    }
}

extension MenuEventViewController   {
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        openStoryBoard(name: Constants.EventDetail, id: Constants.MenuItemId,heading: itemTagList[indexPath.row].tagtext ?? "Title")
        
    }
    
    func openStoryBoard (name : String,id : String,heading : String) {
        
        let storyboard      = UIStoryboard(name: name, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: id) as! MenuItemViewController
        vc.heading          = heading
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    
}

extension MenuEventViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tagarray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventMenuTagCell", for: indexPath) as! EventTagCollectionCell
        
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

extension MenuEventViewController {
    
    func getItemTag(pageno:Int,limit:Int) {
        
        HUD.show(.progress)
        
        apiClient.getFireBaseToken(completion: { token in
            
            let header : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
            let param  : String  = "page=\(pageno)&limit\(limit)"
            
            self.apiClient.getItemTagEvent(id: 34, page: param, headers: header, completion: { status,taglist in
                
                if status == "success" {
                    
                    if let item = taglist {
                        
                        self.tagModel = item
                        
                        if let list = item.tagItemList {
                            
                            self.itemTagList += list
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.menuCategoryTableview.reloadData()
                        
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
            
            self.menuDelegate?.menuTableHeight(height: self.menuCategoryTableview.contentSize.height)
            HUD.hide()
        }
        
    }
    
    
}


