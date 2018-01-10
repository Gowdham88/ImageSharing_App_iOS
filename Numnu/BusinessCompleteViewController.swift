//
//  BusinessCompleteViewController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/31/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Nuke
import Alamofire


class BusinessCompleteViewController: ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var BcImageView: ImageExtender!
    @IBOutlet weak var BcTitleLabel: UILabel!
   
    @IBOutlet weak var myscrollView: UIScrollView!
    
    @IBOutlet weak var BcDescriptionLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    
    
    @IBOutlet weak var TabBarView: ButtonBarView!
    @IBOutlet weak var pagerView: UIScrollView!
    @IBOutlet weak var tagScrollView: UIScrollView!
    
    @IBOutlet weak var navigationItemList: UINavigationItem!
    
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var mainContainerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var mainContainerView: NSLayoutConstraint!
    var tagarray = [String]()
    
    /***************contraints***********************/
    
    @IBOutlet weak var eventDescriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var containerViewTop: NSLayoutConstraint!
    @IBOutlet weak var barButtonTop: NSLayoutConstraint!
    
    /***************Read more variable*********************/
    
    var isLabelAtMaxHeight   = false
    
    var token_str       : String   = "empty"
    var description_txt : String   = ""
    var apiClient       : ApiClient!
    var businessprimaryid : Int    = 0
    
    @IBOutlet weak var bookmarkdetaillabel: UILabel!
    @IBOutlet weak var sharebusdetaillabel: UILabel!
    
    /**********************share********************************/
    
    lazy var bookmarkid   : Int       = 0
    lazy var bookmarkname : String    = "name"
    lazy var bookmarktype : String    = "empty"
    
    /************************constraints************************************/
    
    @IBOutlet weak var tagscrollConstaintTop : NSLayoutConstraint!
    @IBOutlet weak var tagconstraintHeight   : NSLayoutConstraint!
    @IBOutlet weak var descriptionTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
       settings.style.selectedBarHeight = 3.0
       settings.style.buttonBarItemFont = UIFont(name: "Avenir-Medium", size: 14)!
       super.viewDidLoad()
        
        myscrollView.delegate = self
        settings.style.buttonBarBackgroundColor     = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor   = UIColor.appBlackColor()
   
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor     = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset   = 0
        settings.style.buttonBarRightContentInset  = 0
        buttonBarView.selectedBar.backgroundColor  = UIColor.appThemeColor()
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.textlightDark()
            newCell?.label.textColor = UIColor.appBlackColor()
            
        }
        
//        let navigationOnTap = UITapGestureRecognizer(target: self, action: #selector(BusinessCompleteViewController.navigationTap))
//        self.navigationController?.navigationBar.addGestureRecognizer(navigationOnTap)
//        self.navigationController?.navigationBar.isUserInteractionEnabled = true

        
        let centerImagetap = UITapGestureRecognizer(target: self, action: #selector(EventViewController.centerImagetap))
        BcImageView.addGestureRecognizer(centerImagetap)
        BcImageView.isUserInteractionEnabled = true
        /**********************set Nav bar****************************/
        
        setNavBar()
        
        /****************event label tap function************************/
        
        tapRegistration()
        alertTapRegister()
        myscrollView.isHidden = true
        
        apiClient = ApiClient()
        getFirebaseToken()

       

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let navigationOnTap = UITapGestureRecognizer(target:self,action:#selector(EventViewController.navigationTap))
        self.navigationController?.navigationBar.addGestureRecognizer(navigationOnTap)
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    func navigationTap(){
        let offset = CGPoint(x: 0,y :0)
        self.myscrollView.setContentOffset(offset, animated: true)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        reloadStripView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func centerImagetap() {
        
        let storyboard = UIStoryboard(name: "PostDetail", bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "PostImageZoomViewController") as! PostImageZoomViewController
        vc.imagePassed = BcImageView.image!
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_1 = UIStoryboard(name: Constants.EventDetail, bundle: nil).instantiateViewController(withIdentifier: Constants.EventTabid3) as! ReviewEventViewController
        child_1.popdelegate     = self
        child_1.apiType         = "Business"
        child_1.primaryid       = businessprimaryid
        
        let child_2 = UIStoryboard(name: Constants.EventDetail, bundle: nil).instantiateViewController(withIdentifier: Constants.EventTabid2) as! MenuEventViewController
        child_2.menuDelegate    = self
        child_2.itemType        = "Business"
        child_2.primayId        = businessprimaryid
        
        let child_3 = UIStoryboard(name: Constants.ItemDetail, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid7)  as! LocationTabController
        child_3.locationdelegate = self
        child_3.primaryid        = businessprimaryid
        child_3.type             = "Business"
        
        let child_4 = UIStoryboard(name: Constants.Tab, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid1) as! EventTabController
        child_4.scrolltableview = false
        child_4.eventdelegate   = self
        child_4.apiType         = "Business"
        child_4.businessid      = businessprimaryid
        
        return [child_1,child_2,child_3,child_4]
        
    }
    
    @IBAction func ButtonReadMore(_ sender: UIButton) {
        
        if isLabelAtMaxHeight {
            
            readMoreButton.setTitle("more", for: .normal)
            isLabelAtMaxHeight = false
            eventDescriptionHeight.constant = 75
            
            
        } else {
            
            readMoreButton.setTitle("less", for: .normal)
            isLabelAtMaxHeight = true
            eventDescriptionHeight.constant = TextSize.sharedinstance.getLabelHeight(text: description_txt, width: BcDescriptionLabel.frame.width, font: BcDescriptionLabel.font)
            
        }
        
        
    }
    

   

}

extension BusinessCompleteViewController {
    
    /****************event label tap function************************/
    
    func tapRegistration() {
        
//        let link1 = UITapGestureRecognizer(target: self, action: #selector(EventViewController.webLink1(sender:)))
//        EventLinkLabel1.isUserInteractionEnabled = true
//        EventLinkLabel1.addGestureRecognizer(link1)
    
    }
    
    func webLink1(sender:UITapGestureRecognizer) {
        
        
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
    
   
    
    func openStoryBoard () {
        
        let storyboard      = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: Constants.BusinessCompleteId)
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    func alertTapRegister() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closePopup(sender:)))
        self.shareView.addGestureRecognizer(tap)
        
        let bookmarktap = UITapGestureRecognizer(target: self, action: #selector(self.getBookmarkToken(sender:)))
        self.bookmarkdetaillabel.addGestureRecognizer(bookmarktap)
        
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
        bookmarkname = BcTitleLabel.text ?? "Business name"
        bookmarktype = "business"
        
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
            self.present(activityVC, animated: true, completion: nil)

            
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
//
//    }
    
}


/*************Post Delegate****************/

extension BusinessCompleteViewController : ReviewEventViewControllerDelegate {
    
    func popupClick(postid: Int, postname: String) {
        
        openPopup()
        bookmarkid   = postid
        bookmarkname = postname
        bookmarktype = "post"
    }
    
    func postTableHeight(height: CGFloat) {
        
        mainContainerView.constant = (buttonBarView.frame.origin.y+64) + height
        mainContainerViewBottom.constant = 0
    }
    
    
}


/*******************Item delegate****************************/

extension BusinessCompleteViewController : MenuEventViewControllerDelegate {
    
    func menuTableHeight(height: CGFloat) {
        
        mainContainerView.constant = (buttonBarView.frame.origin.y+64) + height
        mainContainerViewBottom.constant = 0
    }
    
}

/************************Event Delegate**********************************************/

extension BusinessCompleteViewController : EventTabControllerDelegate {
    
    func eventTableHeight(height: CGFloat) {
        
        mainContainerView.constant = (buttonBarView.frame.origin.y+64) + height
        mainContainerViewBottom.constant = 0
        
    }
    
    
}

/*******************Location delegate****************************/

extension BusinessCompleteViewController : LocationTabControllerDelegate {
    
    func locationTableHeight(height: CGFloat) {
        
        mainContainerView.constant = (buttonBarView.frame.origin.y+64) + height
        mainContainerViewBottom.constant = 0
    }
    
    
}


extension BusinessCompleteViewController {
    
    func getFirebaseToken() {
        
        apiClient.getFireBaseToken(completion:{ token in
            
            self.token_str = token
            self.MethodToCallApi()
            
        })
        
    }
    func MethodToCallApi(){
        
        LoadingHepler.instance.show()
        
        let header     : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token_str)"]
        
        apiClient.getBusinessById(id : self.businessprimaryid,headers: header, completion: { status,Values in
            
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
            BcTitleLabel.text = name
        } else {
            
            tagscrollConstaintTop.constant = 0
            
        }
        
        if let description = response.businessdescription {
            BcDescriptionLabel.text = description
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
            
            tagscrollConstaintTop.constant = 0
            tagconstraintHeight.constant   = 0
        }
        
       
        if let imglist = response.imagelist {
            if imglist.count > 0 {
                if let url = imglist[imglist.count-1].imageurl_str {
                    
                    apiClient.getFireBaseImageUrl(imagepath: url, completion: { imageUrl in
                        
                        if imageUrl != "empty" {
                            
                            Manager.shared.loadImage(with: URL(string : imageUrl)!, into: self.BcImageView)
                        }
                        
                    })
                    
                    
                }
            }
        }
        
        /****************Checking number of lines************************/
        
        if (BcDescriptionLabel.numberOfVisibleLines > 4) {
            
            readMoreButton.isHidden = false
            
        } else {
            
            readMoreButton.isHidden   = true
            containerViewTop.constant = 8
            barButtonTop.constant     = 8
            if let description = response.businessdescription {
                eventDescriptionHeight.constant = TextSize.sharedinstance.getLabelHeight(text: description, width: BcDescriptionLabel.frame.width, font: BcDescriptionLabel.font)
                description_txt = description
            }
            
            
        }
        
        self.myscrollView.isHidden = false
    }
}

/***************************Bookmark function********************************/

extension BusinessCompleteViewController {
    
    func bookmarkpost(token : String){
        
        LoadingHepler.instance.show()
        
        let clientIp  = ValidationHelper.Instance.getIPAddress() ?? "1.0.1"
        let userid    = PrefsManager.sharedinstance.userId
        let eventname = BcTitleLabel.text ?? "Business name"
        
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
    
    func getBookmarkToken() {
        
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
