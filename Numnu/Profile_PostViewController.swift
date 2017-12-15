//
//  Profile_PostViewController.swift
//  Numnu
//
//  Created by Gowdhaman on 06/11/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import PKHUD
import Nuke

protocol Profile_PostViewControllerDelegae {
    
    func sendlogoutstatus()
    
    func logout()
}



class Profile_PostViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var navigationItemList: UINavigationItem!
    @IBOutlet weak var myScrollView: UIScrollView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionlabel: UILabel!
    @IBOutlet weak var userNamelabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mainViewBottom: NSLayoutConstraint! 
    @IBOutlet weak var mainViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var shareview: UIView!
    var boolForBack : Bool = true

    @IBOutlet weak var EventverticalConstraint: NSLayoutConstraint!
    var itemArray = [TagList]()
    var delegate : Profile_PostViewControllerDelegae?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavBar()
        HUD.hide()
        myScrollView.delegate = self
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.black,
             NSFontAttributeName: UIFont(name: "Avenir-Light", size: 16)!]
        userImage.layer.cornerRadius = self.userImage.frame.size.height/2
        userImage.contentMode = .scaleAspectFill
        userImage.clipsToBounds = true
        alertTapRegister()
        
        /***********************Setuserdetails****************************/
        setUserDetails()
       
    
    }
    func navigationTap(){
        let offset = CGPoint(x: 0,y :0)
        self.myScrollView.setContentOffset(offset, animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
            let navigationOnTap = UITapGestureRecognizer(target:self,action:#selector(EventViewController.navigationTap))
            self.navigationController?.navigationBar.addGestureRecognizer(navigationOnTap)
            self.navigationController?.navigationBar.isUserInteractionEnabled = true
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        /***********************Setuserdetails****************************/
        setUserDetails()
    }
    
    func setNavBar() {
        
        navigationItemList.title = "@\(PrefsManager.sharedinstance.username)"
        
        let button: UIButton = UIButton(type: UIButtonType.custom)
        //set image for button
        if  boolForBack == false {
            button.setImage(UIImage(named: "ic_arrow_back"), for: UIControlState.normal)

        }else{
            button.setImage(UIImage(named: ""), for: UIControlState.normal)
        }
        //add function for button
        button.addTarget(self, action: #selector(EventViewController.backButtonClicked), for: UIControlEvents.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        
        // Right bar button //
        
        let button2: UIButton = UIButton(type: UIButtonType.custom)
        //set image for button
        button2.setImage(UIImage(named: "settings"), for: UIControlState.normal)
        //add function for button
        button2.addTarget(self, action: #selector(settingsClicked), for: UIControlEvents.touchUpInside)
        //set frame
        button2.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        
        // Create left and right button for navigation item
       
        let leftButton =  UIBarButtonItem(customView:button)
        leftButton.isEnabled = true
        
//        let rightButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        let rightButton = UIBarButtonItem(customView:button2)
        rightButton.isEnabled = true
        
        // Create two buttons for the navigation item
        navigationItemList.leftBarButtonItem = leftButton
        navigationItemList.rightBarButtonItem = rightButton
        
        
    }
  
    func backButtonClicked() {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func settingsClicked() {
        
        let storyboard = UIStoryboard(name: Constants.Main, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsViewController
        vc.delegate    = self
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Profile_postTableViewCell
        
        cell.delegate = self
        cell.postEventBookMark.tag = indexPath.row
        
        let posteventlabeltap = UITapGestureRecognizer(target: self, action: #selector(Profile_postTableViewCell.CenterImageTapped))
        cell.postUserImage.addGestureRecognizer(posteventlabeltap)
        cell.postUserImage.isUserInteractionEnabled = true
        
        let posteventplacetap = UITapGestureRecognizer(target: self, action:#selector(getter: Profile_postTableViewCell.postEventPlace))
        cell.postEventPlace.addGestureRecognizer(posteventplacetap)
        cell.postEventPlace.isUserInteractionEnabled = true
        
        let posteventdishtap = UITapGestureRecognizer(target: self, action:#selector(getter: Profile_postTableViewCell.postEventDishLabel))
        cell.postEventDishLabel.addGestureRecognizer(posteventdishtap)
        cell.postEventDishLabel.isUserInteractionEnabled = true
        
        let posteventnametap = UITapGestureRecognizer(target: self, action:#selector(getter: Profile_postTableViewCell.postEventName))
        cell.postEventName.addGestureRecognizer(posteventnametap)
        cell.postEventName.isUserInteractionEnabled = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
//        let storyboard = UIStoryboard(name: Constants.PostDetail, bundle: nil)
//        let vc         = storyboard.instantiateViewController(withIdentifier: "postdetailid")
//        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        if indexPath.row == lastRowIndex - 1 {
           menuTableHeight(height: self.tableView.contentSize.height)
        }
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func CenterImageTapped(){
        let storyboard = UIStoryboard(name: Constants.PostDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "postdetailid")
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    func postEventPlace(){
        let storyboard = UIStoryboard(name: Constants.ItemDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.ItemDetailId)
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    func postEventDishLabel(){
        let storyboard = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.BusinessCompleteId)
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    func postEventName(){
        
        let storyboard = UIStoryboard(name: Constants.Event, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.EventStoryId)
        self.navigationController!.pushViewController(vc, animated: true)
    }
// collectionview cell //
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ccell", for: indexPath as IndexPath) as! UserProfileTagCollectionViewCell
        
        if let tagName = itemArray[indexPath.row].text_str {
            
            let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: tagName, fontname: "Avenir-Book", size: 13)
            cell.tagLabel.text = tagName
            cell.setLabelSize(size: textSize)
            
        }
  
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let tagName = itemArray[indexPath.row].text_str {
            
            let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: tagName, fontname: "Avenir-Book", size: 13)
            
            return CGSize(width: textSize.width+20, height: 22)
            
        } else {
            
            return CGSize(width: 0, height: 22)
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
   
    /***********************Setuserdetails****************************/
    
    func setUserDetails(){
        
        userNamelabel.text = PrefsManager.sharedinstance.username
        addressLabel.text  = PrefsManager.sharedinstance.userCity
        descriptionlabel.text = PrefsManager.sharedinstance.description
        print(PrefsManager.sharedinstance.tagList)
        itemArray  = PrefsManager.sharedinstance.tagList
        collectionView.reloadData()
        
        let apiclient : ApiClient = ApiClient()
        apiclient.getFireBaseImageUrl(imagepath: PrefsManager.sharedinstance.imageURL, completion: { url in
            
            if url != "empty" {
                
                Manager.shared.loadImage(with:URL(string:url)!, into: self.userImage)
                
            }
            
            
        })
       
    }

}

extension Profile_PostViewController : Profile_postTableViewCellDelegate {
    
    func popup() {
       
        openPopup()
        
    }
    
    func alertTapRegister() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closePopup(sender:)))
        self.shareview.addGestureRecognizer(tap)
        
    }
    
    func closePopup(sender : UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            
            self.shareview.alpha  = 0
            
        }, completion: nil)
        
    }
    
    func openPopup() {
        
        self.shareview.alpha   = 1
        
        let top = CGAffineTransform(translationX: 0, y: 0)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            
            self.shareview.isHidden  = false
            self.shareview.transform = top
            
        }, completion: nil)
  
    }
    
    func menuTableHeight(height: CGFloat) {
        
        mainViewConstraint.constant = 186 + height
        mainViewBottom.constant = 0
    }
}

extension Profile_PostViewController :SettingsViewControllerDelegate {
    
    func sendlogoutstatus() {
        
        delegate?.sendlogoutstatus()
        
    }
    
    func logout() {
        
        
        addProfileContainer()
        
    }
    
    func addProfileContainer() {
        
        /**************************Setting tabs*********************************/
        
        let nav1              = UINavigationController()
        let storyboard        = UIStoryboard(name: Constants.Main, bundle: nil)
        let controller        = storyboard.instantiateViewController(withIdentifier: Constants.ProfileId) as! Edit_ProfileVC
        controller.boolForTitle = false
        nav1.viewControllers = [controller]
        self.tabBarController?.viewControllers?.append(nav1)
        let myImage = UIImage(named: "profileunselected")!
        let myInsets : UIEdgeInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        controller.tabBarItem.title        = ""
        controller.tabBarItem.imageInsets  = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        controller.tabBarItem = UITabBarItem(
            title: "",
            image: myImage,
            tag: 3)
        
        /**************************Removing tabs*********************************/
        
        if let tabBarController = self.tabBarController {
            let indexToRemove = 2
            if indexToRemove < (tabBarController.viewControllers?.count)! {
                var viewControllers = tabBarController.viewControllers
                viewControllers?.remove(at: indexToRemove)
                tabBarController.viewControllers = viewControllers
            }
        }
        
    }
}
