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
    
    /*********************Event*********************************/
    var itemTagList = [EventItemtag]()
    var tagModel  : EventItemTagModel?
    
    /*********************Business*********************************/
    var itemBusinessTagList = [BusinessItemtag]()
    var tagBusinessModel    : BusinessItemTagModel?
    
    var pageno  : Int = 1
    var limitno : Int = 25
    
    /********************variable which select which api ************************/
    
    var itemType : String = "default"
    
    var primayId : Int = 34
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuCategoryTableview.delegate   = self
        menuCategoryTableview.dataSource = self
        menuCategoryTableview.isHidden = false
        menuCategoryTableview.isScrollEnabled = false
        
        /********************Api client********************************/
        apiClient = ApiClient()
        
        /**********************For Business tab***********************************/
    
        if itemType == "Business" {
       
            getItemTagBusiness(pageno: pageno, limit: limitno)
            
        }
        
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        viewState = true
        itemTagList.removeAll()
        itemBusinessTagList.removeAll()
        pageno  = 1
        limitno = 25
        switch itemType {
            
        case "Event":
            
           getItemTag(pageno: pageno, limit: limitno)
            
        case "Business":
            
           getItemTagBusiness(pageno: pageno, limit: limitno)
            
        default:
            
           break
            
        }
        
        
        
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
        
        switch itemType {
            
        case "Event":
             return itemTagList.count
            
        case "Business":
            return itemBusinessTagList.count
            
        default:
            return 0
            
        }
        
       
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menucategoryCell", for: indexPath) as! MenuCategoryItemCell
        switch itemType {
            
        case "Event":
            
            cell.item = itemTagList[indexPath.row]
            
        case "Business":
            cell.itemBusiness = itemBusinessTagList[indexPath.row]
            
        default:
            
            return cell
            
        }
        
        return cell
      
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        switch itemType {
            
        case "Event":
            
            if indexPath.row == itemTagList.count - 1 && viewState {
                
                if let pageItem = tagModel {
                    
                    if itemTagList.count  < pageItem.totalRows ?? 0 {
                        pageno += 1
                        limitno = 25 * pageno
                        getItemTag(pageno: pageno, limit: limitno)
                    }
                    
                }
                
            }

            
        case "Business":
            if indexPath.row == itemBusinessTagList.count - 1 && viewState {
                
                if let pageItem = tagBusinessModel {
                    
                    if itemBusinessTagList.count  < pageItem.totalRows ?? 0 {
                        pageno += 1
                        limitno = 25 * pageno
                        getItemTagBusiness(pageno: pageno, limit: limitno)
                    }
                    
                }
                
            }

            
        default:
            break
        }
        
    }
}

extension MenuEventViewController   {
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch itemType {
            
        case "Event":
            
            openStoryBoard(name: Constants.EventDetail, id: Constants.MenuItemId,heading: itemTagList[indexPath.row].tagtext ?? "Title", primid: 34,tagid: itemTagList[indexPath.row].tagid ?? 0,type: "Event")
            
        case "Business":
            openStoryBoard(name: Constants.EventDetail, id: Constants.MenuItemId,heading: itemBusinessTagList[indexPath.row].tagtext ?? "Title", primid: 51,tagid: itemBusinessTagList[indexPath.row].tagid ?? 0,type: "Business")
            
        default:
     
            break
            
        }
        
        
    }
    
    func openStoryBoard (name : String,id : String,heading : String,primid : Int,tagid : Int,type : String) {
        
        let storyboard      = UIStoryboard(name: name, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: id) as! MenuItemViewController
        vc.heading          = heading
        vc.primaryid        = primid
        vc.tag_id           = tagid
        vc.itemType         = type
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
        
        HUD.show(.labeledProgress(title: "Loading", subtitle: ""))
        
        apiClient.getFireBaseToken(completion: { token in
            
            let header : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
            let param  : String  = "page=\(pageno)&limit\(limit)"
            
            self.apiClient.getItemTagEvent(id: self.primayId, page: param, headers: header, completion: { status,taglist in
                
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
    
    func getItemTagBusiness(pageno:Int,limit:Int) {
        
        HUD.show(.labeledProgress(title: "Loading", subtitle: ""))
        
        apiClient.getFireBaseToken(completion: { token in
            
            let header : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
            let param  : String  = "page=\(pageno)&limit\(limit)"
            
            self.apiClient.getItemTagBusiness(id: self.primayId, page: param, headers: header, completion: { status,taglist in
                
                if status == "success" {
                    
                    if let item = taglist {
                        
                        self.tagBusinessModel = item
                        
                        if let list = item.tagItemList {
                            
                            self.itemBusinessTagList += list
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


