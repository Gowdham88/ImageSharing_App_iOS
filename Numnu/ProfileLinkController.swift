//
//  ProfileLinkController.swift
//  Numnu
//
//  Created by CZ Ltd on 12/27/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import Nuke
import Alamofire

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
    
    /*******************share***************************/
    
    lazy var bookmarkid   : Int       = 0
    lazy var bookmarkname : String    = "name"
    lazy var bookmarktype : String    = "empty"
    
    
    var primaryid       : Int = 51
    var pageno          : Int = 1
    var limitno         : Int = 25
    var viewState       : Bool = false
    var apiClient       : ApiClient!
    
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
        myScrollView.isHidden = true
        
        apiClient = ApiClient()
        /***********************Setuserdetails****************************/
        GetBusinessDetails()
        
        
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
   
    
}

extension ProfileLinkController : Profile_postTableViewCellDelegate {
    
    func bookmarkPost(tag: Int) {
        
        bookmarkid   = postList[tag].id ?? 0
        bookmarkname = postList[tag].business?.businessname ?? "name"
        bookmarktype = "post"
        
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
            
            self.getBookmarkToken()
            
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
    
    func closePopup() {
        
        bookmarkid   = 0
        bookmarkname = "name"
        bookmarktype = "empty"
     
    }
    
}

extension ProfileLinkController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Profile_postTableViewCell
        
        guard postList.count > 0 else {
            
            return cell
        }
        
        cell.item = postList[indexPath.row]
        cell.delegate = self
        cell.postEventBookMark.tag = indexPath.row
        cell.setHeight(heightview : Float(UIScreen.main.bounds.size.height))
        
        let posteventlabeltap = UITapGestureRecognizer(target: self, action: #selector(self.CenterImageTapped(sender:)))
        cell.postEventImage.tag = indexPath.row
        cell.postEventImage.addGestureRecognizer(posteventlabeltap)
        cell.postEventImage.isUserInteractionEnabled = true
        
        let posteventplacetap = UITapGestureRecognizer(target: self, action:#selector(getter: Profile_postTableViewCell.postEventPlace))
        cell.postEventPlace.addGestureRecognizer(posteventplacetap)
        cell.postEventPlace.isUserInteractionEnabled = true
        
        //Item page Icon Tapping
        let posteventplaceIcontap = UITapGestureRecognizer(target: self, action:#selector(getter: Profile_postTableViewCell.postEventPlaceIcon))
        cell.postEventPlaceIcon.addGestureRecognizer(posteventplaceIcontap)
        cell.postEventPlaceIcon.isUserInteractionEnabled = true
        
        let posteventdishtap = UITapGestureRecognizer(target: self, action:#selector(getter: Profile_postTableViewCell.postEventDishLabel))
        cell.postEventDishLabel.addGestureRecognizer(posteventdishtap)
        cell.postEventDishLabel.isUserInteractionEnabled = true
        
        //Icon dish page
        let postEventDishIcontap = UITapGestureRecognizer(target: self, action:#selector(getter: Profile_postTableViewCell.postEventDishIcon))
        cell.postEventDishIcon.addGestureRecognizer(postEventDishIcontap)
        cell.postEventDishIcon.isUserInteractionEnabled = true
        
        let posteventnametap = UITapGestureRecognizer(target: self, action:#selector(getter: Profile_postTableViewCell.postEventName))
        cell.postEventName.addGestureRecognizer(posteventnametap)
        cell.postEventName.isUserInteractionEnabled = true
        
        let postEventNameIcontap = UITapGestureRecognizer(target: self, action:#selector(getter: Profile_postTableViewCell.postEventNameIcon))
        cell.postEventNameIcon.addGestureRecognizer(postEventNameIcontap)
        cell.postEventNameIcon.isUserInteractionEnabled = true
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
    
   
    func CenterImageTapped(sender : UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: Constants.PostDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "postdetailid") as! PostDetailViewController
        vc.item        = postList[sender.view!.tag]
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
    
}

extension ProfileLinkController {
    
    func methodToCallApi(pageno:Int,limit:Int) {
        
        LoadingHepler.instance.show()
        apiClient.getFireBaseToken(completion: { token in
            
            let header : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
            let param  : String      = "page=\(pageno)&limit\(limit)"
            
            self.apiClient.getPostList(id: self.postListDataItems?.postcreator?.id ?? 0, page: param, type: "Users", headers: header, completion: { status,Values in
                
                if status == "success" {
                    
                    LoadingHepler.instance.hide()
                    
                    if let itemlist = Values {
                        
                        self.postModel = itemlist
                        
                        if let list = itemlist.data {
                            
                            self.postList += list
                        }
                        
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.tableView.reloadData()
                        print("APi\(self.postList.count)")
                    }
                    
                    self.reloadTable()
                    
                }else {
                    
                    LoadingHepler.instance.hide()
                    self.reloadTable()
                    
                }
                
            })
            
        })
      
    }
    
    func reloadTable() {
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            self.mainViewConstraint.constant = 186 + self.tableView.contentSize.height
            self.mainViewBottom.constant = 0
            LoadingHepler.instance.hide()
        }
        
    }
    
}

/***************************Bookmark function********************************/

extension ProfileLinkController {
    
    func bookmarkpost(token : String) {
        
        let clientIp  = ValidationHelper.Instance.getIPAddress() ?? "1.0.1"
        let userid    = PrefsManager.sharedinstance.userId
        
        
        LoadingHepler.instance.show()
        
        let header     : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
        let parameters: Parameters = ["entityid": bookmarkid, "entityname":bookmarkname , "type" : "post" ,"createdby" : userid,"updatedby": userid ,"clientip": clientIp, "clientapp": Constants.clientApp]
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
    
    func getBookmarkToken(sender : UITapGestureRecognizer) {
        
        apiClient.getFireBaseToken(completion:{ token in
            
            self.bookmarkpost(token: token)
            
        })
        
    }
    
    func getBookmarkToken() {
        
        apiClient.getFireBaseToken(completion:{ token in
            
            self.bookmarkpost(token: token)
            
        })
        
    }
   
}

extension ProfileLinkController {
    
    func GetBusinessDetails(){
        
        LoadingHepler.instance.show()
       
        apiClient.getFireBaseToken(completion: { token in
       
           let header     : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
            self.apiClient.getBusinessById(id : self.postListDataItems?.business?.id ?? 0,headers: header, completion: { status,Values in
            
            if status == "success" {
                if let response = Values {
                    
                    LoadingHepler.instance.hide()
                    self.methodToCallApi(pageno: self.pageno, limit: self.limitno)
                    
                    DispatchQueue.main.async {
                        
                        self.getDetails(response:response)
                        
                    }
                    
                }
                
            } else {
                print("json respose failure:::::::")
                LoadingHepler.instance.hide()
                self.methodToCallApi(pageno: self.pageno, limit: self.limitno)
                
                DispatchQueue.main.async {
                    
                    self.myScrollView.isHidden = false
                    
                }
                
            }
        })
            
        })
    }
    func getDetails(response:BusinessDetailModel) {
        
        if let name = response.username {
            userNamelabel.text = name
            navigationItemList.title = "@\(name)"
        } else {
            
           collectionTagTop.constant = 0
            
        }
        
        if let description = response.businessdescription {
            descriptionlabel.text = description
        }
        
        
        
        if let taglist = response.taglist {
            if taglist.count > 0 {
                itemArray = taglist
                collectionView.reloadData()
            }
        } else {
            
            collectionTagTop.constant = 0
            collectionTagHeight.constant = 0
        }
        
        
        if let imglist = response.imagelist {
            if imglist.count > 0 {
                if let url = imglist[imglist.count-1].imageurl_str {
                    
                    apiClient.getFireBaseImageUrl(imagepath: url, completion: { imageUrl in
                        
                        if imageUrl != "empty" {
                            
                            Manager.shared.loadImage(with: URL(string : imageUrl)!, into: self.userImage)
                        }
                        
                    })
                    
                    
                }
            }
        }
       
        self.myScrollView.isHidden = false
    }
  
}

