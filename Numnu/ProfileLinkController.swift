//
//  ProfileLinkController.swift
//  Numnu
//
//  Created by CZ Ltd on 12/27/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import Nuke

class ProfileLinkController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var navigationItemList: UINavigationItem!
    @IBOutlet weak var myScrollView: UIScrollView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionlabel: UILabel!
    @IBOutlet weak var userNamelabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mainViewBottom: NSLayoutConstraint!
    @IBOutlet weak var mainViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var shareview: UIView!
    
    var postListDataItems : PostListDataItems?
    
    @IBOutlet weak var EventverticalConstraint: NSLayoutConstraint!
    var itemArray = [TagList]()
    var delegate : Profile_PostViewControllerDelegae?
    
    /*********************constarints********************************/
    
    @IBOutlet weak var collectionTagTop: NSLayoutConstraint!
    @IBOutlet weak var collectionTagHeight: NSLayoutConstraint!
    @IBOutlet weak var addresslabelTop: NSLayoutConstraint!
    
    
    var primaryid       : Int = 149
    var pageno          : Int = 1
    var limitno         : Int = 25
    
    var postList = [PostListDataItems]()
    var postModel  : PostListByEventId?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setNavBar()
        LoadingHepler.instance.hide()
        myScrollView.delegate = self
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.black,
             NSFontAttributeName: UIFont(name: "Avenir-Light", size: 16)!]
        userImage.layer.cornerRadius = self.userImage.frame.size.height/2
        userImage.contentMode = .scaleAspectFill
        userImage.clipsToBounds = true
        alertTapRegister()
        
        /***********************Setuserdetails****************************/
        setUserDetails()
        
        
    }
    func navigationTap() {
        let offset = CGPoint(x: 0,y :0)
        self.myScrollView.setContentOffset(offset, animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        let navigationOnTap = UITapGestureRecognizer(target:self,action:#selector(EventViewController.navigationTap))
        self.navigationController?.navigationBar.addGestureRecognizer(navigationOnTap)
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        /***********************Setuserdetails****************************/
        setUserDetails()
    }
    
    func setNavBar() {
        
        
        
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "ic_arrow_back"), for: UIControlState.normal)
        //add function for button
        button.addTarget(self, action: #selector(EventViewController.backButtonClicked), for: UIControlEvents.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        
        // Right bar button //
        
        let button2: UIButton = UIButton(type: UIButtonType.custom)
        //set image for button
        button2.setImage(UIImage(named: ""), for: UIControlState.normal)
        //add function for button
        button2.addTarget(self, action: #selector(settingsClicked), for: UIControlEvents.touchUpInside)
        //set frame
        button2.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        
        // Create left and right button for navigation item
        
        let leftButton =  UIBarButtonItem(customView:button)
        leftButton.isEnabled = true
        
        //        let rightButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        let rightButton = UIBarButtonItem(customView:button2)
        rightButton.isEnabled = true
        
        // Create two buttons for the navigation item
        navigationItemList.leftBarButtonItem = leftButton
        navigationItemList.rightBarButtonItem = rightButton
        
        
    }
    
    func backButtonClicked() {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func settingsClicked() {
        
        
    }
    
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //        self.navigationController?.setNavigationBarHidden(false, animated: true)
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // collectionview cell //
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ccell", for: indexPath as IndexPath) as! UserProfileTagCollectionViewCell
        
        if let tagName = itemArray[indexPath.row].text_str {
            
            let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: tagName, fontname: "Avenir-Book", size: 13)
            cell.tagLabel.text = tagName
            cell.setLabelSize(size: textSize)
            
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let tagName = itemArray[indexPath.row].text_str {
            
            let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: tagName, fontname: "Avenir-Book", size: 13)
            
            return CGSize(width: textSize.width+20, height: 22)
            
        } else {
            
            return CGSize(width: 0, height: 22)
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    /***********************Setuserdetails****************************/
    
    func setUserDetails(){
        
        if let item = postListDataItems {
            
            if let postitem = item.postcreator {
                
                if let name = postitem.name {
                    
                    userNamelabel.text = name
                    navigationItemList.title = "@\(name)"
                } else {
                    
                  collectionTagTop.constant = 0
                   
                }
                
                if let images = postitem.userimages {
                    
                    if images.count > 0 {
                        
                        let apiclient : ApiClient = ApiClient()
                        apiclient.getFireBaseImageUrl(imagepath: images[0].imageurl_str ?? "empty", completion: { url in
                            
                            if url != "empty" {
                                
                                Manager.shared.loadImage(with:URL(string:url)!, into: self.userImage)
                                
                            }
                            
                            
                        })
                    }
                    
                    
                }
                
            }
            
            if let locitem = item.location {
                
                if let locname = locitem.name_str {
                    
                    addressLabel.text = "\(locname)\(locitem.address_str ?? "")"
                }
                
            }
            
            if let tags = item.tags {
                
                itemArray  = tags
                
            } else {
                
                collectionTagTop.constant = 0
                collectionTagHeight.constant = 0
            }
                
           
        }
    
//        descriptionlabel.text = PrefsManager.sharedinstance.description
        
        
        collectionView.reloadData()
        
        
        
    }
    
}

extension ProfileLinkController : Profile_postTableViewCellDelegate {
    
    func popup() {
        
        openPopup()
        
    }
    
    func alertTapRegister() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closePopup(sender:)))
        self.shareview.addGestureRecognizer(tap)
        
    }
    
    func closePopup(sender : UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            
            self.shareview.alpha  = 0
            
        }, completion: nil)
        
    }
    
    func openPopup() {
        
        let Alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let FemaleAction = UIAlertAction(title: "Share", style: UIAlertActionStyle.default) { _ in
            
            
        }
        let MaleAction = UIAlertAction(title: "Bookmark", style: UIAlertActionStyle.default) { _ in
            
            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { _ in
        }
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
//        self.shareview.alpha   = 1
//
//        let top = CGAffineTransform(translationX: 0, y: 0)
//
//        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
//
//            self.shareview.isHidden  = false
//            self.shareview.transform = top
//
//        }, completion: nil)
//
//    }
    
    func menuTableHeight(height: CGFloat) {
        
        mainViewConstraint.constant = 186 + height
        mainViewBottom.constant = 0
    }
}

//extension ProfileLinkController : UITableViewDelegate,UITableViewDataSource {
//    
//    
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return postList.count
//        
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "postEventCell", for: indexPath) as! PostEventTableViewCell
//        guard postList.count > 0 else {
//            
//            return cell
//        }
//        
//        cell.item = postList[indexPath.row]
//        cell.delegate = self
//        cell.postEventBookMark.tag = indexPath.row
//        cell.setHeight(heightview : Float(UIScreen.main.bounds.size.height))
//        
//        let posteventImagetap = UITapGestureRecognizer(target: self, action: #selector(postEventImage(sender:)))
//        cell.postEventImage.tag = indexPath.row
//        cell.postEventImage.addGestureRecognizer(posteventImagetap)
//        cell.postEventImage.isUserInteractionEnabled = true
//        
//        let posteventplacetap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postEventPlace))
//        cell.postEventPlace.addGestureRecognizer(posteventplacetap)
//        cell.postEventPlace.isUserInteractionEnabled = true
//        
//        let posteventplaceIcontap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postEventPlaceIcon))
//        cell.postEventPlaceIcon.addGestureRecognizer(posteventplaceIcontap)
//        cell.postEventPlaceIcon.isUserInteractionEnabled = true
//        
//        
//        let posteventdishtap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postEventDishLabel))
//        cell.postEventDishLabel.addGestureRecognizer(posteventdishtap)
//        cell.postEventDishLabel.isUserInteractionEnabled = true
//        
//        let posteventdishIcontap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postEventDishIcon))
//        cell.postEventDishIcon.addGestureRecognizer(posteventdishIcontap)
//        cell.postEventDishIcon.isUserInteractionEnabled = true
//        
//        let posteventnametap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postEventName))
//        cell.postEventName.addGestureRecognizer(posteventnametap)
//        cell.postEventName.isUserInteractionEnabled = true
//        
//        let posteventnameIcontap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postEventNameIcon))
//        cell.postEventNameIcon.addGestureRecognizer(posteventnameIcontap)
//        cell.postEventNameIcon.isUserInteractionEnabled = true
//        
//        let profiletap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postUserImage))
//        cell.postUserImage.addGestureRecognizer(profiletap)
//        cell.postUserImage.isUserInteractionEnabled = true
//        
//        let profileusernametap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postUsernameLabel))
//        cell.postUsernameLabel.addGestureRecognizer(profileusernametap)
//        cell.postUsernameLabel.isUserInteractionEnabled = true
//        
//        
//        return cell
//        
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//       
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        if TextSize.sharedinstance.getNumberoflines(text: Constants.dummy, width: tableView.frame.width, font: UIFont(name: "Avenir-Book", size: 16)!) > 1 {
//            
//            return 428
//            
//        } else {
//            
//            return 402
//        }
//        
//    }
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        
//        if indexPath.row == postList.count - 1 && viewState {
//            
//            if let pageItem = postModel {
//                
//                if postList.count  < pageItem.totalRows ?? 0 {
//                    pageno += 1
//                    limitno = 25 * pageno
//                    methodToCallApi(pageno: pageno, limit: limitno)
//                }
//                
//            }
//            
//        }
//    }
//    
//    func postEventImage(sender : UITapGestureRecognizer) {
//        let storyboard = UIStoryboard(name: Constants.PostDetail, bundle: nil)
//        let vc         = storyboard.instantiateViewController(withIdentifier: "postdetailid") as! PostDetailViewController
//        vc.item        = postList[sender.view!.tag]
//        self.navigationController!.pushViewController(vc, animated: true)
//        
//    }
//    func postEventPlace() {
//        let storyboard = UIStoryboard(name: Constants.ItemDetail, bundle: nil)
//        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.ItemDetailId)
//        self.navigationController!.pushViewController(vc, animated: true)
//        
//    }
//    func postEventPlaceIcon(){
//        let storyboard = UIStoryboard(name: Constants.ItemDetail, bundle: nil)
//        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.ItemDetailId)
//        self.navigationController!.pushViewController(vc, animated: true)
//    }
//    func postEventDishLabel(){
//        let storyboard = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
//        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.BusinessCompleteId)
//        self.navigationController!.pushViewController(vc, animated: true)
//    }
//    
//    func postEventDishIcon(){
//        let storyboard = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
//        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.BusinessCompleteId)
//        self.navigationController!.pushViewController(vc, animated: true)
//    }
//    func postEventName(){
//        
//        let storyboard = UIStoryboard(name: Constants.Event, bundle: nil)
//        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.EventStoryId)
//        self.navigationController!.pushViewController(vc, animated: true)
//    }
//    func postEventNameIcon(){
//        
//        let storyboard = UIStoryboard(name: Constants.Event, bundle: nil)
//        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.EventStoryId)
//        self.navigationController!.pushViewController(vc, animated: true)
//    }
//    func postUserImage(){
//        let storyboard = UIStoryboard(name: Constants.Main, bundle: nil)
//        let vc         = storyboard.instantiateViewController(withIdentifier: "Profile_PostViewController") as! Profile_PostViewController
//        vc.boolForBack = false
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    func postUsernameLabel(){
//        
//        let storyboard = UIStoryboard(name: Constants.Main, bundle: nil)
//        let vc         = storyboard.instantiateViewController(withIdentifier: "Profile_PostViewController") as! Profile_PostViewController
//        vc.boolForBack = false
//        self.navigationController!.pushViewController(vc, animated: true)
//    }
//    
//}



