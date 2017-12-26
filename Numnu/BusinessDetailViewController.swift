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
    var businessprimaryid : Int  = 50
    

    override func viewDidLoad() {
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarItemFont = UIFont(name: "Avenir-Medium", size: 14)!
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
        let vc              = storyboard.instantiateViewController(withIdentifier: "eventstoryid")
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
        child_1.itemType     = "Business"
        child_1.primayId     = businessprimaryid
        
        let child_2 = UIStoryboard(name: Constants.EventDetail, bundle: nil).instantiateViewController(withIdentifier: Constants.EventTabid3) as! ReviewEventViewController
        child_2.popdelegate = self
        child_2.apiType     = "Business"
        child_2.primaryid   = businessprimaryid
        return [child_1, child_2]
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        reloadStripView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.tabBarController?.tabBar.isHidden = false
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
        button2.addTarget(self, action: #selector(EventViewController.openPopup), for: UIControlEvents.touchUpInside)
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
        completeViewMenu.isUserInteractionEnabled = true
        completeViewMenu.addGestureRecognizer(completemenuTap)
    
    }
    
    func openCompleteMenu(sender:UITapGestureRecognizer) {
        
        openStoryBoard()
        
    }
    
    func openStoryBoard () {
        
        let storyboard      = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: Constants.BusinessCompleteId) as! BusinessCompleteViewController
        vc.businessprimaryid = 50
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    func alertTapRegister() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closePopup(sender:)))
        self.shareView.addGestureRecognizer(tap)
        
    }
    
    func closePopup(sender : UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            
            self.shareView.alpha                 = 0
            
        }, completion: nil)
        
    }
    
    func openPopup() {
        
        self.shareView.alpha   = 1
        
        let top = CGAffineTransform(translationX: 0, y: 0)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            self.shareView.isHidden = false
            self.shareView.transform = top
            
        }, completion: nil)
      
    }
    
}

/*************Post Delegate****************/

extension BusinessDetailViewController : ReviewEventViewControllerDelegate {
    
    func popupClick() {
        
        openPopup()
    }
    
    func postTableHeight(height: CGFloat) {
        
        mainContainerView.constant       = 324 + height
        mainContainerViewBottom.constant = 0
    }
    
    
}


/*******************Item delegate****************************/

extension BusinessDetailViewController : MenuEventViewControllerDelegate {
    
    func menuTableHeight(height: CGFloat) {
        
        mainContainerView.constant       = 324 + height
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
            busTitleLabel.text = name
        }
        
        if let description = response.businessdescription {
            eventDescriptionLabel.text = description
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
            
            if let description = response.businessdescription {
                busDescriptionHeight.constant = TextSize.sharedinstance.getLabelHeight(text: description, width: eventDescriptionLabel.frame.width, font: eventDescriptionLabel.font)
                description_txt = description
            }
            
            
        }
        
        self.myscrollView.isHidden = false
    }
}

