//
//  Profile_PostViewController.swift
//  Numnu
//
//  Created by Gowdhaman on 06/11/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

protocol Profile_PostViewControllerDelegae {
    
    func sendlogoutstatus()
    
    func logout()
}



class Profile_PostViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var navigationItemList: UINavigationItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mainViewBottom: NSLayoutConstraint!
    @IBOutlet weak var mainViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var shareview: UIView!
    
    var itemArray = [String]()
    var delegate : Profile_PostViewControllerDelegae?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavBar()
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.black,
             NSFontAttributeName: UIFont(name: "Avenir-Light", size: 16)!]
        userImage.layer.cornerRadius = self.userImage.frame.size.height/2
        userImage.clipsToBounds = true
        alertTapRegister()
        itemArray = ["Festival","Wine","Party","Meeting"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setNavBar() {
        
        navigationItemList.title = "@Suraj Balachandran"
        
        let button: UIButton = UIButton(type: UIButtonType.custom)
        //set image for button
        button.setImage(UIImage(named: "ic_arrow_back"), for: UIControlState.normal)
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
        let leftButton =  UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        leftButton.isEnabled = true
        
//        let rightButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        let rightButton = UIBarButtonItem(customView:button2)
        rightButton.isEnabled = true
        
        // Create two buttons for the navigation item
        navigationItemList.leftBarButtonItem = leftButton
        navigationItemList.rightBarButtonItem = rightButton
        
        
    }
  
    func backButtonClicked() {
        
        _ = self.navigationController?.popToRootViewController(animated: true)
        
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        if indexPath.row == lastRowIndex - 1 {
           menuTableHeight(height: self.tableView.contentSize.height)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// collectionview cell //
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ccell", for: indexPath as IndexPath) as! UserProfileTagCollectionViewCell
       cell.tagLabel.text = itemArray[indexPath.row]
       cell.tagLabel.layer.cornerRadius = 4.0
    cell.tagLabel.clipsToBounds = true
        
        return cell
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
        
        delegate?.logout()
    }
}
