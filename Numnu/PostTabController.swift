//
//  PostTabController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/9/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip

protocol  PostTabControllerDelegate{
    
    func popupClick()
}

class PostTabController: UIViewController,IndicatorInfoProvider {
    
    @IBOutlet weak var postEventTableView: UITableView!
    var window : UIWindow?
    var popdelegate : PostTabControllerDelegate?
    
    var locationDictonary : [String : Any]?
    var searchText        : String?

    override func viewDidLoad() {
        super.viewDidLoad()
      
        postEventTableView.delegate   = self
        postEventTableView.dataSource = self

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
        
        return 6
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postEventCell", for: indexPath) as! PostEventTableViewCell
        
        cell.delegate = self
        cell.postEventBookMark.tag = indexPath.row
        cell.setHeight(heightview : Float(UIScreen.main.bounds.size.height))
       
        let posteventImagetap = UITapGestureRecognizer(target: self, action: #selector(getter: PostEventTableViewCell.postEventImage))
        cell.postEventImage.addGestureRecognizer(posteventImagetap)
        cell.postEventImage.isUserInteractionEnabled = true
        
        //item page
        let posteventplacetap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postEventPlace))
        cell.postEventPlace.addGestureRecognizer(posteventplacetap)
        cell.postEventPlace.isUserInteractionEnabled = true
        
        let postEventPlaceIcontap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postEventPlaceIcon))
        cell.postEventPlaceIcon.addGestureRecognizer(postEventPlaceIcontap)
        cell.postEventPlaceIcon.isUserInteractionEnabled = true
        
        //Business page Icon
        let posteventdishtap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postEventDishLabel))
        cell.postEventDishLabel.addGestureRecognizer(posteventdishtap)
        cell.postEventDishLabel.isUserInteractionEnabled = true
        
        let postEventDishIcontap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postEventDishIcon))
        cell.postEventDishIcon.addGestureRecognizer(postEventDishIcontap)
        cell.postEventDishIcon.isUserInteractionEnabled = true
        
        //Event page Icon
        let posteventnametap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postEventName))
        cell.postEventName.addGestureRecognizer(posteventnametap)
        cell.postEventName.isUserInteractionEnabled = true
        
        let postEventNameIcontap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postEventNameIcon))
        cell.postEventNameIcon.addGestureRecognizer(postEventNameIcontap)
        cell.postEventNameIcon.isUserInteractionEnabled = true
        
        let profiletap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postUserImage))
        cell.postUserImage.addGestureRecognizer(profiletap)
        cell.postUserImage.isUserInteractionEnabled = true
        
        let profileusernametap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postUsernameLabel))
        cell.postUsernameLabel.addGestureRecognizer(profileusernametap)
        cell.postUsernameLabel.isUserInteractionEnabled = true
        
        let profileusernametagtap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postUsernameLabel))
        cell.postUserplaceLabbel.addGestureRecognizer(profileusernametagtap)
        cell.postUserplaceLabbel.isUserInteractionEnabled = true
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        openStoryBoard()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if TextSize.sharedinstance.getNumberoflines(text: Constants.dummy, width: tableView.frame.width, font: UIFont(name: "Avenir-Book", size: 16)!) > 1 {
            
            return 428
            
        } else {
            
            return 402
        }
        
    }
    func postEventImage() {
        let storyboard = UIStoryboard(name: Constants.PostDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "postdetailid") as! PostDetailViewController
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    func postEventPlace(){
        let storyboard = UIStoryboard(name: Constants.ItemDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.ItemDetailId)
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    func postEventPlaceIcon(){
        let storyboard = UIStoryboard(name: Constants.ItemDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.ItemDetailId)
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    func postEventDishLabel(){
        let storyboard = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.BusinessCompleteId)
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    func postEventDishIcon(){
        let storyboard = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.BusinessCompleteId)
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    func postEventName(){
        
        let storyboard = UIStoryboard(name: Constants.Event, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.EventStoryId)
        self.navigationController!.pushViewController(vc, animated: true)
    }
    func postEventNameIcon(){
        
        let storyboard = UIStoryboard(name: Constants.Event, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.EventStoryId)
        self.navigationController!.pushViewController(vc, animated: true)
    }
    func postUserImage(){
        let storyboard = UIStoryboard(name: Constants.PostDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.Profile_LinkViewController) as! ProfileLinkController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func postUsernameLabel(){
        
        let storyboard = UIStoryboard(name: Constants.PostDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.Profile_LinkViewController) as! ProfileLinkController
        self.navigationController!.pushViewController(vc, animated: true)
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


