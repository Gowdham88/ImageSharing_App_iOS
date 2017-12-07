//
//  EventTabController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/9/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip

protocol  EventTabControllerDelegate {
    
    func eventTableHeight(height : CGFloat)
    
}


class EventTabController: UIViewController,IndicatorInfoProvider {
 
    @IBOutlet weak var eventTableView: UITableView!
    var window : UIWindow?
    
    var tagarray = ["Festival","Wine","Party","Rum","Barbaque","Pasta","Sandwich","Burger"]
    var showNavBar : Bool = false
    @IBOutlet weak var navigationItemList: UINavigationItem!
    var eventdelegate : EventTabControllerDelegate?
    var viewState     : Bool = false
    var scrolltableview : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        eventTableView.delegate   = self
        eventTableView.dataSource = self
        eventTableView.isScrollEnabled = scrolltableview
        
        if showNavBar {
         
            setNavBar()
            
        }
   
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        viewState = true
        eventTableView.reloadData()
        
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
        
        openStoryBoard()
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        if indexPath.row == lastRowIndex - 1 && viewState {
            eventdelegate?.eventTableHeight(height: eventTableView.contentSize.height)
            viewState = false
        }
    }
    
    
}

extension EventTabController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tagarray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagcell", for: indexPath) as! EventTagCollectionCell
        
        let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: tagarray[indexPath.row], fontname: "Avenir-Medium", size: 12)
        
        cell.tagnamelabel.text = tagarray[indexPath.row]
        
        cell.setLabelSize(size: textSize)
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: tagarray[indexPath.row], fontname: "Avenir-Medium", size: 12)
        
        return CGSize(width: textSize.width+20, height: 22)
    }
    
    
    
}

extension EventTabController {
    
    /******************Set navigation bar**************************/
    
    func setNavBar() {
        
        navigationItemList.title = "Event"
        
        let button: UIButton = UIButton(type: UIButtonType.custom)
        //set image for button
        button.setImage(UIImage(named: "ic_arrow_back"), for: UIControlState.normal)
        //add function for button
        button.addTarget(self, action: #selector(EventViewController.backButtonClicked), for: UIControlEvents.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(customView: button)
        
        let rightButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        // Create two buttons for the navigation item
        navigationItemList.leftBarButtonItem  = leftButton
        navigationItemList.rightBarButtonItem = rightButton
        
        
    }
    
    func backButtonClicked() {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func  openStoryBoard() {
        
        let storyboard = UIStoryboard(name: Constants.Event, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.EventStoryId)
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    
}
