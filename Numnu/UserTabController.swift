//
//  UserTabController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/9/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class UserTabController: UIViewController,IndicatorInfoProvider,UITableViewDelegate,UITableViewDataSource {
    var nameArray = [String]()
    var imagesArray = [UIImage]()

    @IBOutlet weak var userTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
nameArray = ["Williams","Harry hart","Mark strong","Samuel L Jackson","Sofia Boutella","Colin Firth","Gazelle","Merlin","Jennifer","Kevin Bacon","James McAvoy"]
imagesArray = [UIImage(named: "p7.png")!,UIImage(named: "p8.png")!,UIImage(named: "p7.png")!,UIImage(named: "p8.png")!,UIImage(named: "p7.png")!,UIImage(named: "p7.png")!,UIImage(named: "p8.png")!,UIImage(named: "p7.png")!,UIImage(named: "p8.png")!,UIImage(named: "p7.png")!,UIImage(named: "p8.png")!,]
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTableView.dequeueReusableCell(withIdentifier: "Cell" ) as! UserTableViewCell
        cell.userLabel.text = nameArray [indexPath.row]
        cell.userImage.image = imagesArray [indexPath.row]
        cell.userImage.layer.cornerRadius = cell.userImage.frame.size.height/2
        cell.userImage.clipsToBounds = true

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.Main, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "Profile_PostViewController") as! Profile_PostViewController
vc.boolForBack = false
        self.navigationController!.pushViewController(vc, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // Tab intialliaze
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
//        return IndicatorInfo(title: Constants.Tabid5)
        return IndicatorInfo(title: "Users")

    }
    

   

}
