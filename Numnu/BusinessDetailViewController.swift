//
//  BusinessDetailViewController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/30/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Nuke
import Alamofire



class BusinessDetailViewController: ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var busImageView: ImageExtender!
    @IBOutlet weak var busTitleLabel: UILabel!
    @IBOutlet weak var buseventLabel: UILabel!
    @IBOutlet var buseventIcon: ImageExtender!
    
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    
    
    @IBOutlet weak var TabBarView: ButtonBarView!
    @IBOutlet weak var pagerView: UIScrollView!
    @IBOutlet weak var tagScrollView: UIScrollView!
    
    @IBOutlet weak var navigationItemList: UINavigationItem!
    
    @IBOutlet weak var mainContainerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var mainContainerView: NSLayoutConstraint!
    
    var tagarray = [String]()
    
    /***************contraints***********************/
    
    @IBOutlet weak var myscrollView: UIScrollView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var busDescriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var containerViewTop: NSLayoutConstraint!
    @IBOutlet weak var barButtonTop: NSLayoutConstraint!
    
    @IBOutlet weak var completeViewMenu: UIView!
    /***************Read more variable*********************/
    
    var isLabelAtMaxHeight = false
    
    var token_str     : String = "empty"
    var apiClient     : ApiClient!
    var description_txt : String = ""
    var businessprimaryid : Int  = 0
    var eventid : Int  = 0

//    var eventid           : Int  = 34
    
    @IBOutlet weak var bookmarkbusinesslabel: UILabel!
    @IBOutlet weak var sharebusinesslabel: UILabel!
    
    /**********************share********************************/
    
    lazy var bookmarkid   : Int       = 0
    lazy var bookmarkname : String    = "name"
    lazy var bookmarktype : String    = "empty"
    
    /***********************constraints************************************/
    
    @IBOutlet weak var TagscrollviewTop: NSLayoutConstraint!
    @IBOutlet weak var tagscrollviewheight: NSLayoutConstraint!
    
    @IBOutlet weak var descriptionTop: NSLayoutConstraint!
    @IBOutlet weak var eventImageHeight: NSLayoutConstraint!
    @IBOutlet weak var eventTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarItemFont = UIFont(name: "Avenir-Medium", size: 14)!
        settings.style.viewcontrollersCount = 2
        super.viewDidLoad()
        self.myscrollView.delegate = self

        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = UIColor.appBlackColor()
        
       
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        buttonBarView.selectedBar.backgroundColor = UIColor.appThemeColor()
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.textlightDark()
            newCell?.label.textColor = UIColor.appBlackColor()
            
        }
        let businesstap = UITapGestureRecognizer(target: self, action: #selector(BusinessDetailViewController.businesstap))
        buseventLabel.addGestureRecognizer(businesstap)
        buseventLabel.isUserInteractionEnabled = true
        
        let businessIcontap = UITapGestureRecognizer(target: self, action: #selector(BusinessDetailViewController.businesstap))
        buseventIcon.addGestureRecognizer(businessIcontap)
        buseventIcon.isUserInteractionEnabled = true
        
        
        /**********************set Nav bar****************************/
        
        setNavBar()
      

        
        /**********************Tap registration****************************/
        
        tapRegistration()
        alertTapRegister()
        myscrollView.isHidden = true
        
        apiClient = ApiClient()
        getFirebaseToken()
        
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let navigationOnTap = UITapGestureRecognizer(target:self,action:#selector(EventViewController.navigationTap))
        self.navigationController?.navigationBar.addGestureRecognizer(navigationOnTap)
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    func businesstap(){
     
        let storyboard      = UIStoryboard(name: Constants.Event, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: "eventstoryid") as! EventViewController
        vc.eventprimaryid   = eventid
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func businessIcontap(){
        
        let storyboard      = UIStoryboard(name: Constants.Event, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: "eventstoryid") as! EventViewController
        vc.eventprimaryid   = eventid
        self.navigationController!.pushViewController(vc, animated: true)
    }
    func navigationTap(){
        let offset = CGPoint(x: 0,y :0)
        self.myscrollView.setContentOffset(offset, animated: true)
        
    }
    @IBAction func ButtonReadMore(_ sender: UIButton) {
        
        if isLabelAtMaxHeight {
            
            readMoreButton.setTitle("more", for: .normal)
            isLabelAtMaxHeight = false
            busDescriptionHeight.constant = 75
            
            
        } else {
            
            readMoreButton.setTitle("less", for: .normal)
            isLabelAtMaxHeight = true
            busDescriptionHeight.constant   = TextSize.sharedinstance.getLabelHeight(text: description_txt, width: eventDescriptionLabel.frame.width, font: eventDescriptionLabel.font)
            
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_1 = UIStoryboard(name: Constants.EventDetail, bundle: nil).instantiateViewController(withIdentifier: Constants.EventTabid2) as! MenuEventViewController
        child_1.menuDelegate = self
        child_1.itemType     = "BusinessEvent"
        child_1.primayId     = businessprimaryid
        child_1.eventId      = eventid
        
        let child_2 = UIStoryboard(name: Constants.EventDetail, bundle: nil).instantiateViewController(withIdentifier: Constants.EventTabid3) as! ReviewEventViewController
        child_2.popdelegate = self
        child_2.apiType     = "BusinessEvent"
        child_2.primaryid   = businessprimaryid
        child_2.eventId     = eventid
        return [child_1, child_2]
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.tabBarController?.tabBar.isHidden = false
        reloadStripView()
    }
    
}

extension BusinessDetailViewController {
    
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
            textLabel.layer.cornerRadius = 4
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
        
        navigationItemList.title = "Business"
        
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
   
    func openMapBoard () {
        
        let storyboard      = UIStoryboard(name: Constants.Event, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: Constants.MapStoryId) as! EventMapViewController
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
}

extension BusinessDetailViewController {
    
    
    /****************event label tap function************************/
    
    func tapRegistration() {
        
        let completemenuTap = UITapGestureRecognizer(target: self, action: #selector(BusinessDetailViewController.openCompleteMenu(sender:)))
        busImageView.isUserInteractionEnabled = true
        busImageView.addGestureRecognizer(completemenuTap)
        let completemenuTap1 = UITapGestureRecognizer(target: self, action: #selector(BusinessDetailViewController.openCompleteMenu(sender:)))
        busTitleLabel.isUserInteractionEnabled = true
        busTitleLabel.addGestureRecognizer(completemenuTap1)
    
    }
    
    func openCompleteMenu(sender:UITapGestureRecognizer) {
        
        openStoryBoard()
        
    }
    
    func openStoryBoard () {
        
        let storyboard      = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: Constants.BusinessCompleteId) as! BusinessCompleteViewController
        vc.businessprimaryid = businessprimaryid
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    func alertTapRegister() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closePopup(sender:)))
        self.shareView.addGestureRecognizer(tap)
        
        let bookmarktap = UITapGestureRecognizer(target: self, action: #selector(self.getBookmarkToken(sender:)))
        self.bookmarkbusinesslabel.addGestureRecognizer(bookmarktap)
        
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
        
        bookmarkid   = businessprimaryid
        bookmarkname = busTitleLabel.text ?? "Business name"
        bookmarktype = "business"
        
        openPopup()
        
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
//        self.shareView.alpha   = 1
//
//        let top = CGAffineTransform(translationX: 0, y: 0)
//
//        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
//            self.shareView.isHidden = false
//            self.shareView.transform = top
//
//        }, completion: nil)
//
//    }
    
}

/*************Post Delegate****************/

extension BusinessDetailViewController : ReviewEventViewControllerDelegate {
    
    func popupClick(postid: Int, postname: String) {
        
        bookmarkid   = postid
        bookmarkname = postname
        bookmarktype = "post"
        
        openPopup()
       
    }
    
    func postTableHeight(height: CGFloat) {
        
        mainContainerView.constant       = 274 + height
        mainContainerViewBottom.constant = 0
    }
    
    
}


/*******************Item delegate****************************/

extension BusinessDetailViewController : MenuEventViewControllerDelegate {
    
    func menuTableHeight(height: CGFloat) {
        
        mainContainerView.constant       = 274 + height
        mainContainerViewBottom.constant = 0
    }
    
}

extension BusinessDetailViewController {
    
    func getFirebaseToken() {
        
        apiClient.getFireBaseToken(completion:{ token in
            
            self.token_str = token
            self.MethodToCallApi()
            
        })
        
    }
    func MethodToCallApi(){
      
       LoadingHepler.instance.show()
        
        let header     : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token_str)"]
        
        apiClient.getBusinessByIdEvent(eventid: eventid,businessid:  self.businessprimaryid,headers: header, completion: { status,Values in
            
            if status == "success" {
                if let response = Values {
                    
                   LoadingHepler.instance.hide()
                    
                    DispatchQueue.main.async {
                        
                        self.getDetails(response:response)
                        
                    }
                    
                }
                
            } else {
                print("json respose failure:::::::")
                LoadingHepler.instance.hide()
                DispatchQueue.main.async {
                    
                    self.myscrollView.isHidden = true
                    
                }
                
            }
        })
    }
    func getDetails(response:BusinessDetailModel) {
          
        if let name = response.businessname {
            busTitleLabel.text = name
            
        } else {
            
            TagscrollviewTop.constant = 0
            descriptionTop.constant  = 4
        }
        
        if let description = response.businessdescription {
            eventDescriptionLabel.text = description
        }
        if let busevent = response.eventlist {
            if let buseventName = busevent.name {
                buseventLabel.text = buseventName
                
                if buseventLabel.numberOfVisibleLines > 1 {
                    
                    descriptionTop.constant = 15
                }
                
            }
        }
        
        
        if let taglist = response.taglist {
            if taglist.count > 0 {
                for item in taglist {
                    if let tagname = item.text_str {
                        tagarray.append(tagname)
                    }
                }
                tagViewUpdate()
            }
        } else {
            
            descriptionTop.constant  = 4
            TagscrollviewTop.constant = 0
            tagscrollviewheight.constant = 0
            
        }
        
        
        if let imglist = response.imagelist {
            if imglist.count > 0 {
                if let url = imglist[imglist.count-1].imageurl_str {
                    
                    apiClient.getFireBaseImageUrl(imagepath: url, completion: { imageUrl in
                        
                        if imageUrl != "empty" {
                            
                            Manager.shared.loadImage(with: URL(string : imageUrl)!, into: self.busImageView)
                        }
                        
                    })
                    
                    
                }
            }
        }
        
        /****************Checking number of lines************************/
        
        if (eventDescriptionLabel.numberOfVisibleLines > 4) {
            
            readMoreButton.isHidden = false
            
        } else {
            
            readMoreButton.isHidden   = true
            containerViewTop.constant = 8
            barButtonTop.constant     = 8
            
            if let description = response.businessdescription {
                busDescriptionHeight.constant = TextSize.sharedinstance.getLabelHeight(text: description, width: eventDescriptionLabel.frame.width, font: eventDescriptionLabel.font)
                description_txt = description
            }
            
            
        }
        
        self.myscrollView.isHidden = false
    }
}

/***************************Bookmark function********************************/

extension BusinessDetailViewController {
    
    func bookmarkpost(token : String){
        
        LoadingHepler.instance.show()
        
        let clientIp  = ValidationHelper.Instance.getIPAddress() ?? "1.0.1"
        let userid    = PrefsManager.sharedinstance.userId
        let eventname = busTitleLabel.text ?? "Business name"
        
        let header     : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
        let parameters: Parameters = ["entityid": businessprimaryid, "entityname":eventname , "type" : "business" ,"createdby" : userid,"updatedby": userid ,"clientip": clientIp, "clientapp": Constants.clientApp]
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
    
    func getBookmarkToken(){
        
        apiClient.getFireBaseToken(completion:{ token in
            
            
            self.bookmarkpost(token: token)
            
        })
        
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

