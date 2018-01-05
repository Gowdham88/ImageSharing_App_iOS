//
//  UserTabController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/9/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire

class UserTabController: UIViewController,IndicatorInfoProvider,UITableViewDataSource,UITableViewDelegate {
  
    
    var nameArray = [String]()
    var imagesArray = [UIImage]()
    
    var locationDictonary : [String : Any]?
    var searchText        : String?
    
    var homeItem  : HomeSearchModel?
    var userList = [UserHomeList]()
    var apiClient : ApiClient!
    
    var pageno  : Int = 1
    var limitno : Int = 25

    @IBOutlet weak var userTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        apiClient = ApiClient()
        // Do any additional setup after loading the view.
        getHomeSearchApi(pageno: pageno)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTableView.dequeueReusableCell(withIdentifier: "Cell" ) as! UserTableViewCell
        
        guard userList.count > 0 else {
            
            return cell
        }
        
        cell.item   = userList[indexPath.row]
        cell.userImage.layer.cornerRadius = cell.userImage.frame.size.height/2
        cell.userImage.clipsToBounds = true

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: Constants.PostDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.Profile_LinkViewController) as! ProfileLinkController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // Tab intialliaze
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: Constants.Tab5)


    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == userList.count - 1  {
            
            if let pageItem = homeItem {
                
                if userList.count  < pageItem.totalRows ?? 0 {
                    pageno += 1
                    limitno = 25 * pageno
                    getHomeSearchApi(pageno: pageno)
                }
                
            }
            
        }
    }
    

   

}

extension UserTabController {
    
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
            self.apiClient.homeSearchApi(parameters: parameters, type: "users",pageno: pageno, headers: header, completion: { status,homemodel in
                
                if status == "success" {
                    
                    if let item = homemodel {
                        
                        self.homeItem = item
                        
                        if let userlist = item.userList {
                            
                            self.userList += userlist
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.userTableView.reloadData()
                        LoadingHepler.instance.hide()
                    }
                    
                    
                    
                } else {
                    
                    LoadingHepler.instance.hide()
                    
                    
                }
                
                
            })
            
            
        })
        
        
    }
}
