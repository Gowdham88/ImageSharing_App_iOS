//
//  LocationTabController.swift
//  Numnu
//
//  Created by CZ Ltd on 11/1/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
import Alamofire

protocol  LocationTabControllerDelegate {
    
    func locationTableHeight(height : CGFloat)
    
}

class LocationTabController: UIViewController,IndicatorInfoProvider {
    var pageno       : Int  = 1
    var limitno      : Int = 25
    var apiClient    : ApiClient!
    var locationItem : ItemLocationList!
    var loclist      = [LocList]()

    
    @IBOutlet weak var locationTableView: UITableView!
    var locationdelegate : LocationTabControllerDelegate?
    var viewState        : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTableView.delegate   = self
        locationTableView.dataSource = self
        locationTableView.isScrollEnabled = false
//        let navigationOnTap = UITapGestureRecognizer(target: self, action: #selector(LocationTabController.navigationTap))
//        self.navigationController?.navigationBar.addGestureRecognizer(navigationOnTap)
//        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
        apiClient = ApiClient()
    }
    override func viewWillAppear(_ animated: Bool) {
        let navigationOnTap = UITapGestureRecognizer(target:self,action:#selector(EventViewController.navigationTap))
        self.navigationController?.navigationBar.addGestureRecognizer(navigationOnTap)
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        viewState = true
        loclist.removeAll()
        locationTableView.reloadData()
        pageno  = 1
        limitno = 25
       
        getLocationApi(pageno: pageno, limit: limitno)
    }
    
    func getLocationApi(pageno: Int, limit: Int){
        
        LoadingHepler.instance.show()
        
        apiClient.getFireBaseToken(completion: { token in
            
            let header : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
            let param  : String  = "page=\(pageno)&limit\(limit)"
            
            self.apiClient.getLocationByItemId(id: 35, page: param,headers: header, completion: { status,list in
                
                if status == "success" {
                    
                    if let item = list {
                        print("list from response:::::::",item)
                        self.locationItem = item
                        
                        if let locationdata = item.location {
                            self.loclist  += locationdata
                        }
                        
                      
                    }
                    
                    DispatchQueue.main.async {
                        self.locationTableView.reloadData()
                        
                    }
                    
                    self.reloadTable()
                    
                } else {
                    
                    LoadingHepler.instance.hide()
                    self.reloadTable()
                    
                }
                
                
            })
            
            
        })
        
        
    }
    
    func reloadTable() {
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            self.locationdelegate?.locationTableHeight(height: self.locationTableView.contentSize.height)
            LoadingHepler.instance.hide()
        }
        
    }
    
    func navigationTap(){
        let offset = CGPoint(x: 0,y :0)
        self.locationTableView.setContentOffset(offset, animated: true)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: Constants.Tab7)
    }
   

}

extension LocationTabController : UITableViewDelegate,UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return loclist.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationcell", for: indexPath) as! Locationtableviewcell
        guard loclist.count > 0 else {
            return cell
        
        }
        cell.itemm = loclist[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        openStoryBoard()
        
    }
    
    func  openStoryBoard() {
        
        let storyboard = UIStoryboard(name: Constants.LocationDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.LocationDetailId)
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == loclist.count - 1 && viewState {
            
            if let pageItem = locationItem {
                
                if loclist.count  < pageItem.totalRows ?? 0 {
                    pageno += 1
                    limitno = 25 * pageno
                    getLocationApi(pageno: pageno, limit: limitno)
                }
                
            }
            
        }
    }
    
    
}
