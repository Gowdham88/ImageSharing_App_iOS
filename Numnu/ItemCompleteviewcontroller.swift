//
//  ItemCompleteviewcontroller.swift
//  Numnu
//
//  Created by Suraj B on 11/8/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON
import Alamofire
import Nuke

protocol ItemCompleteviewcontrollerDelegate {
    
    func popupClick()
    func postTableHeight(height : CGFloat)
}
class ItemCompleteviewcontroller : UIViewController {
    var apiClient     : ApiClient!
    var apiType         : String = "Item"
    var popdelegate : ItemCompleteviewcontrollerDelegate?
    var viewState       : Bool = false

    @IBOutlet weak var businessEqualHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var descriptionTopToBusinessname: NSLayoutConstraint!
    @IBOutlet weak var eventnameTopConstraintToBusinessname: NSLayoutConstraint!
    
    @IBOutlet weak var ItImageView: ImageExtender!
    @IBOutlet weak var ItTitleLabel: UILabel!
    var description_txt : String = ""
    
    @IBOutlet weak var myscrollView: UIScrollView!
    
    @IBOutlet weak var ItDescriptionLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet var businessIcon: ImageExtender!
    
    @IBOutlet weak var eventname: UILabel!
    @IBOutlet var eventIcon: ImageExtender!
    
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    @IBOutlet weak var tagScrollView: UIScrollView!
    
    @IBOutlet weak var navigationItemList: UINavigationItem!
    
    @IBOutlet weak var mainContainerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var mainContainerView: NSLayoutConstraint!
    var tagarray = [String]()
    var postList = [PostListDataItems]()
    var postModel  : PostListByEventId?
    
    @IBOutlet weak var shareView: UIView!
    @IBOutlet var completemainview: UIView!
    /***************contraints***********************/
    
    @IBOutlet weak var eventDescriptionHeight : NSLayoutConstraint!
    
    @IBOutlet weak var containerviewtop: NSLayoutConstraint!
    @IBOutlet weak var postTableview: UITableView!
    
    var isLabelAtMaxHeight = false
    
    
    var pageno  : Int = 1
    var limitno : Int = 25
   
    var itemprimaryid   : Int  = 0
    var eventid         : Int  = 0
    
    @IBOutlet weak var shareitemlabel: UILabel!
    @IBOutlet weak var sharebookmarklabel: UILabel!
    
    /*******************share***************************/
    
    lazy var bookmarkid   : Int       = 0
    lazy var bookmarkname : String    = "name"
    lazy var bookmarktype : String    = "empty"
    
    /********************Constraints****************************/
    @IBOutlet weak var titleTopContraints       : UIView!
    @IBOutlet weak var tagscroltopConstraint    : NSLayoutConstraint!
    @IBOutlet weak var descriptionTopConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var itemTitleConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventTitleTop      : NSLayoutConstraint!
    
    @IBOutlet weak var tagscrollviewheightconstraint : NSLayoutConstraint!
    @IBOutlet weak var itemImageHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var itemImageTopConstraint    : NSLayoutConstraint!
    
    @IBOutlet weak var eventImageTopConstraint    : NSLayoutConstraint!
    @IBOutlet weak var eventImageHeightConstraint : NSLayoutConstraint!
    
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        apiClient = ApiClient()
        /**********************set Nav bar****************************/
        
        setNavBar()
        
        /****************event label tap function************************/
        
        tapRegistration()
        alertTapRegister()
        
        self.myscrollView.isHidden = true
        
        let eventtap = UITapGestureRecognizer(target: self, action: #selector(ItemCompleteviewcontroller.eventtap(sender:)))
        eventname.addGestureRecognizer(eventtap)
        eventname.isUserInteractionEnabled = true
        
        let eventIcontap = UITapGestureRecognizer(target: self, action: #selector(ItemCompleteviewcontroller.eventIcontap(sender:)))
        eventIcon.addGestureRecognizer(eventIcontap)
        eventIcon.isUserInteractionEnabled = true
        
        let businesstap = UITapGestureRecognizer(target: self, action: #selector(ItemCompleteviewcontroller.businesstap(sender:)))
        businessName.addGestureRecognizer(businesstap)
        businessName.isUserInteractionEnabled = true
        
        let businessIcontap = UITapGestureRecognizer(target: self, action: #selector(ItemCompleteviewcontroller.businessIcontap(sender:)))
        businessIcon.addGestureRecognizer(businessIcontap)
        businessIcon.isUserInteractionEnabled = true
        
        ItDescriptionLabel.text = Constants.dummy
        
        /****************Checking number of lines************************/
        
        if (ItDescriptionLabel.numberOfVisibleLines > 4) {
            
            readMoreButton.isHidden = false
            
        } else {
            
            readMoreButton.isHidden         = true
            eventDescriptionHeight.constant = TextSize.sharedinstance.getLabelHeight(text: Constants.dummy, width: ItDescriptionLabel.frame.width, font: ItDescriptionLabel.font)
            containerviewtop.constant = 8
        }
        
        postTableview.delegate   = self
        postTableview.dataSource = self
        postTableview.isScrollEnabled = false

       
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.black,
             NSFontAttributeName: UIFont(name: "Avenir-Light", size: 16)!]
        let navigationOnTap = UITapGestureRecognizer(target:self,action:#selector(EventViewController.navigationTap))
        self.navigationController?.navigationBar.addGestureRecognizer(navigationOnTap)
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        viewState = true
        getItemIdApi()
     
    }
    func methodToCallApi(pageno: Int , limit: Int) {
        
        LoadingHepler.instance.show()
        apiClient.getFireBaseToken(completion: { token in
            
            let header     : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
            let param  : String  = "page=\(pageno)&limit\(limit)"
            
            self.apiClient.getPostListByItemEvent(eventId: self.eventid,id: self.itemprimaryid, page: param, type: self.apiType, headers: header, completion: { status,Values in
                
                if status == "success" {
                    
                    if let itemlist = Values {
                        
                        self.postModel = itemlist
                        
                        if let list = itemlist.data {
                            
                            self.postList += list
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.postTableview.reloadData()
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
            self.mainContainerView.constant = 283 + self.postTableview.contentSize.height
            self.mainContainerViewBottom.constant = 0
            LoadingHepler.instance.hide()
        }
    
    }
    
    func eventtap(sender : UITapGestureRecognizer){
        
        let storyboard      = UIStoryboard(name: Constants.Event, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: "eventstoryid") as! EventViewController
        vc.eventprimaryid   = sender.view?.tag ?? 0
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func eventIcontap(sender : UITapGestureRecognizer){
        
        let storyboard      = UIStoryboard(name: Constants.Event, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: "eventstoryid") as! EventViewController
        vc.eventprimaryid   = sender.view?.tag ?? 0
        self.navigationController!.pushViewController(vc, animated: true)
    }
    func businesstap(sender : UITapGestureRecognizer){
        
        let storyboard = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.BusinessCompleteId) as! BusinessCompleteViewController
        vc.businessprimaryid = sender.view?.tag ?? 0
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func businessIcontap(sender : UITapGestureRecognizer){
        
        let storyboard = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.BusinessCompleteId) as! BusinessCompleteViewController
        vc.businessprimaryid = sender.view?.tag ?? 0
        self.navigationController!.pushViewController(vc, animated: true)
    }
    func navigationTap(){
        let offset = CGPoint(x: 0,y :0)
        self.myscrollView.setContentOffset(offset, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        viewState = true

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    @IBAction func ButtonReadMore(_ sender: UIButton) {
        
        if isLabelAtMaxHeight {
            
            readMoreButton.setTitle("more", for: .normal)
            isLabelAtMaxHeight = false
            eventDescriptionHeight.constant = 75
            
        } else {
            
            readMoreButton.setTitle("less", for: .normal)
            isLabelAtMaxHeight = true
            eventDescriptionHeight.constant = TextSize.sharedinstance.getLabelHeight(text: description_txt, width: ItDescriptionLabel.frame.width, font: ItDescriptionLabel.font)
            
        }
      
        
    }
    
    
}

extension ItemCompleteviewcontroller {
    
    /****************event label tap function************************/
    
    func tapRegistration() {
        
        let completemenuTap = UITapGestureRecognizer(target: self, action: #selector(ItemCompleteviewcontroller.openCompleteMenu(sender:)))
        ItImageView.isUserInteractionEnabled = true
        ItImageView.addGestureRecognizer(completemenuTap)
        let completemenuTap1 = UITapGestureRecognizer(target: self, action: #selector(ItemCompleteviewcontroller.openCompleteMenu(sender:)))
        ItTitleLabel.isUserInteractionEnabled = true
        ItTitleLabel.addGestureRecognizer(completemenuTap1)
        
    }
    
    func openCompleteMenu(sender:UITapGestureRecognizer) {
        
        openStoryBoard()
        
    }
    
    
    
    /*************************Tag view updating************************************/
    
    func tagViewUpdate() {
        
        var expandableWidth : CGFloat = 0
        
        for (i,text) in tagarray.enumerated() {
            
            let textLabel : UILabel = UILabel()
            let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: text, fontname: "Avenir-Medium", size: 12)
            textLabel.font = UIFont(name: "Avenir-Medium", size: 12)
            textLabel.text = text
            textLabel.backgroundColor  = UIColor.tagBgColor()
            textLabel.textColor        = UIColor.tagTextColor()
            textLabel.layer.cornerRadius  = 4
            textLabel.layer.masksToBounds = true
            textLabel.textAlignment = .center
            
            if i == 0 {
                
                textLabel.frame = CGRect(x: 0, y: 0, width: textSize.width+20, height: 22)
                
            } else {
                
                textLabel.frame = CGRect(x: expandableWidth, y: 0, width: textSize.width+20, height: 22)
                
            }
            
            expandableWidth += textSize.width+30
            tagScrollView.addSubview(textLabel)
            
        }
        
        tagScrollView.contentSize = CGSize(width: expandableWidth, height: 0)
        tagScrollView.isScrollEnabled = true
        
        
    }
    
    
    
    /******************Set navigation bar**************************/
    
    func setNavBar() {
        
        navigationItemList.title = "Item"
        
        let button: UIButton = UIButton(type: UIButtonType.custom)
        //set image for button
        button.setImage(UIImage(named: "ic_arrow_back"), for: UIControlState.normal)
        //add function for button
        button.addTarget(self, action: #selector(EventViewController.backButtonClicked), for: UIControlEvents.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        
        let button2 : UIButton = UIButton(type: UIButtonType.custom)
        //set image for button
        button2.setImage(UIImage(named: "eventDots"), for: UIControlState.normal)
        //add function for button
        button2.addTarget(self, action: #selector(EventViewController.openSheet), for: UIControlEvents.touchUpInside)
        //set frame
        button2.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(customView: button)
        let rightButton = UIBarButtonItem(customView: button2)
        
        // Create two buttons for the navigation item
        navigationItemList.leftBarButtonItem  = leftButton
        navigationItemList.rightBarButtonItem = rightButton
        
        
    }
    
    func backButtonClicked() {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func openStoryBoard () {
        
        let storyboard = UIStoryboard(name: Constants.ItemDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.ItemDetailId) as! ItemDetailController
        vc.itemprimaryid = itemprimaryid
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    func alertTapRegister(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closePopup(sender:)))
        self.shareView.addGestureRecognizer(tap)
        
        let bookmarktap = UITapGestureRecognizer(target: self, action: #selector(self.getBookmarkToken(sender:)))
        self.sharebookmarklabel.addGestureRecognizer(bookmarktap)
        
    }
    
    func closePopup(sender : UITapGestureRecognizer) {
        
        bookmarkid   = 0
        bookmarkname = "name"
        bookmarktype = "empty"
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            
            self.shareView.alpha                 = 0
            
        }, completion: nil)
        
    }
    
    func openSheet() {
        
        bookmarkid   = itemprimaryid
        bookmarkname = ItTitleLabel.text ?? "Item name"
        bookmarktype = "item"
        
        openPopup()
        
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
    
    func closePopup() {
        
        bookmarkid   = 0
        bookmarkname = "name"
        bookmarktype = "empty"
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            
            self.shareView.alpha                 = 0
            
        }, completion: nil)
        
    }
    
}



extension ItemCompleteviewcontroller : UITableViewDelegate,UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postEventCell", for: indexPath) as! PostEventTableViewCell
        guard postList.count > 0 else {
            
            return cell
        }
        
        cell.item = postList[indexPath.row]
        cell.delegate = self
        cell.postEventBookMark.tag = indexPath.row
//        cell.setHeight(heightview : Float(UIScreen.main.bounds.size.height))
        
        let posteventImagetap = UITapGestureRecognizer(target: self, action: #selector(postEventImage(sender:)))
        cell.postEventImage.tag = indexPath.row
        cell.postEventImage.addGestureRecognizer(posteventImagetap)
        cell.postEventImage.isUserInteractionEnabled = true
        
        let posteventplacetap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postEventPlace))
        cell.postEventPlace.addGestureRecognizer(posteventplacetap)
        cell.postEventPlace.isUserInteractionEnabled = true
        
        let posteventplaceIcontap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postEventPlaceIcon))
        cell.postEventPlaceIcon.addGestureRecognizer(posteventplaceIcontap)
        cell.postEventPlaceIcon.isUserInteractionEnabled = true
        
        
        let posteventdishtap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postEventDishLabel))
        cell.postEventDishLabel.addGestureRecognizer(posteventdishtap)
        cell.postEventDishLabel.isUserInteractionEnabled = true
        
        let posteventdishIcontap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postEventDishIcon))
        cell.postEventDishIcon.addGestureRecognizer(posteventdishIcontap)
        cell.postEventDishIcon.isUserInteractionEnabled = true
        
        let posteventnametap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postEventName))
        cell.postEventName.addGestureRecognizer(posteventnametap)
        cell.postEventName.isUserInteractionEnabled = true
        
        let posteventnameIcontap = UITapGestureRecognizer(target: self, action:#selector(getter: PostEventTableViewCell.postEventNameIcon))
        cell.postEventNameIcon.addGestureRecognizer(posteventnameIcontap)
        cell.postEventNameIcon.isUserInteractionEnabled = true
        
        let profiletap = UITapGestureRecognizer(target: self, action:#selector(self.postDtUserImage(sender:)))
        cell.postUserImage.tag = indexPath.row
        cell.postUserImage.addGestureRecognizer(profiletap)
        cell.postUserImage.isUserInteractionEnabled = true
        
        let profileusernametap = UITapGestureRecognizer(target: self, action:#selector(self.postDtUserImage(sender:)))
        cell.postUsernameLabel.tag = indexPath.row
        cell.postUsernameLabel.addGestureRecognizer(profileusernametap)
        cell.postUsernameLabel.isUserInteractionEnabled = true
        
        let profileusernameplacetap = UITapGestureRecognizer(target: self, action:#selector(self.postDtUserImage(sender:)))
        cell.postUserplaceLabbel.tag = indexPath.row
        cell.postUserplaceLabbel.addGestureRecognizer(profileusernameplacetap)
        cell.postUserplaceLabbel.isUserInteractionEnabled = true
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        openStoryBoard()
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
    
    func postEventImage(sender : UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: Constants.PostDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "postdetailid") as! PostDetailViewController
        vc.item        = postList[sender.view!.tag]
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    func postEventPlace() {
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
    func postDtUserImage(sender: UITapGestureRecognizer){
        let tag        = sender.view!.tag
        let storyboard = UIStoryboard(name: Constants.PostDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.Profile_LinkViewController) as! ProfileLinkController
        vc.postListDataItems  = postList[tag]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func postUsernameLabel(){
        
        let storyboard = UIStoryboard(name: Constants.Main, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "Profile_PostViewController") as! Profile_PostViewController
        vc.boolForBack = false
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
}


/**************custom delegate******************/

extension ItemCompleteviewcontroller : PostEventTableViewCellDelegate {
    
    func bookmarkPost(tag: Int) {
        
        bookmarkid   = postList[tag].id ?? 0
        bookmarkname = postList[tag].business?.businessname ?? "name"
        bookmarktype = "post"
        
       openPopup()
        
    }

}

/***************************Bookmark function********************************/

extension ItemCompleteviewcontroller {
    
    func bookmarkpost(token : String) {
        
        let clientIp  = ValidationHelper.Instance.getIPAddress() ?? "1.0.1"
        let userid    = PrefsManager.sharedinstance.userId
        let eventname = ItTitleLabel.text ?? "Item name"
        
        LoadingHepler.instance.show()
        
        let header     : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
        let parameters: Parameters = ["entityid": itemprimaryid, "entityname":eventname , "type" : "item" ,"createdby" : userid,"updatedby": userid ,"clientip": clientIp, "clientapp": Constants.clientApp]
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

extension ItemCompleteviewcontroller {
    
    func getItemIdApi() {
        
        LoadingHepler.instance.show()
        
        apiClient.getFireBaseToken(completion: { token in
            
            let header : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
            
            self.apiClient.getItemByIdEvent(eventid: self.eventid,id: self.itemprimaryid, headers: header, completion: { status,item in
                
                if status == "success" {
                    
                    LoadingHepler.instance.hide()
                    
                    if let itemlist = item {
                        
                        DispatchQueue.main.async {
                            
                            self.getItemDetails(item: itemlist)
                        }
                        
                        self.postList.removeAll()
                        self.postTableview.reloadData()
                        self.pageno  = 1
                        self.limitno = 25
                        self.methodToCallApi(pageno: self.pageno, limit: self.limitno)
                        
                    }
                    
                    
                } else {
                    
                    LoadingHepler.instance.hide()
                    
                    DispatchQueue.main.async {
                        
                        self.myscrollView.isHidden = true
                    }
                    
                    
                }
                
                
            })
            
            
        })
        
    }
    
    func getItemDetails(item : ItemList) {
    
        
        /****************Name************************/
        
        if let itemname = item.itemname {
            
            ItTitleLabel.text = itemname + " >"
            
        }
        
        if let event = item.eventname {
            
            eventname.tag = item.eventid ?? 0
            eventIcon.tag = item.eventid ?? 0
            
            eventname.text = event
            
            if (eventname.numberOfVisibleLines > 1) {
                
                descriptionTopConstraint.constant = 36
            }
            
            
        } else {
            
            eventname.text = ""
            descriptionTopConstraint.constant = 25
            eventImageHeightConstraint.constant = 0
            
            
        }
        
        if let business = item.businessname {
            
            businessName.text = business
            businessName.tag = item.businessuserid ?? 0
            businessIcon.tag = item.businessuserid ?? 0
            
        } else {
            
            businessName.text = ""
            descriptionTopConstraint.constant = 10
            itemImageTopConstraint.constant    = 0
            itemImageHeightConstraint.constant = 0
//            eventnameTopConstraintToBusinessname.constant = 0
        }
        
        if let itemcurrenyid = item.currencycode,let itemcurrency = item.priceamount {
            
            itemPriceLabel.text = "\(itemcurrenyid) \(itemcurrency)"
            
        }
       
        /****************Imagee************************/
        
        if let imageList = item.itemImageList {
            
            if imageList.count > 0 {
                
                if let url = imageList[imageList.count-1].imageurl {
                    
                    apiClient.getFireBaseImageUrl(imagepath: url, completion: { imageUrl in
                        
                        if imageUrl != "empty" {
                            
                            print(imageUrl)
                            Manager.shared.loadImage(with: URL(string : imageUrl)!, into: self.ItImageView)
                        }
                        
                    })
                
                }
             }
        }
        
        /****************Description************************/
        
        if let itemDes = item.itemdescription {
            
            ItDescriptionLabel.text = itemDes
        }
        
        /****************Checking number of lines************************/
        
        if (ItDescriptionLabel.numberOfVisibleLines > 4) {
            
            readMoreButton.isHidden = false
            
        } else {
            
            readMoreButton.isHidden         = true
            if let description = item.description {
                eventDescriptionHeight.constant = TextSize.sharedinstance.getLabelHeight(text: description, width: ItDescriptionLabel.frame.width, font: ItDescriptionLabel.font)
                description_txt = description
            }
            
            containerviewtop.constant = 8
        }
        
        /****************Tags************************/
        
        if let itemTag = item.tagList {
            
            if itemTag.count > 0 {
                
                tagarray.removeAll()
                
                for tag in itemTag {
                    
                    tagarray.append(tag.text_str ?? "")
                    
                }
                
                tagViewUpdate()
                
            }
            
        } else {
            
            descriptionTopConstraint.constant      = 25
            tagscrollviewheightconstraint.constant = 0
            tagscroltopConstraint.constant         = 0
         
        }
        
        self.myscrollView.isHidden = false
    
    }
    
    
}


