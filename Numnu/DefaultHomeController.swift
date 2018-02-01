//
//  DefaultHomeControllerViewController.swift
//  Numnu
//
//  Created by CZ Ltd on 11/1/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire



class DefaultHomeController: UIViewController,IndicatorInfoProvider {

    @IBOutlet weak var eventDefaultTableview: UITableView!
    
    var locationDictonary : [String : Any]?
   
    var homeItem = [HomehorizontalModel]()
    var apiClient : ApiClient!
    
    var pageno  : Int = 1
    var limitno : Int = 25
    var homesearchItem = [HomehorizontalModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventDefaultTableview.delegate   = self
        eventDefaultTableview.dataSource = self
        apiClient = ApiClient()
        getHomeSearchApi()
        
        
//        let navigationOnTap = UITapGestureRecognizer(target: self, action: #selector(Edit_ProfileVC.navigationTap))
//        self.navigationController?.navigationBar.addGestureRecognizer(navigationOnTap)
//        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let navigationOnTap = UITapGestureRecognizer(target:self,action:#selector(EventViewController.navigationTap))
        self.navigationController?.navigationBar.addGestureRecognizer(navigationOnTap)
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    func navigationTap(){
        let offset = CGPoint(x: 0,y :0)
        self.eventDefaultTableview.setContentOffset(offset, animated: true)
        
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
        
        return homeItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "defaultTableCell", for: indexPath) as! DefaultHomeTableViewCell
        
        guard homeItem.count > 0 else {
            
            return cell
            
        }
        
        cell.eventArrowButon.tag = indexPath.row
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        cell.selectionStyle = .none
        cell.delegate       = self
        cell.eventTypeLabel.text = homeItem[indexPath.row].listTitle ?? "Events"
        return cell
    }
    
    func openEventList(index: Int) {
        
        openStoryBoard(name: Constants.Tab, id: Constants.Tabid1,primaryid: index)
        
    }
    
}

extension DefaultHomeController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return homeItem[collectionView.tag].eventHorizontalList?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventcell1", for: indexPath) as! EventDefaulCollectionCell
        
        guard homeItem[collectionView.tag].eventHorizontalList?.count ?? 0 > 0 else {
            
            return cell
            
        }
        
        
        if let item = homeItem[collectionView.tag].eventHorizontalList {
            
           cell.item = item[indexPath.row]
            
        }
      
        return cell
   
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard  let item = homeItem[collectionView.tag].eventHorizontalList,item.count > 0  else {
            
            return
        }
        
        if indexPath.row == item.count - 1  {
            
            if item.count  < homeItem[collectionView.tag].totalRows ?? 0 {
                    pageno += 1
                    limitno = 25 * pageno
                    getHomeSearchApi(position: collectionView.tag, pageno: pageno)
            }
        
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        openStoryBoard(name: Constants.Event, id: Constants.EventStoryId,primaryid: homeItem[collectionView.tag].eventHorizontalList?[indexPath.row].id ?? 0)
        
    }
    
    
    
    func openStoryBoard(name: String,id : String,primaryid : Int) {
        
        let storyboard                  = UIStoryboard(name: name, bundle: nil)
        
        if id == Constants.Tabid1 {
            
            let eventVc        = storyboard.instantiateViewController(withIdentifier: id) as! EventTabController
            eventVc.showNavBar = true
            eventVc.indexposition = primaryid
            eventVc.apiType       = "HomeSearch"
            self.navigationController!.pushViewController(eventVc, animated: true)
            
        } else {
            
            let initialViewController       = storyboard.instantiateViewController(withIdentifier: id) as! EventViewController
            initialViewController.eventprimaryid = primaryid
            self.navigationController!.pushViewController(initialViewController, animated: true)
            
        }
        
    }
    
   
}

extension DefaultHomeController {
    
    /****************************************complete signup******************************************************/
    
    func getHomeSearchApi() {
        
        let clientIp = ValidationHelper.Instance.getIPAddress() ?? "1.0.1"
        if locationDictonary == nil {
            
            if let lat = PrefsManager.sharedinstance.lastlocationlat,let long = PrefsManager.sharedinstance.lastlocationlat {
                
                locationDictonary = ["lattitude":lat,"longitude":long,"nearMeRadiusInMiles": 15000]
                
            }
            
        }
        
        print(locationDictonary ?? [])
        
        
        apiClient.getFireBaseToken(completion: { token in
            
            LoadingHepler.instance.show()
            
            let header     : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
            let parameters : Parameters = ["locationObject" : self.locationDictonary!,"clientip": clientIp, "clientapp": Constants.clientApp]
            self.apiClient.homeHorizontalSearchApi(parameters: parameters, headers: header, completion: { status,homemodel in
                
                if status == "success" {
                    
                    if let item = homemodel {
                        
                        if let list = item.eventList {
                            
                             self.homeItem = list
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.eventDefaultTableview.reloadData()
                        LoadingHepler.instance.hide()
                    }
                    
                    
                    
                } else {
                    
                    LoadingHepler.instance.hide()
                    
                    
                }
                
                
            })
            
            
        })
        
        
    }
    
    /****************************************complete signup******************************************************/
    
    func getHomeSearchApi(position:Int,pageno : Int) {
        
        let clientIp = ValidationHelper.Instance.getIPAddress() ?? "1.0.1"
        if locationDictonary == nil {
            
            if let lat = PrefsManager.sharedinstance.lastlocationlat,let long = PrefsManager.sharedinstance.lastlocationlat {
                
                locationDictonary = ["lattitude":lat,"longitude":long,"nearMeRadiusInMiles": 15000]
                
            }
            
        }
        
        print(locationDictonary ?? [])
        
        apiClient.getFireBaseToken(completion: { token in
            
            LoadingHepler.instance.show()
            
            let header     : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
            let parameters : Parameters = ["locationObject" : self.locationDictonary!,"clientip": clientIp, "clientapp": Constants.clientApp]
            self.apiClient.homeHorizontalSearchApiPagination(parameters: parameters, id: position, page: pageno, headers: header, completion: { status,homemodel in
                
                if status == "success" {
                    
                    if let item = homemodel {
                        
                        if let totalrows = item.totalRows {
                            
                            self.homeItem[position].totalRows = totalrows
                        }
                        
                        if let items = item.eventHorizontalList {
                            
                            for item in items {
                                
                                self.homeItem[position].eventHorizontalList?.append(item)
                                
                            }
                        
                        }
                     
                        
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.eventDefaultTableview.reloadData()
                        LoadingHepler.instance.hide()
                    }
                
                    
                } else {
                    
                    LoadingHepler.instance.hide()
                   
                }
                
                
            })
          
        })
        
        
    }
    
}
