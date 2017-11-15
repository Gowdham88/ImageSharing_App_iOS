//
//  Profile_PostViewController.swift
//  Numnu
//
//  Created by Gowdhaman on 06/11/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

class Profile_PostViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var navigationItemList: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavBar()
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.black,
             NSFontAttributeName: UIFont(name: "Avenir-Light", size: 16)!]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    func setNavBar() {
        
        navigationItemList.title = "Profile"
        
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
        let leftButton =  UIBarButtonItem(customView: button)
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
    
    func settingsClicked(){
        let storyboard = UIStoryboard(name: Constants.Main, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "SettingsVC")
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Profile_postTableViewCell
        
//        cell.delegate = (self as! PostEventTableViewCellDelegate)
//        cell.postEventBookMark.tag = indexPath.row
        
        return cell
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
