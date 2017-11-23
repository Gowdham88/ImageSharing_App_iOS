//
//  PostDetailViewController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/27/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

class PostDetailViewController : UIViewController {
    
    
    
    @IBOutlet weak var postDUsernameLabel: UILabel!
    @IBOutlet weak var postDUserImage: ImageExtender!
    @IBOutlet weak var postDUserplaceLabbel: UILabel!
    @IBOutlet weak var postDUserTime: UILabel!
    @IBOutlet weak var postDCommentLabel: UILabel!
    @IBOutlet weak var postDEventImage: ImageExtender!
    @IBOutlet weak var postDLikeImage: ImageExtender!
    @IBOutlet weak var postDEventName: UILabel!
    @IBOutlet weak var postDEventPlace: UILabel!
    @IBOutlet weak var postDEventDishLabel: UILabel!
    
    
    @IBOutlet weak var dishwidthDConstaint: NSLayoutConstraint!
    @IBOutlet weak var placeWidthDConstraint: NSLayoutConstraint!
    @IBOutlet weak var dishRightDLayoutConstraint: NSLayoutConstraint!

    @IBOutlet weak var alertViewHide: UIView!
    @IBOutlet weak var mainPostView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var navigationItemList: UINavigationItem!
    var window : UIWindow?
    
    @IBOutlet weak var eventTopHeight: NSLayoutConstraint!
    @IBOutlet weak var alertviewBottomConstraints: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBar()
        setHeight(heightview: Float(UIScreen.main.bounds.size.height))
        
        alertviewBottomConstraints.constant = self.view.frame.height + 600
        alertViewHide.alpha = 0
        alertTapRegister()

        let tap = UITapGestureRecognizer(target: self, action: #selector(PostDetailViewController.imageTapped))
        postDEventImage.addGestureRecognizer(tap)
        postDEventImage.isUserInteractionEnabled = true
        
        // Do any additional setup after loading the view.
        
        if (postDEventDishLabel.numberOfVisibleLines > 1) {
            
            eventTopHeight.constant = 52
            
        }
        
        if (postDEventPlace.numberOfVisibleLines > 1) {
            
            eventTopHeight.constant = 52
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    func imageTapped() {
        let storyboard = UIStoryboard(name: "PostDetail", bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "PostImageZoomViewController")
//        self.navigationController!.pushViewController(vc, animated: true)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    @IBAction func ButtonBokkMark(_ sender: UIButton) {
        
        openPopup()
    }
    
    
   

}


extension PostDetailViewController {
    
    /******************Set navigation bar**************************/
    
    func setNavBar() {
        
        navigationItemList.title = "Post"
        
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
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func share() {
        
        let optionMenu = UIAlertController(title:"Post", message: "", preferredStyle: .actionSheet)
        
        let Bookmark = UIAlertAction(title: "Bookmark", style: .default, handler: {
          
            (alert : UIAlertAction!) -> Void in
            
            self.window    = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: Constants.Auth, bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "signupvc")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()

        })
        
        let Share = UIAlertAction(title: "Share", style: .default, handler: {
            
            (alert : UIAlertAction!) -> Void in
            
        })
        
        
        let Cancel = UIAlertAction(title: "Cancel", style: .default, handler: {
            
            (alert: UIAlertAction!) -> Void in
            
        })
        
        
        optionMenu.addAction(Bookmark)
        optionMenu.addAction(Share)
        optionMenu.addAction(Cancel)
        
        
        optionMenu.popoverPresentationController?.sourceView = self.view
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        self.present(optionMenu, animated: true, completion: nil)
        
        
    }
    
    func alertTapRegister(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closePopup(sender:)))
        self.view.addGestureRecognizer(tap)
        
    }
    
    func closePopup(sender : UITapGestureRecognizer) {
        
        self.alertViewHide.alpha                 = 0
        
        UIView.animate(withDuration: 2, animations: {
            
            self.alertviewBottomConstraints.constant = self.view.frame.height + 600
            
            
        }, completion: nil)
        
       
        
    }
    
    func openPopup() {
        
         self.alertViewHide.alpha   = 1
        
        UIView.animate(withDuration: 2, animations: {
            
            self.alertviewBottomConstraints.constant  = 0
           
            
        }, completion: nil)
        
       
    }
    
    func setHeight(heightview : Float){
        
        if heightview <= 568 {
            
            dishwidthDConstaint.constant   = 75
            placeWidthDConstraint.constant = 75
            
            
        } else if heightview <= 667 {
            
            dishwidthDConstaint.constant   = 99
            placeWidthDConstraint.constant = 99
            
        } else if heightview <= 736 {
            
            dishwidthDConstaint.constant   = 117
            placeWidthDConstraint.constant = 117
            
        } else if heightview <= 812 {
            
            dishwidthDConstaint.constant   = 99
            placeWidthDConstraint.constant = 99
            
        } else if heightview <= 1024 {
            
            dishwidthDConstaint.constant   = 274
            placeWidthDConstraint.constant = 274
            
        } else {
            
            dishwidthDConstaint.constant   = 387
            placeWidthDConstraint.constant = 387
            
        }
        
    }
    
    
}
