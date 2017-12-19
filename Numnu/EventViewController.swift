//
//  EventViewController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/16/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import SwiftyJSON
import PKHUD
import Nuke

struct MyVariables {
    
    static var fetchedLat  = String()
    static var fetchedLong = String()
    static var markerTitle = String()
    static var link1 = String()
    static var link2 = String()
    
}
class EventViewController: ButtonBarPagerTabStripViewController {
    var token_str     : String = "empty"
    var apiClient     : ApiClient!
    let textLabel : UILabel = UILabel()
    var description_txt : String = ""

    @IBOutlet weak var myscrollView: UIScrollView!
    @IBOutlet weak var eventImageView: ImageExtender!
    @IBOutlet weak var eventTitleLabel: UILabel!
    
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventPlaceLabel: UILabel!
    @IBOutlet weak var eventMap: UILabel!
    
    
    @IBOutlet weak var EventLinkLabel1: UILabel!
    @IBOutlet weak var eventLinkLabel2: UILabel!
    @IBOutlet weak var eventLinkLabel3: UILabel!
    
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    
    
    @IBOutlet weak var TabBarView: ButtonBarView!
    @IBOutlet weak var pagerView: UIScrollView!
    @IBOutlet weak var tagScrollView: UIScrollView!
    
    @IBOutlet weak var navigationItemList: UINavigationItem!
    
    @IBOutlet weak var mainContainerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var mainContainerView: NSLayoutConstraint!
    var tagarray = [String]()
    @IBOutlet weak var shareView: UIView!
    /***************contraints***********************/
    
    @IBOutlet weak var eventDescriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var containerViewTop: NSLayoutConstraint!
    @IBOutlet weak var barButtonTop: NSLayoutConstraint!
    
    /***************Read more variable*********************/
    
    var isLabelAtMaxHeight = false
    var contentHeignt      = 649
    
    override func viewDidLoad() {
        settings.style.selectedBarHeight = 3.0
         settings.style.buttonBarItemFont = UIFont(name: "Avenir-Medium", size: 14)!
        super.viewDidLoad()
        myscrollView.delegate = self
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = UIColor.appBlackColor()
        
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarHeight = 1
        buttonBarView.selectedBar.backgroundColor = UIColor.appThemeColor()
        buttonBarView.moveTo(index: 0, animated: true, swipeDirection: .none, pagerScroll: .yes)
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.textlightDark()
            newCell?.label.textColor = UIColor.appBlackColor()
         
          
            
        }

        let centerImagetap = UITapGestureRecognizer(target: self, action: #selector(EventViewController.centerImagetap))
        eventImageView.addGestureRecognizer(centerImagetap)
        eventImageView.isUserInteractionEnabled = true
    
        /**********************set Nav bar****************************/
        
        setNavBar()
        alertTapRegister()

        /****************event label tap function************************/
        
        tapRegistration()
        myscrollView.isHidden = true
        
        apiClient = ApiClient()
        
        getFirebaseToken()
   
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
    func centerImagetap(){
        
        let storyboard = UIStoryboard(name: "PostDetail", bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "PostImageZoomViewController") as! PostImageZoomViewController
        vc.imagePassed = eventImageView.image!
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_1 = UIStoryboard(name: Constants.EventDetail, bundle: nil).instantiateViewController(withIdentifier: Constants.EventTabid1) as! BusinessEventViewController
        child_1.showentity      = true
        child_1.businesdelegate = self
        
        let child_2 = UIStoryboard(name: Constants.EventDetail, bundle: nil).instantiateViewController(withIdentifier: Constants.EventTabid2) as! MenuEventViewController
        child_2.showentity   = true
        child_2.menuDelegate = self
        child_2.itemType     = "Event"
        
        let child_3 = UIStoryboard(name: Constants.EventDetail, bundle: nil).instantiateViewController(withIdentifier: Constants.EventTabid3) as! ReviewEventViewController
        child_3.popdelegate = self
        return [child_1,child_2,child_3]
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        reloadStripView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.tabBarController?.tabBar.isHidden = false
        
       
    }
    

    @IBAction func ButtonReadMore(_ sender: UIButton) {
        
        if isLabelAtMaxHeight {
            
            readMoreButton.setTitle("more", for: .normal)
            isLabelAtMaxHeight = false
            eventDescriptionHeight.constant = 75
            
            
        } else {
            
            readMoreButton.setTitle("less", for: .normal)
            isLabelAtMaxHeight = true
            eventDescriptionHeight.constant = TextSize.sharedinstance.getLabelHeight(text: description_txt, width: eventDescriptionLabel.frame.width, font: eventDescriptionLabel.font)
           
        }
        
        
    }
    

}

extension EventViewController {
    
    /****************event label tap function************************/
    
    func tapRegistration() {
        
        let link1 = UITapGestureRecognizer(target: self, action: #selector(EventViewController.webLink1(sender:)))
        EventLinkLabel1.isUserInteractionEnabled = true
        EventLinkLabel1.addGestureRecognizer(link1)
        
        let link2 = UITapGestureRecognizer(target: self, action: #selector(EventViewController.webLink2(sender:)))
        eventLinkLabel2.isUserInteractionEnabled = true
        eventLinkLabel2.addGestureRecognizer(link2)
        
        let link3 = UITapGestureRecognizer(target: self, action: #selector(EventViewController.webLink1(sender:)))
        eventLinkLabel3.isUserInteractionEnabled = true
        eventLinkLabel3.addGestureRecognizer(link3)
        
        let maptap = UITapGestureRecognizer(target: self, action: #selector(EventViewController.mapRedirect(sender:)))
        eventMap.isUserInteractionEnabled = true
        eventMap.addGestureRecognizer(maptap)
        
    }
    
    func webLink1(sender:UITapGestureRecognizer) {
    
        openWebBoard(url: MyVariables.link1)

    }
    
    func webLink2(sender:UITapGestureRecognizer) {
        
        openWebBoard(url: MyVariables.link2)
        
    }
    
    func webLink3(sender:UITapGestureRecognizer) {
        
        openWebBoard(url: "http://www.totc.ca")
        
    }
    
    func mapRedirect(sender:UITapGestureRecognizer) {
        
        openMapBoard()
    }
    
    /*************************Tag view updating************************************/
    
    func tagViewUpdate() {
        
        var expandableWidth : CGFloat = 0
        
        for (i,text) in tagarray.enumerated() {
            
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

        navigationItemList.title = "Event"
        
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
    
    func openWebBoard (url: String) {
      
        let storyboard      = UIStoryboard(name: Constants.Event, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: Constants.WebViewStoryId) as! WebViewController
        vc.url_str          = url
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    func openMapBoard () {
        
        let storyboard      = UIStoryboard(name: Constants.Event, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: Constants.MapStoryId) as! EventMapViewController

        
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

extension EventViewController : ReviewEventViewControllerDelegate {
    
    func popupClick() {
        
        openPopup()
    }
    
    func postTableHeight(height: CGFloat) {
     
        mainContainerView.constant = 532 + height
        mainContainerViewBottom.constant = 0
    }
    
   
}


/*******************Business delegate****************************/

extension EventViewController : BusinessEventViewControllerDelegate {
    
    func BusinessTableHeight(height: CGFloat) {
        
        mainContainerView.constant = 532 + height
        mainContainerViewBottom.constant = 0
    }
    
    
}

extension EventViewController : MenuEventViewControllerDelegate {
    
    func menuTableHeight(height: CGFloat) {
        
        mainContainerView.constant = 532 + height
        mainContainerViewBottom.constant = 0
    }
    
}

extension EventViewController {
    
    func getFirebaseToken() {
        
        apiClient.getFireBaseToken(completion:{ token in
            
            self.token_str = token
            self.MethodToCallApi()
            
        })
        
    }
    func MethodToCallApi(){
        
        HUD.show(.labeledProgress(title: "Loading", subtitle: ""))
        
        let header     : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token_str)"]
        
        apiClient.getEventsDetailsApi(id : 34,headers: header, completion: { status,Values in
            
            if status == "success" {
                if let response = Values {
                    
                    HUD.hide()
                    
                    DispatchQueue.main.async {
                        
                        self.getDetails(response:response)
                        
                    }
                    
                }
                
            } else {
                print("json respose failure:::::::")
                HUD.hide()
                DispatchQueue.main.async {
                    
                    self.myscrollView.isHidden = true
                    
                }
                
            }
        })
    }
    func getDetails(response:EventList) {
        
        if let name = response.name {
            eventTitleLabel.text = name
        }
        
        if let description = response.description {
            eventDescriptionLabel.text = description
        }
        
        if let startsat = response.startsat {
            print(startsat)
            if response.startsat != nil {
                //                eventDateLabel.text = PrefsManager.sharedinstance.startsat + "-" + (PrefsManager.sharedinstance.endsat)
            }
        }
        
        if let endsat = response.endsat {
            print(endsat)
            if response.endsat != nil {
                
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let date = formatter.date(from: endsat)
                let date2 = formatter.date(from: response.startsat!)
                
                print("date: \(String(describing: date))")
                print("date: \(String(describing: date2))")
                
                formatter.dateFormat = "MMM dd,h:mm a"
                let dateString = formatter.string(from: date!)
                let dateString2 = formatter.string(from: date2!)
                eventDateLabel.text = dateString2 + " - " + dateString
                print("datestring:::::",dateString,dateString2)
            }
        }
        
        
        if let eventLinkList = response.eventLinkList {
            if  eventLinkList.count > 0 {
                EventLinkLabel1.text = eventLinkList[0].linktext
                MyVariables.link1 = eventLinkList[0].weblink!
                
            }
            if eventLinkList.count > 1 {
                eventLinkLabel2.text = eventLinkList[1].linktext
                MyVariables.link2 = eventLinkList[1].weblink!
                
                
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
        }
        
        if let loclist = response.loclist {
            if response.loclist != nil {
                eventPlaceLabel.text    = loclist.name_str
                MyVariables.fetchedLat  = loclist.lattitude_str!
                MyVariables.fetchedLong = loclist.longitude_str!
                MyVariables.markerTitle = loclist.name_str!
                print("lat and lon values are:::::",MyVariables.fetchedLat,MyVariables.fetchedLong)
            }
        }
        
        if let imglist = response.imagelist {
            if imglist.count > 0 {
                if let url = imglist[imglist.count-1].imageurl_str {
                    
                    apiClient.getFireBaseImageUrl(imagepath: url, completion: { imageUrl in
                        
                        if imageUrl != "empty" {
                            
                            Manager.shared.loadImage(with: URL(string : imageUrl)!, into: self.eventImageView)
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
            if let description = response.description {
            eventDescriptionHeight.constant = TextSize.sharedinstance.getLabelHeight(text: description, width: eventDescriptionLabel.frame.width, font: eventDescriptionLabel.font)
            description_txt = description
            }
        }
        
        self.myscrollView.isHidden = false
    }
}




