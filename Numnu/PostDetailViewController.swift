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

    @IBOutlet weak var navigationItemList: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBar()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    @IBAction func ButtonBokkMark(_ sender: UIButton) {
        
        share()
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
    
    
}
