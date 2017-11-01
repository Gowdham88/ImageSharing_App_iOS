//
//  LocationTabController.swift
//  Numnu
//
//  Created by CZ Ltd on 11/1/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class LocationTabController: UIViewController,IndicatorInfoProvider {

    @IBOutlet weak var locationTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTableView.delegate   = self
        locationTableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: Constants.Tab7)
    }
   

}

extension LocationTabController : UITableViewDelegate,UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationcell", for: indexPath) as! Locationtableviewcell
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell : Locationtableviewcell = tableView.cellForRow(at: indexPath) as! Locationtableviewcell
        cell.contentView.backgroundColor = UIColor.white
        openStoryBoard()
        
    }
    
    func  openStoryBoard() {
        
        let storyboard = UIStoryboard(name: Constants.BusinessDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.BusinessDetailId)
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    
}
