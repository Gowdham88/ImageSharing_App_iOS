//
//  DefaultTabController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/24/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class DefaultTabController: UIViewController,IndicatorInfoProvider {
    
    var window : UIWindow?
    
    @IBOutlet weak var eventCollectionView1: UICollectionView!
    @IBOutlet weak var eventCollectionView2: UICollectionView!
    
    
    @IBOutlet weak var currentButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var currentEventTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintView2: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintView1: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventCollectionView1.delegate = self
        eventCollectionView2.delegate = self
        eventCollectionView1.dataSource = self
        eventCollectionView2.dataSource = self
        
        /*************Resize collection view*******************/
        
        resizeCollectionHeight()
        currentEventTopConstraint.constant = 12
        currentButtonTopConstraint.constant = 12
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: Constants.Tab1)
    }
    
    
    @IBAction func ButtonCurrentEvents(_ sender: UIButton) {
        
        openStoryBoard(name: Constants.Tab, id: Constants.Tabid1)
        
    }
    
    
    @IBAction func ButtonPastEvents(_ sender: UIButton) {
        
        openStoryBoard(name: Constants.Tab, id: Constants.Tabid1)
    }
    
    
}


extension DefaultTabController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == eventCollectionView1 {
            
            return 10
            
        } else {
            
            return 10
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == eventCollectionView1 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventcell1", for: indexPath) as! EventDefaulCollectionCell
            
            return cell
            
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventcell2", for: indexPath) as! EventDefaulCollectionCell2
            
            return cell
            
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        openStoryBoard(name: Constants.Event, id: Constants.EventStoryId)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
 
        /*****Size of the tab bar view*******************/
        
        if containerView.frame.height <= 349 {
            
            heightConstraintView1.constant = 125
            heightConstraintView2.constant = 125
            return CGSize(width: 125, height: 125)
            
        } else if containerView.frame.height <= 448 {
            
            heightConstraintView1.constant = 170
            heightConstraintView2.constant = 170
            return CGSize(width: 170, height: 170)
            
        } else if containerView.frame.height <= 517 {
            
            heightConstraintView1.constant = 200
            heightConstraintView2.constant = 200
            return CGSize(width: 200, height: 200)
            
        } else if containerView.frame.height <= 535 {
            
            heightConstraintView1.constant = 210
            heightConstraintView2.constant = 210
            return CGSize(width: 210, height: 210)
            
        } else if containerView.frame.height <= 805 {
            
            heightConstraintView1.constant = 315
            heightConstraintView2.constant = 315
            return CGSize(width: 315, height: 315)
            
        } else {
    
            heightConstraintView1.constant = 500
            heightConstraintView2.constant = 500
            return CGSize(width: 500, height: 500)
            
        }
       
        
    }
    
    func openStoryBoard(name: String,id : String) {
        
        window                          = UIWindow(frame: UIScreen.main.bounds)
        let storyboard                  = UIStoryboard(name: name, bundle: nil)
        if id == Constants.Tabid1 {
            
            let eventVc        = storyboard.instantiateViewController(withIdentifier: id) as! EventTabController
            eventVc.showNavBar = true
            self.navigationController!.pushViewController(eventVc, animated: true)
            
        } else {
            
            let initialViewController       = storyboard.instantiateViewController(withIdentifier: id)
            self.navigationController!.pushViewController(initialViewController, animated: true)
            
        }
    
    }

    
    
}

extension DefaultTabController {
    
    func resizeCollectionHeight() {
        
   
        
    }
    
    
}
