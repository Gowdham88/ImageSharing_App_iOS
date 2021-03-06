//
//  PostDetailViewController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/27/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import Nuke
import Alamofire

class PostDetailViewController : UIViewController {
    
    
    
    @IBOutlet weak var postDUsernameLabel: UILabel!
    @IBOutlet weak var postDUserImage: ImageExtender!
    @IBOutlet weak var postDUserplaceLabbel: UILabel!
    @IBOutlet weak var postDUserTime: UILabel!
    @IBOutlet weak var postDCommentLabel: UILabel!
    @IBOutlet weak var postDEventImage: ImageExtender!
    @IBOutlet weak var postDLikeImage: ImageExtender!
    @IBOutlet weak var postDEventName: UILabel!
    @IBOutlet weak var postDEventPlace: UILabel!
    @IBOutlet weak var postDEventDishLabel: UILabel!
    @IBOutlet var itemTap: ImageExtender!
    @IBOutlet var businessTap: ImageExtender!
    @IBOutlet var eventTap: ImageExtender!
    @IBOutlet weak var dishwidthDConstaint: NSLayoutConstraint!
//    @IBOutlet weak var placeWidthDConstraint: NSLayoutConstraint!
//    @IBOutlet weak var dishRightDLayoutConstraint: NSLayoutConstraint!

    @IBOutlet weak var alertViewHide: UIView!
    @IBOutlet weak var mainPostView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var navigationItemList: UINavigationItem!
    var window : UIWindow?
    var coverView : UIView?
    var item : PostListDataItems?
    var apiClient : ApiClient!
    
    /*******************share label*****************************/
    
    @IBOutlet weak var sharepostlabel: UILabel!
    @IBOutlet weak var bookmarkpostlabel: UILabel!
    
    @IBOutlet weak var eventTopHeight: NSLayoutConstraint!
    @IBOutlet weak var alertviewBottomConstraints: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBar()
//        setHeight(heightview: Float(UIScreen.main.bounds.size.height))
        
        alertviewBottomConstraints.constant = self.view.frame.height + 600
        alertViewHide.alpha = 0
        alertTapRegister()

        let tap = UITapGestureRecognizer(target: self, action: #selector(PostDetailViewController.imageTapped))
        postDEventImage.addGestureRecognizer(tap)
        postDEventImage.isUserInteractionEnabled = true
        
        let postitemlabeltap = UITapGestureRecognizer(target: self, action: #selector(PostDetailViewController.postitemlabeltap))
        postDEventPlace.addGestureRecognizer(postitemlabeltap)
        postDEventPlace.isUserInteractionEnabled = true
  
        let posteventdishlabeltap = UITapGestureRecognizer(target: self, action: #selector(PostDetailViewController.posteventdishlabeltap))
        postDEventDishLabel.addGestureRecognizer(posteventdishlabeltap)
        postDEventDishLabel.isUserInteractionEnabled = true
        
        
        let userEventTap = UITapGestureRecognizer(target: self, action: #selector(PostDetailViewController.userEventTap))
        eventTap.addGestureRecognizer(userEventTap)
        eventTap.isUserInteractionEnabled = true
        
        let posteventlabeltap = UITapGestureRecognizer(target: self, action: #selector(PostDetailViewController.posteventlabeltap))
        postDEventName.addGestureRecognizer(posteventlabeltap)
        postDEventName.isUserInteractionEnabled = true
        
        let userBusiTap = UITapGestureRecognizer(target: self, action: #selector(PostDetailViewController.userBusiTap))
        businessTap.addGestureRecognizer(userBusiTap)
        businessTap.isUserInteractionEnabled = true
        
        
        let userItemTap = UITapGestureRecognizer(target: self, action: #selector(PostDetailViewController.userItemTap))
        itemTap.addGestureRecognizer(userItemTap)
        itemTap.isUserInteractionEnabled = true
        
        
        let userimagetap = UITapGestureRecognizer(target: self, action: #selector(PostDetailViewController.postDUserImagetap))
        postDUserImage.addGestureRecognizer(userimagetap)
        postDUserImage.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
        
        let profileusernametagtap = UITapGestureRecognizer(target: self, action:#selector(PostDetailViewController.postDUserImagetap))
        postDUserplaceLabbel.addGestureRecognizer(profileusernametagtap)
        postDUserplaceLabbel.isUserInteractionEnabled = true
        
        let profileusernametap = UITapGestureRecognizer(target: self, action:#selector(PostDetailViewController.profileusernametap))
        postDUsernameLabel.addGestureRecognizer(profileusernametap)
        postDUsernameLabel.isUserInteractionEnabled = true
       
        apiClient = ApiClient()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        getData()
    }
    func getData() {
        
        if let datepost = item?.createdat {
            
            postDUserTime.text =  DateFormatterManager.sharedinstance.dateDiff(dateStr: datepost,Format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
        }

        if let posttag = item?.postcreator {
                if let postuser = posttag.name {
                self.postDUsernameLabel.text! = postuser
            
                }
            if let postusername = posttag.username {
                self.postDUserplaceLabbel.text! = "@\(postusername)"
                
            }
            
                if let userimageList = posttag.userimages {
            
                    if userimageList.count > 0 {
            
                            let apiclient = ApiClient()
                                    apiclient.getFireBaseImageUrl(imagepath: userimageList[userimageList.count-1].imageurl_str!, completion: { url in
            
                            self.postDUserImage.image = nil
                                        Manager.shared.loadImage(with: URL(string : url)!, into: self.postDUserImage)
            
                                    })
            
                                }
            
                            }
            
                    }
//                        if let location = item.location{
//                            if let locationame = location.name_str {
//                                self.postDUserplaceLabbel.text = locationame
//            
//                            }
//                        }
        
        
                        if let postimagelist = item?.postimages {
            
                            if postimagelist.count > 0 {
            
                                let apiclient = ApiClient()
                                apiclient.getFireBaseImageUrl(imagepath: postimagelist[postimagelist.count-1].imageurl_str!, completion: { url in
            
                                   self.postDEventImage.image = nil
                                    Manager.shared.loadImage(with: URL(string : url)!, into: self.postDEventImage)
                                })
            
                            }
            
                        }
        
                        if let rating = item?.rating {
                            if rating == 1 {
                                postDLikeImage.image = UIImage(named:"rating1")
                                
                            }else if rating == 2 {
                                postDLikeImage.image = UIImage(named:"rating2")
                            }else if rating == 3 {
                                postDLikeImage.image = UIImage(named:"rating3")
                                
                            }else{
                                
                            }

            
                        }
        
                        if let event = item?.event{
                            if let eventname = event.name  {
                                print("postDEventName is",eventname)
                                self.postDEventName.text = eventname
            
                            }
                        }
        
                        if let business = item?.business{
                            if let businessname = business.businessname  {
                                self.postDEventDishLabel.text = businessname
                            }
                        }
        
                        if let taggeditem = item?.taggedItemName  {
                            self.postDEventPlace.text = taggeditem
                        }
        
                        if let commentname = item?.comment  {
                            self.postDCommentLabel.text = commentname
                        }
    }
    func postDUserImagetap(){
        
        let storyboard = UIStoryboard(name: Constants.PostDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.Profile_LinkViewController) as! ProfileLinkController
        vc.postListDataItems = item
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func profileusernametap(){
        
        let storyboard = UIStoryboard(name: Constants.PostDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.Profile_LinkViewController) as! ProfileLinkController
        vc.postListDataItems = item
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func postitemlabeltap(){

        let storyboard = UIStoryboard(name: Constants.ItemDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.ItemDetailId)
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func userItemTap(){
        
        let storyboard = UIStoryboard(name: Constants.ItemDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.ItemDetailId)
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    
   //business page
    func posteventdishlabeltap(){
        
        let storyboard = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.BusinessCompleteId)
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    //Event tap icon
    func userEventTap(){
        
        let storyboard = UIStoryboard(name: Constants.Event, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.EventStoryId)
        self.navigationController!.pushViewController(vc, animated: true)
    }
    //Event page ..
    func posteventlabeltap(){
        let storyboard = UIStoryboard(name: Constants.Event, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.EventStoryId)
        self.navigationController!.pushViewController(vc, animated: true)
       
    }
    //business tap icon
    func userBusiTap(){
        let storyboard = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.BusinessCompleteId)
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    func imageTapped() {
        
//        self.postDEventImage.image = item.postimages
        let storyboard = UIStoryboard(name: "PostDetail", bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "PostImageZoomViewController") as! PostImageZoomViewController
        vc.imagePassed = postDEventImage.image as! UIImage
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    @IBAction func ButtonBokkMark(_ sender: UIButton) {
        
        openPopup()
    }
    
    }
   

//}


extension PostDetailViewController {
    
    /******************Set navigation bar**************************/
    
    func setNavBar() {
        
        navigationItemList.title = "Post"
        
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
    
    func alertTapRegister(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closePopup(sender:)))
        self.view.addGestureRecognizer(tap)
        
        let bookmarktap = UITapGestureRecognizer(target: self, action: #selector(self.getBookmarkToken(sender:)))
        self.bookmarkpostlabel.addGestureRecognizer(bookmarktap)
        
    }
    
    func closePopup(sender : UITapGestureRecognizer) {
        
        alertViewHide.alpha = 0
        
        UIView.animate(withDuration: 2, animations: {
            
            self.alertviewBottomConstraints.constant = self.view.frame.height + 600
            
            
        }, completion: nil)
        
       
        
    }
    
    func openPopup() {
        
        let Alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let FemaleAction: UIAlertAction = UIAlertAction(title: "Share", style: .default) { _ in
            
            let title = "Numnu"
            let textToShare = "Discover and share experiences with food and drink at events and festivals."
            let urlToShare = NSURL(string: "https://itunes.apple.com/ca/app/numnu/id1231472732?mt=8")
            
            let objectsToShare = [title, textToShare, urlToShare!] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
                activityVC.popoverPresentationController?.sourceView = self.view
                activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
                self.present(activityVC, animated: true, completion:nil )
            }else{
                self.present(activityVC, animated: true, completion:nil )
            }
//            self.present(activityVC, animated: true, completion: nil)

        }
        let MaleAction: UIAlertAction = UIAlertAction(title: "Bookmark", style: .default) { _ in
            
            self.getBookmarkToken()
            
        }
        //        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { _ in
        //        }
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")

        Alert.addAction(FemaleAction)
        Alert.addAction(MaleAction)
        Alert.addAction(cancelAction)
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            Alert.popoverPresentationController?.sourceView = self.view
            Alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
            present(Alert, animated: true, completion:nil )
        }else{
            present(Alert, animated: true, completion:nil )
        }
    }
    
//    func openPopup() {
//
//         alertViewHide.alpha = 1
//
//        UIView.animate(withDuration: 2, animations: {
//
//            self.alertviewBottomConstraints.constant  = 0
//
//
//        }, completion: nil)
//
//
//    }
    
//    func setHeight(heightview : Float){
//        
//        if heightview <= 568 {
//            
////            dishwidthDConstaint.constant   = 75
////            placeWidthDConstraint.constant = 75
//            
//            
//        } else if heightview <= 667 {
//            
////            dishwidthDConstaint.constant   = 99
////            placeWidthDConstraint.constant = 99
//            
//        } else if heightview <= 736 {
//            
//            dishwidthDConstaint.constant   = 117
//            placeWidthDConstraint.constant = 117
//            
//        } else if heightview <= 812 {
//            
//            dishwidthDConstaint.constant   = 99
//            placeWidthDConstraint.constant = 99
//            
//        } else if heightview <= 1024 {
//            
//            dishwidthDConstaint.constant   = 274
//            placeWidthDConstraint.constant = 274
//            
//        } else {
//            
//            dishwidthDConstaint.constant   = 387
//            placeWidthDConstraint.constant = 387
//            
//        }
//        
//        if (postDEventDishLabel.numberOfVisibleLines > 1) {
//            
//            eventTopHeight.constant = 50
//            
//        }
//        
//        if (postDEventPlace.numberOfVisibleLines > 1) {
//            
//            eventTopHeight.constant = 50
//            
//        }
//        
//    }
    
    
    
}

/***************************Bookmark function********************************/

extension PostDetailViewController {
    
    func bookmarkpost(token : String){
        
        let clientIp  = ValidationHelper.Instance.getIPAddress() ?? "1.0.1"
        let userid    = PrefsManager.sharedinstance.userId
        let eventname = "Post name"
        
        LoadingHepler.instance.show()
        
        let header     : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
        let parameters: Parameters = ["entityid": item?.id ?? 0, "entityname":eventname , "type" : "post" ,"createdby" : userid,"updatedby": userid ,"clientip": clientIp, "clientapp": Constants.clientApp]
        apiClient.bookmarEntinty(parameters: parameters,headers: header, completion: { status,response in
            
            if status == "success" {
                
                DispatchQueue.main.async {
                    
                    LoadingHepler.instance.hide()
                    AlertProvider.Instance.showAlert(title: "Hey!", subtitle: "Bookmarked successfully.", vc: self)
                    self.closePopup()
                }
                
            } else {
                
                LoadingHepler.instance.hide()
                if status == "422" {
                    
                    AlertProvider.Instance.showAlert(title: "Hey!", subtitle: "Already bookmarked.", vc: self)
                    
                } else {
                    
                    AlertProvider.Instance.showAlert(title: "Oops!", subtitle: "Bookmark failed.", vc: self)
                    
                }
            }
            
        })
        
    }
    
    func getBookmarkToken(sender : UITapGestureRecognizer){
        
        apiClient.getFireBaseToken(completion:{ token in
            
            
            self.bookmarkpost(token: token)
            
        })
        
    }
    
    func getBookmarkToken() {
        
        apiClient.getFireBaseToken(completion:{ token in
            
            self.bookmarkpost(token: token)
            
        })
        
    }
    
    func closePopup() {
       
        
        alertViewHide.alpha = 0
        
        UIView.animate(withDuration: 2, animations: {
            
            self.alertviewBottomConstraints.constant = self.view.frame.height + 600
            
            
        }, completion: nil)
        
    }
    
    
    
}
