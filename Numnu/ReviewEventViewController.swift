//
//  ReviewEventViewController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/26/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
import Alamofire

protocol ReviewEventViewControllerDelegate {
    
    func popupClick(postid : Int,postname : String)
    func postTableHeight(height : CGFloat)
}

class ReviewEventViewController: UIViewController,IndicatorInfoProvider {
    
    var apiClient     : ApiClient!
    var token_str     : String = "empty"
    var postList = [PostListDataItems]()
    var postModel  : PostListByEventId?
    var pageno  : Int = 1
    var limitno : Int = 25

    @IBOutlet weak var postEventTableview: UITableView!
    var window : UIWindow?
    var popdelegate : ReviewEventViewControllerDelegate?
    var viewState       : Bool = false
    var primaryid       : Int  = 0
    var apiType         : String = "Event"
    
   /*********************Event context*******************************/
    
    var eventId  : Int = 0
    
    @IBOutlet weak var businesslabelwidth: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        postEventTableview.delegate   = self
        postEventTableview.dataSource = self
        postEventTableview.isScrollEnabled = false
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            
             self.popdelegate?.postTableHeight(height: self.postEventTableview.contentSize.height)
        }
        apiClient = ApiClient()
        
        if apiType == "Item" || apiType == "Location" || apiType == "Business"   {
            
            methodToCallApi(pageno: pageno, limit: limitno)
        }
      
    }

    func methodToCallApi(pageno:Int,limit:Int){
        
        LoadingHepler.instance.show()
        apiClient.getFireBaseToken(completion: { token in
        
        let header     : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
        let param  : String  = "page=\(pageno)&limit\(limit)"
            
            switch self.apiType {
                
            case "BusinessEvent":
                
                /********************************Event context******************************************/
                
                self.apiClient.getPostListByEvent(eventId: self.eventId,id: self.primaryid, page: param, type: self.apiType, headers: header, completion: { status,Values in
                    
                    if status == "success" {
                        
                        if let itemlist = Values {
                            
                            self.postModel = itemlist
                            
                            if let list = itemlist.data {
                                
                                self.postList += list
                            }
                            
                        }
                        
                        DispatchQueue.main.async {
                            
                            self.postEventTableview.reloadData()
                            print("APi\(self.postList.count)")
                        }
                        
                        self.reloadTable()
                        
                    } else {
                        
                        LoadingHepler.instance.hide()
                        self.reloadTable()
                        
                    }
                    
                    
                })
                
                
            default:
                
                self.apiClient.getPostList(id: self.primaryid, page: param, type: self.apiType, headers: header, completion: { status,Values in
                    
                    if status == "success" {
                        
                        if let itemlist = Values {
                            
                            self.postModel = itemlist
                            
                            if let list = itemlist.data {
                                
                                self.postList += list
                            }
                            
                        }
                        
                        DispatchQueue.main.async {
                            
                            self.postEventTableview.reloadData()
                            print("APi\(self.postList.count)")
                        }
                        
                        self.reloadTable()
                        
                    }else {
                        
                        LoadingHepler.instance.hide()
                        self.reloadTable()
                        
                    }
                    
                    
                })
                
            }

        
        })
        
        
    }
    func reloadTable() {
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            
             self.popdelegate?.postTableHeight(height: self.postEventTableview.contentSize.height)
             LoadingHepler.instance.hide()
        }
        
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        viewState = true
        postList.removeAll()
        postEventTableview.reloadData()
        pageno  = 1
        limitno = 25
        methodToCallApi(pageno: pageno, limit: limitno)
       
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: Constants.EventTab3)
    }
   
}

extension ReviewEventViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postEventCell", for: indexPath) as! postEventDetailTableViewCell
        
        guard postList.count > 0 else {
            
            return cell
        }
        
        cell.delegate = self
        cell.item = postList[indexPath.row]
        cell.postDtEventBookMark.tag = indexPath.row
//        cell.setHeight(heightview : Float(UIScreen.main.bounds.size.height))
        
        let posteventImagetap = UITapGestureRecognizer(target: self, action: #selector(postDtEventImages(sender:)))
        cell.postDtEventImage.addGestureRecognizer(posteventImagetap)
        cell.postDtEventImage.tag = indexPath.row
        cell.postDtEventImage.isUserInteractionEnabled = true
        
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
        cell.postDtEventPlace.addGestureRecognizer(posteventplacetap)
        cell.postDtEventPlace.tag = indexPath.row
        cell.postDtEventPlace.isUserInteractionEnabled = true
        
        let posteventdishtap = UITapGestureRecognizer(target: self, action:#selector(postDtEventDishLabel(sender:)))
        cell.postDtEventDishLabel.addGestureRecognizer(posteventdishtap)
        cell.postDtEventDishLabel.tag = indexPath.row
        cell.postDtEventDishLabel.isUserInteractionEnabled = true
        
        let posteventnametap = UITapGestureRecognizer(target: self, action:#selector(postDtEventName(sender:)))
        cell.postDtEventName.addGestureRecognizer(posteventnametap)
        cell.postDtEventName.tag = indexPath.row
        cell.postDtEventName.isUserInteractionEnabled = true
        
        let profiletap = UITapGestureRecognizer(target: self, action:#selector(postDtUserImage(sender:)))
        cell.postDtUserImage.addGestureRecognizer(profiletap)
        cell.postDtUserImage.tag = indexPath.row
        cell.postDtUserImage.isUserInteractionEnabled = true
        
        let profileusernametap = UITapGestureRecognizer(target: self, action:#selector(postDtUserImage(sender:)))
        cell.postDtUsernameLabel.addGestureRecognizer(profileusernametap)
        cell.postDtUsernameLabel.tag = indexPath.row
        cell.postDtUsernameLabel.isUserInteractionEnabled = true
        
        let profileusernametagtap = UITapGestureRecognizer(target: self, action:#selector(postDtUserImage(sender:)))
        cell.postDtUserplaceLabbel.addGestureRecognizer(profileusernametagtap)
        cell.postDtUserplaceLabbel.tag = indexPath.row
        cell.postDtUserplaceLabbel.isUserInteractionEnabled = true
        
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == postList.count - 1 && viewState {
            
            if let pageItem = postModel {
                
                if postList.count  < pageItem.totalRows ?? 0 {
                    pageno += 1
                    limitno = 25 * pageno
                    methodToCallApi(pageno: pageno, limit: limitno)
                }
                
            }
            
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
    
}

extension ReviewEventViewController {
    
    func openStoryBoard() {
        
        let storyboard = UIStoryboard(name: Constants.PostDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.PostDetailId)
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    
}

/**************custom delegate******************/

extension ReviewEventViewController : postEventDetailTableViewCellDelegate {
    
    func bookmarkPost(tag: Int) {
        
       popdelegate!.popupClick(postid: postList[tag].id ?? 0, postname: postList[tag].business?.businessname ?? "Entinty name")
        
    }
    
    func share() {
        
        let optionMenu = UIAlertController(title:"Posts", message: "", preferredStyle: .actionSheet)
        
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
