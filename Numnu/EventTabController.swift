//
//  EventTabController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/9/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class EventTabController: UIViewController,IndicatorInfoProvider {
 
    @IBOutlet weak var eventTableView: UITableView!
    var window : UIWindow?
    
     var tagarray = ["Festival","Wine","Party","Rum","Barbaque","Pasta","Sandwich","Burger"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        eventTableView.delegate   = self
        eventTableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // Tab intialliaze
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: Constants.Tab1)
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

extension EventTabController : UITableViewDelegate,UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventcell", for: indexPath) as! EventTableViewCell
        
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}

extension EventTabController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tagarray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagcell", for: indexPath) as! EventTagCollectionCell
        
        let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: tagarray[indexPath.row], fontname: "AvenirNext-Regular", size: 15)
        
        cell.tagnamelabel.text = tagarray[indexPath.row]
        
        cell.setLabelSize(size: textSize)
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: tagarray[indexPath.row], fontname: "AvenirNext-Regular", size: 15)
        
        return CGSize(width: textSize.width+20, height: 30)
    }
    
    
    
}
