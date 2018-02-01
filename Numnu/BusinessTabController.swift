//
//  BusinessTabController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/25/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire

class BusinessTabController: UIViewController,IndicatorInfoProvider {
    
    @IBOutlet weak var businessTableView: UITableView!
    
    var locationDictonary : [String : Any]?
    var searchText        : String?
    
    var apiClient : ApiClient!
    var homeItem  : HomeSearchModel?
    var bussinessList = [BussinessEventList]()
    
    
    var pageno  : Int = 1
    var limitno : Int = 25
    
    var tagarray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        businessTableView.delegate   = self
        businessTableView.dataSource = self

        apiClient = ApiClient()
        // Do any additional setup after loading the view.
        getHomeSearchApi(pageno: pageno)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: Constants.Tab2)
    }

   
    

}

extension BusinessTabController : UITableViewDelegate,UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         return bussinessList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "businesseventcell", for: indexPath) as! BusinessTableViewCell
        
        guard bussinessList.count > 0 else {
            
            return cell
            
        }
        
        cell.item = bussinessList[indexPath.row]
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
        openStoryBoard()
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == bussinessList.count - 1  {
            
            if let pageItem = homeItem {
                
                if bussinessList.count  < pageItem.totalRows ?? 0 {
                    pageno += 1
                    limitno = 25 * pageno
                    getHomeSearchApi(pageno: pageno)
                }
                
            }
            
        }
    }
    
    func  openStoryBoard() {
        
        let storyboard       = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
        let vc               = storyboard.instantiateViewController(withIdentifier: Constants.BusinessCompleteId) as! BusinessCompleteViewController
        vc.businessprimaryid = 50
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    
}

extension BusinessTabController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let tagItem = bussinessList[collectionView.tag].tagList {
            
            return tagItem.count
            
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "businesstagcell", for: indexPath) as! EventTagCollectionCell
        
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

extension BusinessTabController {
    
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
            self.apiClient.homeSearchApi(parameters: parameters, type: "businesses",pageno: pageno, headers: header, completion: { status,homemodel in
                
                if status == "success" {
                    
                    if let item = homemodel {
                        
                        self.homeItem = item
                        
                        if let itemlist = item.businessList {
                            
                            self.bussinessList += itemlist
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.businessTableView.reloadData()
                        LoadingHepler.instance.hide()
                    }
                    
                    
                    
                } else {
                    
                    LoadingHepler.instance.hide()
                   
                }
                
            })
            
            
        })
        
        
    }
}

