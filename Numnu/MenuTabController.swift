//
//  MenuTabController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/9/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire

class MenuTabController: UIViewController,IndicatorInfoProvider {
    
    @IBOutlet weak var menuTableView: UITableView!
    
    var tagarray = [String]()
    
    var locationDictonary : [String : Any]?
    var searchText        : String?
    
    var apiClient : ApiClient!
    var homeItem  : HomeSearchModel?
    var itemList = [ItemList]()
    
    var pageno  : Int = 1
    var limitno : Int = 25

    override func viewDidLoad() {
        super.viewDidLoad()

        menuTableView.delegate   = self
        menuTableView.dataSource = self
        
        apiClient = ApiClient()
        getHomeSearchApi(pageno: pageno)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Tab intiallizers.
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: Constants.Tab3)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MenuTabController : UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menueventcell", for: indexPath) as! MenuEventTableViewCell
        guard itemList.count > 0 else {
            
            return cell
        }
        
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        cell.item = itemList[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == itemList.count - 1  {
            
            if let pageItem = homeItem {
                
                if itemList.count  < pageItem.totalRows ?? 0 {
                    pageno += 1
                    limitno = 25 * pageno
                    getHomeSearchApi(pageno: pageno)
                }
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        openStoryBoard()
        
    }
    
    func  openStoryBoard() {
        
        let storyboard = UIStoryboard(name: Constants.ItemDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.ItemDetailId) as! ItemDetailController
        vc.itemprimaryid = 39
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    
}

extension MenuTabController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       return itemList[collectionView.tag].tagList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menutagcell", for: indexPath) as! EventTagCollectionCell
        
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

extension MenuTabController {
    
    /****************************************complete signup******************************************************/
    
    func getHomeSearchApi(pageno:Int) {
        
        let clientIp = ValidationHelper.Instance.getIPAddress() ?? "1.0.1"
        if locationDictonary == nil {
            
            if let lat = PrefsManager.sharedinstance.lastlocationlat,let long = PrefsManager.sharedinstance.lastlocationlat {
                
                locationDictonary = ["lattitude":lat,"longitude":long,"nearMeRadiusInMiles": 15000]
                
            }
            
        }
        
        if searchText == nil {
            
            searchText = ""
        }
        
        print(locationDictonary ?? [])
        print(searchText ?? "xoxo")
        
        apiClient.getFireBaseToken(completion: { token in
            
            LoadingHepler.instance.show()
            
            let header     : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
            let parameters: Parameters = ["locationObject" : self.locationDictonary!,"searchText" : self.searchText!,"clientip": clientIp, "clientapp": Constants.clientApp]
            self.apiClient.homeSearchApi(parameters: parameters, type: "items",pageno: pageno, headers: header, completion: { status,homemodel in
                
                if status == "success" {
                    
                    if let item = homemodel {
                        
                        self.homeItem = item
                        
                        if let itemlist = item.itemList {
                            
                            self.itemList += itemlist
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.menuTableView.reloadData()
                         LoadingHepler.instance.hide()
                    }
                    
                    
                    
                } else {
                    
                    LoadingHepler.instance.hide()
                    
                    
                }
                
                
            })
            
            
        })
        
        
    }
}
