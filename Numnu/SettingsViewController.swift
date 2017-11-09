//
//  SettingsViewController.swift
//  Numnu
//
//  Created by Gowdhaman on 02/11/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

//var itemArray :Array = String
var itemArray = [String]()
var itemArray2 = [String]()


class SettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

   
    @IBOutlet var navigationItemList: UINavigationItem!
    
    @IBOutlet var editButton: UIButton!
    @IBOutlet var profileImageview: UIImageView!
    @IBOutlet var settingsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       setNavBar()
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.black,
             NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 19)!]
        // Do any additional setup after loading the view.
        
        editButton.layer.cornerRadius = self.editButton.frame.size.height/2
        editButton.clipsToBounds = true
        
        profileImageview.layer.cornerRadius = self.profileImageview.frame.size.height/2
        profileImageview.clipsToBounds = true
        
        itemArray = ["Share the app","Rate the app","Terms of service","Privacy policy"]
        itemArray2 = ["Events","Business","Items","Posts","Users"]

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return itemArray.count
        }else if section == 1 {
            return itemArray2.count
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
    }else {
    return 0
    }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "         Bookmarks"
        }
        return ""
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = UIColor.lightGray
        }
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
    // Edit button Navigation //
    
    @IBAction func didTappedEdit(_ sender: Any) {
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: Constants.Main, bundle:nil)
//        let editProfile = storyBoard.instantiateViewController(withIdentifier: "profileid") as! Edit_ProfileVC
////        self.present(editProfile, animated:true, completion:nil)
//        self.navigationController?.pushViewController(editProfile, animated: true)
        
        let storyboard = UIStoryboard(name: Constants.Main, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "profileid")
        self.navigationController!.pushViewController(vc, animated: true)
        
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
