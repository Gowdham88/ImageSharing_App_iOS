//
//  EventTabController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/9/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import PKHUD
import Alamofire

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
    
    /******************Event Api******************************/
    
    var apiClient : ApiClient!
    var eventList = [EventTypeListItem]()
    var eventItem : EventTypeList?
    var pageno : Int  = 1
    var limitno : Int = 25
    var apiType : String = "Event"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        eventTableView.delegate   = self
        eventTableView.dataSource = self
        eventTableView.isScrollEnabled = scrolltableview
        
        if showNavBar {
         
            setNavBar()
            
        }
        
        /******************EventList******************************/
        
        apiClient = ApiClient()
        
   
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        eventList.removeAll()
        pageno  = 1
        limitno = 25
        switch apiType {
        case "Event":
            getEvent(pageno: pageno, limit: limitno)
        case "Business":
            getBusinessEvent(pageno: pageno, limit: limitno)
        default:
            getEvent(pageno: pageno, limit: limitno)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        viewState = true
    
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
        
        return eventList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventcell", for: indexPath) as! EventTableViewCell
        
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        cell.item = eventList[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let id = eventList[indexPath.row].id {
            
            openStoryBoard(primaryid: id)
            
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         
        if indexPath.row == eventList.count - 1 && viewState {
           
            if let pageItem = eventItem {
                
                if eventList.count  < pageItem.totalRows ?? 0{
                    pageno += 1
                    limitno = 25 * pageno
                    switch apiType {
                    case "Event":
                        getEvent(pageno: pageno, limit: limitno)
                    case "Business":
                        getBusinessEvent(pageno: pageno, limit: limitno)
                    default:
                        getEvent(pageno: pageno, limit: limitno)
                    }
                }
                
            }
            
        }
    }
    
    
}

extension EventTabController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return eventList[collectionView.tag].taglist?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagcell", for: indexPath) as! EventTagCollectionCell
        
        if let tagname = eventList[collectionView.tag].taglist?[indexPath.row].text_str {
            
            let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: tagname, fontname: "Avenir-Medium", size: 12)
            
            cell.tagnamelabel.text = tagname
            
            cell.setLabelSize(size: textSize)
            
        }
     
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let tagname = eventList[collectionView.tag].taglist?[indexPath.row].text_str {
        
        let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: tagname, fontname: "Avenir-Medium", size: 12)
        
        return CGSize(width: textSize.width+20, height: 22)
            
        } else {
            
            return CGSize(width: 0, height: 22)
        }
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
    
    func  openStoryBoard(primaryid : Int) {
        
        let storyboard    = UIStoryboard(name: Constants.Event, bundle: nil)
        let vc            = storyboard.instantiateViewController(withIdentifier: Constants.EventStoryId) as! EventViewController
        vc.eventprimaryid = 34
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    func getEvent(pageno:Int,limit:Int) {

        HUD.show(.labeledProgress(title: "Loading", subtitle: ""))

        apiClient.getFireBaseToken(completion: { token in

            let header : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
            let param  : String  = "page=\(pageno)&limit\(limit)"

            self.apiClient.getEventsApi(headers: header,parameter: param, completion: { status,eventlist in

                if status == "success" {

                    if let item = eventlist {
                        
                        self.eventItem = item

                        if let itemlist = item.eventtyItem {
                            
                            self.eventList += itemlist
                        }
                    }

                    DispatchQueue.main.async {

                        self.eventTableView.reloadData()

                    }

                    self.reloadTable()

                } else {

                    HUD.hide()
                    self.reloadTable()

                }


            })


        })


    }
    
    func reloadTable() {
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            self.eventdelegate?.eventTableHeight(height: self.eventTableView.contentSize.height)
            HUD.hide()
        }
        
    }
    
    /*************************get events by business id****************************************/
    
    func getBusinessEvent(pageno:Int,limit:Int) {
        
        HUD.show(.labeledProgress(title: "Loading", subtitle: ""))
        
        apiClient.getFireBaseToken(completion: { token in
            
            let header : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
            let param  : String  = "page=\(pageno)&limit\(limit)"
            
            self.apiClient.getEventsByBusinessApi(id: 50, page: param,headers: header, completion: { status,eventlist in
                
                if status == "success" {
                    
                    if let item = eventlist {
                        
                        self.eventItem = item
                        
                        if let itemlist = item.eventtyItem {
                            
                            self.eventList += itemlist
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.eventTableView.reloadData()
                        
                    }
                    
                    self.reloadTable()
                    
                } else {
                    
                    HUD.hide()
                    self.reloadTable()
                    
                }
                
                
            })
            
            
        })
        
        
    }
    
    
}
