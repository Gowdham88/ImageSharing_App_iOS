//
//  EventViewController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/16/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class EventViewController: ButtonBarPagerTabStripViewController {
    
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
    var tagarray = ["Festival","Wine","Party","Rum","Barbaque","Pasta","Sandwich","Burger"]
    @IBOutlet weak var shareView: UIView!
    /***************contraints***********************/
    
    @IBOutlet weak var eventDescriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var containerViewTop: NSLayoutConstraint!
    @IBOutlet weak var barButtonTop: NSLayoutConstraint!
    
    /***************Read more variable*********************/
    
    var isLabelAtMaxHeight = false
    var contentHeignt      = 649
    
    override func viewDidLoad() {
        settings.style.selectedBarHeight = 2.0
         settings.style.buttonBarItemFont = UIFont(name: "Avenir-Medium", size: 14)!
        super.viewDidLoad()
        
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
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.textlightDark()
            newCell?.label.textColor = UIColor.appBlackColor()
            
        }
        
        
        /**********************set Nav bar****************************/
        
        setNavBar()
        alertTapRegister()

        /****************event label tap function************************/
        
        tapRegistration()
        
        tagViewUpdate()
        
        eventDescriptionLabel.text = Constants.dummy
        
       /****************Checking number of lines************************/
     
        if (eventDescriptionLabel.numberOfVisibleLines > 4) {
            
            readMoreButton.isHidden = false
      
        } else {
        
            readMoreButton.isHidden   = true
            containerViewTop.constant = 8
            barButtonTop.constant     = 8
            eventDescriptionHeight.constant = TextSize.sharedinstance.getLabelHeight(text: Constants.dummy, width: eventDescriptionLabel.frame.width, font: eventDescriptionLabel.font)
           
        }
        
        
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
        child_2.showentity = true
        child_2.menuDelegate = self
        
        let child_3 = UIStoryboard(name: Constants.EventDetail, bundle: nil).instantiateViewController(withIdentifier: Constants.EventTabid3) as! ReviewEventViewController
        child_3.popdelegate = self
        return [child_1,child_2,child_3]
        
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
            eventDescriptionHeight.constant = TextSize.sharedinstance.getLabelHeight(text: Constants.dummy, width: eventDescriptionLabel.frame.width, font: eventDescriptionLabel.font)
           
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
      
        openWebBoard(url: "https://www.apple.com")
    }
    
    func webLink2(sender:UITapGestureRecognizer) {
        
        openWebBoard(url: "https://www.apple.com")
        
    }
    
    func webLink3(sender:UITapGestureRecognizer) {
        
        openWebBoard(url: "https://www.apple.com")
        
    }
    
    func mapRedirect(sender:UITapGestureRecognizer) {
        
        openMapBoard()
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
        
        _ = self.navigationController?.popToRootViewController(animated: true)
        
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



