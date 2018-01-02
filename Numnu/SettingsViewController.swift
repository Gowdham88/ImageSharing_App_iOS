//
//  SettingsViewController.swift
//  Numnu
//
//  Created by Gowdhaman on 02/11/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import Nuke
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKLoginKit

//var itemArray :Array = String
var itemArray = [String]()
var itemArray2 = [String]()

protocol SettingsViewControllerDelegate {
    
    func sendlogoutstatus()
    
    func logout()
}


class SettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var myScrollView: UIScrollView!
    
    @IBOutlet weak var topHeaderView: UIView!
    @IBOutlet var navigationItemList: UINavigationItem!
    
    @IBOutlet weak var usernamelabel: UILabel!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var profileImageview: UIImageView!
    @IBOutlet var settingsTableView: UITableView!
    var delegate : SettingsViewControllerDelegate?
    var type : String?
    var tagArray = [TagList]()
    override func viewDidLoad() {
        super.viewDidLoad()
       setNavBar()
        myScrollView.delegate = self
        myScrollView.isScrollEnabled = true
        settingsTableView.isScrollEnabled = false
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.black,
             NSFontAttributeName: UIFont(name: "Avenir-Light", size: 16)!]
        // Do any additional setup after loading the view.
        
        editButton.layer.cornerRadius = self.editButton.frame.size.height/2
        editButton.clipsToBounds = true
        
        self.profileImageview.layer.cornerRadius = self.profileImageview.frame.size.height/2
        self.profileImageview.clipsToBounds = true
        
        itemArray = ["Share the app","Rate the app","Terms of service","Privacy policy"]
        itemArray2 = ["Events","Business","Items","Posts","Users"]
//        topHeaderView.backgroundColor = UIColor(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1.0)
        
        setUserDetails()

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return itemArray.count
        }else if section == 1 {
            return itemArray2.count
        }else if section == 2 {
            return 1
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: "cell") as! SettingsTableViewCell
        
        if indexPath.section == 0 {
            cell.nameLabel.text = itemArray[indexPath.row]
        }else if indexPath.section == 1 {
            cell.nameLabel.text = itemArray2[indexPath.row]
        }else if indexPath.section == 2 {
            cell.textLabel?.text = "       Logout"
            cell.textLabel?.font = UIFont(name: "Avenir-Medium", size: 14)
        }else {
            cell.textLabel?.text = ""
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 1 {
        return 40
    }else if section == 2 {
    return 40
    }else{
        return 0
    }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "          Bookmarks"
        }else if section == 2 {
            return ""
        }
        return ""
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.backgroundColor = UIColor(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1.0)
            headerTitle.textLabel?.textColor = UIColor(red: 129/255.0, green: 135/255.0, blue: 144/255.0, alpha: 1.0)
            headerTitle.textLabel?.font = UIFont(name: "Avenir-Medium", size: 14.0)

        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.clear
        
        
        if indexPath.section == 1  {
            if indexPath.row == 0 {
                type = "Event"

            }else if indexPath.row == 1 {
                type = "Business"
                
            }else if indexPath.row == 2 {
                type = "Item"

            }else if indexPath.row == 3 {
                type = "Post"
            }
            
            let storyboard = UIStoryboard(name: Constants.LocationDetail, bundle: nil)
            let vc         = storyboard.instantiateViewController(withIdentifier:"BookmarkViewController") as! BookmarkViewController
            vc.apiType     = type
            self.navigationController?.pushViewController(vc, animated: true)
        
        }

        if  indexPath.section == 2 && indexPath.row == 0 {
            let Alert = UIAlertController(title: "Do you want to logout?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            
            let CancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) {_ in
            }
            let OkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { ACTION in
                self.logout()
            }
            Alert.addAction(OkAction)
            Alert.addAction(CancelAction)
            present(Alert, animated: true, completion:nil )
          
        }
        
       
        
        
    }
    func logout (){
        DBProvider.Instance.firebaseLogout()
        delegate?.logout()
        FBSDKLoginManager().logOut()
        PrefsManager.sharedinstance.logoutprefences()
        PrefsManager.sharedinstance.isLoginned = false
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setNavBar() {
    
        navigationItemList.title = "Settings"
        
        let button: UIButton = UIButton(type: UIButtonType.custom)
        //set image for button
        button.setImage(UIImage(named: "ic_arrow_back"), for: UIControlState.normal)
        //add function for button
        button.addTarget(self, action: #selector(EventViewController.backButtonClicked), for: UIControlEvents.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(customView: button)
        leftButton.isEnabled = true
        
        let rightButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        // Create two buttons for the navigation item
        navigationItemList.leftBarButtonItem = leftButton
        navigationItemList.rightBarButtonItem = rightButton
        
        
    }
    
    func backButtonClicked() {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        setUserDetails()
    }
    
    // Edit button Navigation //
    @IBAction func didTappedEdit(_ sender: Any) {
        
        delegate?.sendlogoutstatus()
   
        let storyboard = UIStoryboard(name: Constants.Main, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "SettingsEdit_ProfieViewController") as! SettingsEdit_ProfieViewController
        vc.show        = false
        self.navigationController!.pushViewController(vc, animated: true)
 }
   
    func setUserDetails(){
        
        usernamelabel.text = PrefsManager.sharedinstance.username
        
        let apiclient : ApiClient = ApiClient()
        apiclient.getFireBaseImageUrl(imagepath: PrefsManager.sharedinstance.imageURL, completion: { url in
            
            if url != "empty" {
                
                Manager.shared.loadImage(with:URL(string:url)!, into: self.profileImageview)
                
            }
            
            
        })
        
    }
    
    
    
  
}
