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
    
    var tagarray = ["Festival","Wine","Party","Rum","Barbaque","Pasta","Sandwich","Burger"]
    
    /***************contraints***********************/
    
    @IBOutlet weak var eventDescriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var containerViewTop: NSLayoutConstraint!
    @IBOutlet weak var barButtonTop: NSLayoutConstraint!
    
    /***************Read more variable*********************/
    
    var isLabelAtMaxHeight = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = UIColor.appBlackColor()
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
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

        /****************event label tap function************************/
        
        tapRegistration()
        
        tagViewUpdate()
        
        eventDescriptionLabel.text = Constants.dummy
        
         /****************Checking number of lines************************/
     
        if (eventDescriptionLabel.numberOfVisibleLines > 4)  {
            
            readMoreButton.isHidden = false
      
        } else {
            
            readMoreButton.isHidden = true
            eventDescriptionHeight.constant = TextSize.sharedinstance.getLabelHeight(text: Constants.dummy, width: eventDescriptionLabel.frame.width, font: eventDescriptionLabel.font)
            containerViewTop.constant  = 683
            barButtonTop.constant      = 683
        }
      
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: Constants.Tab, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid1)
        let child_2 = UIStoryboard(name: Constants.Tab, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid2)
        let child_3 = UIStoryboard(name: Constants.Tab, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid4)
        return [child_1, child_2,child_3]
    }
    

    @IBAction func ButtonReadMore(_ sender: UIButton) {
        
        if isLabelAtMaxHeight {
            readMoreButton.setTitle("Read more", for: .normal)
            isLabelAtMaxHeight = false
            eventDescriptionHeight.constant = 85
            containerViewTop.constant  = 713
            barButtonTop.constant      = 713
            
        } else {
            readMoreButton.setTitle("Read less", for: .normal)
            isLabelAtMaxHeight = true
            eventDescriptionHeight.constant = TextSize.sharedinstance.getLabelHeight(text: Constants.dummy, width: eventDescriptionLabel.frame.width, font: eventDescriptionLabel.font)
            containerViewTop.constant  = 628+TextSize.sharedinstance.getLabelHeight(text: Constants.dummy, width: eventDescriptionLabel.frame.width, font: eventDescriptionLabel.font)
            barButtonTop.constant      = 628+TextSize.sharedinstance.getLabelHeight(text: Constants.dummy, width: eventDescriptionLabel.frame.width, font: eventDescriptionLabel.font)
            
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
    
    func webLink1(sender:UITapGestureRecognizer){
        
    }
    
    func webLink2(sender:UITapGestureRecognizer){
        
    }
    
    func webLink3(sender:UITapGestureRecognizer){
        
    }
    
    func mapRedirect(sender:UITapGestureRecognizer){
        
    }
    
    /*************************Tag view updating************************************/
    
    func tagViewUpdate(){
        
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
    
    
}



