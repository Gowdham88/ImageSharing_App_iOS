//
//  MenuItemViewController.swift
//  Numnu
//
//  Created by CZ Ltd on 11/13/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import Alamofire

class MenuItemViewController: UIViewController {

    @IBOutlet weak var menuItemTableview: UITableView!
    var tagarray = ["Festival","Wine","Party","Rum","Barbaque","Pasta","Sandwich","Burger"]
    var heading : String = ""
    
    /********************Api client********************************/
    var apiClient : ApiClient!
    var itemList = [ItemList]()
    var itemModel  : ItemListModel?
    var pageno  : Int = 1
    var limitno : Int = 25
    var primaryid : Int = 0
    var tag_id   : Int = 0
    /********************variable which select which api ************************/
    var itemType : String = "Event"
    
    @IBOutlet weak var navigationItemList: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuItemTableview.delegate   = self
        menuItemTableview.dataSource = self
       // Do any additional setup after loading the view.
      
        setNavBar()
        
        apiClient = ApiClient()
        itemList.removeAll()
        pageno  = 1
        limitno = 25
        getItemList(pageno: pageno, limit: limitno)
    }
    func navigationTap(){
        let offset = CGPoint(x: 0,y :0)
        self.menuItemTableview.setContentOffset(offset, animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let navigationOnTap = UITapGestureRecognizer(target: self, action: #selector(MenuItemViewController.navigationTap))
        self.navigationController?.navigationBar.addGestureRecognizer(navigationOnTap)
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /******************Set navigation bar**************************/
    
    func setNavBar() {
        
        navigationItemList.title = heading
        
        let button: UIButton = UIButton(type: UIButtonType.custom)
        //set image for button
        button.setImage(UIImage(named: "ic_arrow_back"), for: UIControlState.normal)
        //add function for button
        button.addTarget(self, action: #selector(EventViewController.backButtonClicked), for: UIControlEvents.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(customView: button)
        
        let rightButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        // Create two buttons for the navigation item
        navigationItemList.leftBarButtonItem  = leftButton
        navigationItemList.rightBarButtonItem = rightButton
        
        
    }
    
    func backButtonClicked() {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
   
    
}

extension MenuItemViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return itemList.count
   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuEventCell", for: indexPath) as! MenuItemEventCell
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        cell.item = itemList[indexPath.row]
        return cell
    
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == itemList.count - 1  {
            
            if let pageItem = itemModel {
                
                if itemList.count  < pageItem.totalRows ?? 0 {
                    pageno += 1
                    limitno = 25 * pageno
                    getItemList(pageno: pageno, limit: limitno)
                }
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        openStoryBoard(name: Constants.ItemDetail, id: Constants.ItemCompleteId)
     
        
    }
    
    func openStoryBoard (name : String,id : String) {
        
        let storyboard      = UIStoryboard(name: name, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: id) as! ItemCompleteviewcontroller
        vc.itemprimaryid    = 39
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    
}

extension MenuItemViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return itemList[collectionView.tag].tagList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventMenuTagCell", for: indexPath) as! EventTagCollectionCell
        
        if let tagItem = itemList[collectionView.tag].tagList {
            
            let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: tagItem[indexPath.row].text_str ?? "", fontname: "Avenir-Medium", size: 12)
            
            cell.tagnamelabel.text = tagItem[indexPath.row].text_str ?? ""
            
            cell.setLabelSize(size: textSize)
            
        }
       
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let tagItem = itemList[collectionView.tag].tagList {
            
            let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: tagItem[indexPath.row].text_str ?? "", fontname: "Avenir-Medium", size: 12)
            
            return CGSize(width: textSize.width+20, height: 22)
            
        }
        
        return CGSize(width:0, height: 0)
    }
    
    
    
}

extension MenuItemViewController {
    
    func getItemList(pageno:Int,limit:Int) {
        
        LoadingHepler.instance.show()
        
        apiClient.getFireBaseToken(completion: { token in
            
            let header : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
            let param  : String  = "page=\(pageno)&limit\(limit)"
            
            self.apiClient.getItemListByTagId(primaryid: self.primaryid, tagid: self.tag_id,type: self.itemType,page: param, headers: header, completion: { status,itemlists in
                
                if status == "success" {
                    
                    if let itemlist = itemlists {
                        
                        self.itemModel = itemlist
                        
                        if let list = itemlist.itemList {
                            
                            self.itemList += list
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        LoadingHepler.instance.hide()
                        self.menuItemTableview.reloadData()
                        
                    }
                    
                    
                    
                } else {
                    
                    LoadingHepler.instance.hide()
                    DispatchQueue.main.async {
                        
                        self.menuItemTableview.reloadData()
                        
                    }
                    
                }
                
                
            })
            
            
        })
        
        
    }
    
    
   
    
    
}
