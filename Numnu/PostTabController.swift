//
//  PostTabController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/9/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire

protocol  PostTabControllerDelegate{
    
    func popupClick()
}

class PostTabController: UIViewController,IndicatorInfoProvider {
    
    @IBOutlet weak var postEventTableView: UITableView!
    var window : UIWindow?
    var popdelegate : PostTabControllerDelegate?
    
   
    
    /******************Event Api******************************/
    
    var apiClient : ApiClient!
    var postList = [PostListDataItems]()
    var homeItem  : HomeSearchModel?
    var pageno : Int  = 1
    var limitno : Int = 25
    var apiType : String = "Event"
    
    var locationDictonary : [String : Any]?
    var searchText        : String?

    override func viewDidLoad() {
        super.viewDidLoad()
      
        postEventTableView.delegate   = self
        postEventTableView.dataSource = self
        
        apiClient = ApiClient()
        // Do any additional setup after loading the view.
        getHomeSearchApi(pageno: pageno)

////        postEventTableView.sizeToFit()
//        postEventTableView.estimatedRowHeight = 388
//        postEventTableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: Constants.Tab4)
    }
    

}

extension PostTabController : UITableViewDelegate,UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postEventCell", for: indexPath) as! PostEventTableViewCell
        
        guard postList.count > 0 else {
            
            return cell
        }
        
        cell.delegate = self
        cell.item = postList[indexPath.row]
        cell.postEventBookMark.tag = indexPath.row
        cell.setHeight(heightview : Float(UIScreen.main.bounds.size.height))
        
        let posteventImagetap = UITapGestureRecognizer(target: self, action: #selector(postDtEventImages(sender:)))
        cell.postEventImage.addGestureRecognizer(posteventImagetap)
        cell.postEventImage.tag = indexPath.row
        cell.postEventImage.isUserInteractionEnabled = true
        
        //icon tap dish
        let itemImageTap = UITapGestureRecognizer(target: self, action: #selector(itemImageTap(sender:)))
        cell.itemImageTap.addGestureRecognizer(itemImageTap)
        cell.itemImageTap.tag = indexPath.row
        cell.itemImageTap.isUserInteractionEnabled = true
        
        //icon business tap
        let businessImageTap = UITapGestureRecognizer(target: self, action: #selector(businessImageTap(sender:)))
        cell.businessImageTap.addGestureRecognizer(businessImageTap)
        cell.businessImageTap.tag = indexPath.row
        cell.businessImageTap.isUserInteractionEnabled = true
        
        //icon event tap
        let eventImageTap = UITapGestureRecognizer(target: self, action: #selector(eventImageTap(sender:)))
        cell.eventImageTap.addGestureRecognizer(eventImageTap)
        cell.eventImageTap.tag = indexPath.row
        cell.eventImageTap.isUserInteractionEnabled = true
        
        let posteventplacetap = UITapGestureRecognizer(target: self, action:#selector(postDtEventPlace(sender:)))
        cell.postEventPlace.addGestureRecognizer(posteventplacetap)
        cell.postEventPlace.tag = indexPath.row
        cell.postEventPlace.isUserInteractionEnabled = true
        
        let posteventdishtap = UITapGestureRecognizer(target: self, action:#selector(postDtEventDishLabel(sender:)))
        cell.postEventDishLabel.addGestureRecognizer(posteventdishtap)
        cell.postEventDishLabel.tag = indexPath.row
        cell.postEventDishLabel.isUserInteractionEnabled = true
        
        let posteventnametap = UITapGestureRecognizer(target: self, action:#selector(postDtEventName(sender:)))
        cell.postEventName.addGestureRecognizer(posteventnametap)
        cell.postEventName.tag = indexPath.row
        cell.postEventName.isUserInteractionEnabled = true
        
        let profiletap = UITapGestureRecognizer(target: self, action:#selector(postDtUserImage(sender:)))
        cell.postUserImage.addGestureRecognizer(profiletap)
        cell.postUserImage.tag = indexPath.row
        cell.postUserImage.isUserInteractionEnabled = true
        
        let profileusernametap = UITapGestureRecognizer(target: self, action:#selector(postDtUserImage(sender:)))
        cell.postUsernameLabel.addGestureRecognizer(profileusernametap)
        cell.postUsernameLabel.tag = indexPath.row
        cell.postUsernameLabel.isUserInteractionEnabled = true
        
        let profileusernametagtap = UITapGestureRecognizer(target: self, action:#selector(postDtUserImage(sender:)))
        cell.postUserplaceLabbel.addGestureRecognizer(profileusernametagtap)
        cell.postUserplaceLabbel.tag = indexPath.row
        cell.postUserplaceLabbel.isUserInteractionEnabled = true
        
        return cell
       
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let item = postList[indexPath.row].comment {
            
            if TextSize.sharedinstance.getNumberoflines(text: item, width: tableView.frame.width, font: UIFont(name: "Avenir-Book", size: 16)!) > 1 {
                
                return 428
                
            } else {
                
                return 392
            }
            
        } else {
            
            return 392
            
        }
        
    }
    
    
    func postDtEventImages(sender: UITapGestureRecognizer) {
        let tag        = sender.view!.tag
        let storyboard = UIStoryboard(name: Constants.PostDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "postdetailid") as! PostDetailViewController
        vc.item        = postList[tag]
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    func postDtEventPlace(sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: Constants.ItemDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.ItemDetailId) as! ItemDetailController
        vc.itemprimaryid = postList[sender.view!.tag].taggedItemId ?? 0
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    func itemImageTap(sender: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: Constants.ItemDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.ItemDetailId) as! ItemDetailController
        vc.itemprimaryid = postList[sender.view!.tag].taggedItemId ?? 0
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    func postDtEventDishLabel(sender: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.BusinessCompleteId) as! BusinessCompleteViewController
        vc.businessprimaryid = postList[sender.view!.tag].business?.id ?? 0
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    
    func businessImageTap(sender: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.BusinessCompleteId) as! BusinessCompleteViewController
        vc.businessprimaryid = postList[sender.view!.tag].business?.id ?? 0
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    func postDtEventName(sender: UITapGestureRecognizer){
        
        let storyboard = UIStoryboard(name: Constants.Event, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.EventStoryId) as! EventViewController
        vc.eventprimaryid = postList[sender.view!.tag].event?.id ?? 0
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    
    func eventImageTap(sender: UITapGestureRecognizer){
        
        let storyboard = UIStoryboard(name: Constants.Event, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.EventStoryId)  as! EventViewController
        vc.eventprimaryid = postList[sender.view!.tag].event?.id ?? 0
        self.navigationController!.pushViewController(vc, animated: true)
    }
    func postDtUserImage(sender: UITapGestureRecognizer){
        let tag        = sender.view!.tag
        let storyboard = UIStoryboard(name: Constants.PostDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.Profile_LinkViewController) as! ProfileLinkController
        vc.postListDataItems  = postList[tag]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func postDtUsernameLabel(sender: UITapGestureRecognizer){
        let tag        = sender.view!.tag
        let storyboard = UIStoryboard(name: Constants.PostDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.Profile_LinkViewController) as! ProfileLinkController
        vc.postListDataItems  = postList[tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == postList.count - 1  {
            
            if let pageItem = homeItem {
                
                if postList.count  < pageItem.totalRows ?? 0 {
                    pageno += 1
                    limitno = 25 * pageno
                    getHomeSearchApi(pageno: pageno)
                }
                
            }
            
        }
        
    }
    
}

extension PostTabController {
    
    
    func  openStoryBoard() {
        
        let storyboard = UIStoryboard(name: Constants.PostDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.PostDetailId)
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    
}

/**************custom delegate******************/

extension PostTabController : PostEventTableViewCellDelegate {
    
    func bookmarkPost(tag: Int) {
    
        popdelegate!.popupClick()
    
    }
    
    func share() {
        
        let optionMenu = UIAlertController(title:"Post", message: "", preferredStyle: .actionSheet)
        
        let Bookmark = UIAlertAction(title: "Bookmark", style: .default, handler: {
            
            (alert : UIAlertAction!) -> Void in
            
            self.window    = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: Constants.Auth, bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "signupvc")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
        })
        
        let Share = UIAlertAction(title: "Share", style: .default, handler: {
            
            (alert : UIAlertAction!) -> Void in
            
        })
        
        let Cancel = UIAlertAction(title: "Cancel", style: .default, handler: {
            
            (alert: UIAlertAction!) -> Void in
            
        })
    
        optionMenu.addAction(Bookmark)
        optionMenu.addAction(Share)
        optionMenu.addAction(Cancel)
       
        optionMenu.popoverPresentationController?.sourceView = self.view
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        self.present(optionMenu, animated: true, completion: nil)
    
    }
}

extension PostTabController {

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
        self.apiClient.homeSearchApi(parameters: parameters, type: "posts",pageno: pageno, headers: header, completion: { status,homemodel in
            
            if status == "success" {
                
                if let item = homemodel {
                    
                    self.homeItem = item
                    
                    if let postlist = item.postList {
                        
                        self.postList += postlist
                    }
                }
                
                DispatchQueue.main.async {
                    
                    self.postEventTableView.reloadData()
                     LoadingHepler.instance.hide()
                }
                
               
                
            } else {
                
                LoadingHepler.instance.hide()
                
                
            }
            
            
        })
        
        
    })
    
    
}


}


