//
//  PostTabController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/9/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip



class PostTabController: UIViewController,IndicatorInfoProvider {
    
    @IBOutlet weak var postEventTableView: UITableView!
    
     var tagarray = ["Festival","Wine","Party","Rum","Barbaque","Pasta","Sandwich","Burger"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        postEventTableView.delegate   = self
//        postEventTableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: Constants.Tab4)
    }
    

}


