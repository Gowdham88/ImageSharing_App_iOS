//
//  BusinessCompleteViewController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/31/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class BusinessCompleteViewController: ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var BcImageView: ImageExtender!
    @IBOutlet weak var BcTitleLabel: UILabel!
   
    
    @IBOutlet weak var BcDescriptionLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    
    
    @IBOutlet weak var TabBarView: ButtonBarView!
    @IBOutlet weak var pagerView: UIScrollView!
    @IBOutlet weak var tagScrollView: UIScrollView!
    
    @IBOutlet weak var navigationItemList: UINavigationItem!
    
    @IBOutlet weak var mainContainerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var mainContainerView: NSLayoutConstraint!
    var tagarray = ["Festival","Wine","Party","Rum","Barbaque","Pasta","Sandwich","Burger"]
    
    /***************contraints***********************/
    
    @IBOutlet weak var eventDescriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var containerViewTop: NSLayoutConstraint!
    @IBOutlet weak var barButtonTop: NSLayoutConstraint!
    
    /***************Read more variable*********************/
    
    var isLabelAtMaxHeight = false

    override func viewDidLoad() {
       settings.style.selectedBarHeight = 3.0
        super.viewDidLoad()
        
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = UIColor.appBlackColor()
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        
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
        
        
        /**********************set Nav bar****************************/
        
        setNavBar()
        
        /****************event label tap function************************/
        
        tapRegistration()
        
        tagViewUpdate()
        
        BcDescriptionLabel.text = Constants.dummy
        
        /****************Checking number of lines************************/
        
        if (BcDescriptionLabel.numberOfVisibleLines > 4) {
            
            readMoreButton.isHidden = false
            
        } else {
            
            readMoreButton.isHidden         = true
            eventDescriptionHeight.constant = TextSize.sharedinstance.getLabelHeight(text: Constants.dummy, width: BcDescriptionLabel.frame.width, font: BcDescriptionLabel.font)
            containerViewTop.constant  = 398
            barButtonTop.constant      = 398
        }
        
        /******************checking iphone device****************************/
        
        if self.view.frame.height <= 568 {
            
            mainContainerView.constant       = 550
            mainContainerViewBottom.constant = 0
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_1 = UIStoryboard(name: Constants.EventDetail, bundle: nil).instantiateViewController(withIdentifier: Constants.EventTabid2)
        let child_2 = UIStoryboard(name: Constants.EventDetail, bundle: nil).instantiateViewController(withIdentifier: Constants.EventTabid3)
        let child_3 = UIStoryboard(name: Constants.Tab, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid1)
        return [child_1,child_2,child_3]
        
    }
    
    @IBAction func ButtonReadMore(_ sender: UIButton) {
        
        if isLabelAtMaxHeight {
            
            readMoreButton.setTitle("more", for: .normal)
            isLabelAtMaxHeight = false
            eventDescriptionHeight.constant = 85
            containerViewTop.constant  = 428
            barButtonTop.constant      = 428
            
        } else {
            
            readMoreButton.setTitle("less", for: .normal)
            isLabelAtMaxHeight = true
            eventDescriptionHeight.constant = TextSize.sharedinstance.getLabelHeight(text: Constants.dummy, width: BcDescriptionLabel.frame.width, font: BcDescriptionLabel.font)
            containerViewTop.constant       = 343+TextSize.sharedinstance.getLabelHeight(text: Constants.dummy, width: BcDescriptionLabel.frame.width, font: BcDescriptionLabel.font)
            barButtonTop.constant           = 343+TextSize.sharedinstance.getLabelHeight(text: Constants.dummy, width: BcDescriptionLabel.frame.width, font: BcDescriptionLabel.font)
            
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
            let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: text, fontname: "AvenirNext-Regular", size: 15)
            textLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
            textLabel.text = text
            textLabel.backgroundColor  = UIColor.tagBgColor()
            textLabel.textColor        = UIColor.tagTextColor()
            textLabel.layer.cornerRadius = 10
            textLabel.layer.masksToBounds = true
            textLabel.textAlignment = .center
            
            if i == 0 {
                
                textLabel.frame = CGRect(x: 0, y: 0, width: textSize.width+20, height: 30)
                
            } else {
                
                textLabel.frame = CGRect(x: expandableWidth, y: 0, width: textSize.width+20, height: 30)
                
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
        
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(customView: button)
        
        let rightButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        // Create two buttons for the navigation item
        navigationItemList.leftBarButtonItem  = leftButton
        navigationItemList.rightBarButtonItem = rightButton
        
        
    }
    
    func backButtonClicked() {
        
        _ = self.navigationController?.popToRootViewController(animated: true)
        
    }
    
   
    
    func openStoryBoard () {
        
        let storyboard      = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: Constants.BusinessCompleteId)
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
}
