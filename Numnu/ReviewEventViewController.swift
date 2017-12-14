//
//  ReviewEventViewController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/26/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import PKHUD
import SwiftyJSON
import Alamofire

protocol ReviewEventViewControllerDelegate {
    
    func popupClick()
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
        
      
    }
//    func getFirebaseToken() {
//
//        apiClient.getFireBaseToken(completion:{ token in
//
//            self.token_str = token
//            self.methodToCallApi()
//
//        })
//
//    }
    func methodToCallApi(pageno:Int,limit:Int){
        
        HUD.show(.labeledProgress(title: "Loading", subtitle: ""))
        apiClient.getFireBaseToken(completion: { token in
        
        let header     : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
        let param  : String  = "page=\(pageno)&limit\(limit)"
//        apiClient.getEventsDetailsApi(headers: header, completion: { status,Values in
            self.apiClient.PostsByEventId(id: 34, page: param, headers: header, completion: { status,Values in
    
           
                    
                    if status == "success" {
                        
                        if let itemlist = Values {
                            
                            self.postModel = itemlist
                            
                            if let list = itemlist.data {
                                
                                self.postList += list
                            }
                        }
                        
                        DispatchQueue.main.async {
                            
                            self.postEventTableview.reloadData()
                            
                        }
                        
                        self.reloadTable()
                    
                    }else {
                        
                        HUD.hide()
                        self.reloadTable()
                        
            }
                
           
        })
            })
        
        
    }
    func reloadTable() {
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            
             self.popdelegate?.postTableHeight(height: self.postEventTableview.contentSize.height)
            HUD.hide()
        }
        
    }
    func getDetails(response:PostListByEventId){
//        if let name = response.username {
//            postDtUsernameLabel.text = name
//        }
    
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
       viewState = true
        postList.removeAll()
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
        
        cell.delegate = self
        cell.item = postList[indexPath.row]
        cell.postDtEventBookMark.tag = indexPath.row
        cell.setHeight(heightview : Float(UIScreen.main.bounds.size.height))
        
        let posteventImagetap = UITapGestureRecognizer(target: self, action: #selector(getter: postEventDetailTableViewCell.postDtEventImage))
        cell.postDtEventImage.addGestureRecognizer(posteventImagetap)
        cell.postDtEventImage.isUserInteractionEnabled = true
        
        //icon tap dish
        let itemImageTap = UITapGestureRecognizer(target: self, action: #selector(getter: postEventDetailTableViewCell.itemImageTap))
        cell.itemImageTap.addGestureRecognizer(itemImageTap)
        cell.itemImageTap.isUserInteractionEnabled = true
        
        //icon business tap
        let businessImageTap = UITapGestureRecognizer(target: self, action: #selector(getter: postEventDetailTableViewCell.businessImageTap))
        cell.businessImageTap.addGestureRecognizer(businessImageTap)
        cell.businessImageTap.isUserInteractionEnabled = true
        
        //icon event tap
        let eventImageTap = UITapGestureRecognizer(target: self, action: #selector(getter: postEventDetailTableViewCell.eventImageTap))
        cell.eventImageTap.addGestureRecognizer(eventImageTap)
        cell.eventImageTap.isUserInteractionEnabled = true
        
        
        
        let posteventplacetap = UITapGestureRecognizer(target: self, action:#selector(getter: postEventDetailTableViewCell.postDtEventPlace))
        cell.postDtEventPlace.addGestureRecognizer(posteventplacetap)
        cell.postDtEventPlace.isUserInteractionEnabled = true
        
        let posteventdishtap = UITapGestureRecognizer(target: self, action:#selector(getter: postEventDetailTableViewCell.postDtEventDishLabel))
        cell.postDtEventDishLabel.addGestureRecognizer(posteventdishtap)
        cell.postDtEventDishLabel.isUserInteractionEnabled = true
        
        let posteventnametap = UITapGestureRecognizer(target: self, action:#selector(getter: postEventDetailTableViewCell.postDtEventName))
        cell.postDtEventName.addGestureRecognizer(posteventnametap)
        cell.postDtEventName.isUserInteractionEnabled = true
        
        let profiletap = UITapGestureRecognizer(target: self, action:#selector(getter: postEventDetailTableViewCell.postDtUserImage))
        cell.postDtUserImage.addGestureRecognizer(profiletap)
        cell.postDtUserImage.isUserInteractionEnabled = true
        
        let profileusernametap = UITapGestureRecognizer(target: self, action:#selector(getter: postEventDetailTableViewCell.postDtUsernameLabel))
        cell.postDtUsernameLabel.addGestureRecognizer(profileusernametap)
        cell.postDtUsernameLabel.isUserInteractionEnabled = true
        
        let profileusernametagtap = UITapGestureRecognizer(target: self, action:#selector(getter: postEventDetailTableViewCell.postDtUsernameLabel))
        cell.postDtUserplaceLabbel.addGestureRecognizer(profileusernametagtap)
        cell.postDtUserplaceLabbel.isUserInteractionEnabled = true
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
  
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if TextSize.sharedinstance.getNumberoflines(text: Constants.dummy, width: tableView.frame.width, font: UIFont(name: "Avenir-Book", size: 16)!) > 1 {

            return 428

        } else {

            return 402
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
   
    func postDtEventImage() {
        let storyboard = UIStoryboard(name: Constants.PostDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "postdetailid")
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    func postDtEventPlace(){
        let storyboard = UIStoryboard(name: Constants.ItemDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.ItemDetailId)
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    func itemImageTap(){
            let storyboard = UIStoryboard(name: Constants.ItemDetail, bundle: nil)
            let vc         = storyboard.instantiateViewController(withIdentifier: Constants.ItemDetailId)
            self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    func postDtEventDishLabel(){
        let storyboard = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.BusinessCompleteId)
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    
    func businessImageTap(){
        let storyboard = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.BusinessCompleteId)
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    func postDtEventName(){
        
        let storyboard = UIStoryboard(name: Constants.Event, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.EventStoryId)
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    
    func eventImageTap(){
        
        let storyboard = UIStoryboard(name: Constants.Event, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.EventStoryId)
        self.navigationController!.pushViewController(vc, animated: true)
    }
    func postDtUserImage(){
        
        let storyboard = UIStoryboard(name: Constants.Main, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "Profile_PostViewController") as! Profile_PostViewController
        vc.boolForBack = false
        self.navigationController!.pushViewController(vc, animated: true)
    }
    func postDtUsernameLabel(){
        
        let storyboard = UIStoryboard(name: Constants.Main, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "Profile_PostViewController") as! Profile_PostViewController
        vc.boolForBack = false
        self.navigationController!.pushViewController(vc, animated: true)
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
        
       popdelegate!.popupClick()
        
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
