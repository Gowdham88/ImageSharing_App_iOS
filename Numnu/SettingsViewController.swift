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

    @IBAction func didTappedEdit(_ sender: Any) {
    }
    
    @IBOutlet var editButton: UIButton!
    @IBOutlet var profileImageview: UIImageView!
    @IBOutlet var settingsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.black,
             NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 21)!]
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
