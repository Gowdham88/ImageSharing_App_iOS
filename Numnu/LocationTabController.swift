//
//  LocationTabController.swift
//  Numnu
//
//  Created by CZ Ltd on 11/1/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip

protocol  LocationTabControllerDelegate {
    
    func locationTableHeight(height : CGFloat)
    
}

class LocationTabController: UIViewController,IndicatorInfoProvider {

    @IBOutlet weak var locationTableView: UITableView!
    var locationdelegate : LocationTabControllerDelegate?
    var viewState        : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTableView.delegate   = self
        locationTableView.dataSource = self
        locationTableView.isScrollEnabled = false
//        let navigationOnTap = UITapGestureRecognizer(target: self, action: #selector(LocationTabController.navigationTap))
//        self.navigationController?.navigationBar.addGestureRecognizer(navigationOnTap)
//        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let navigationOnTap = UITapGestureRecognizer(target:self,action:#selector(EventViewController.navigationTap))
        self.navigationController?.navigationBar.addGestureRecognizer(navigationOnTap)
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    func navigationTap(){
        let offset = CGPoint(x: 0,y :0)
        self.locationTableView.setContentOffset(offset, animated: true)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        viewState = true
        locationTableView.reloadData()
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
        
       
        openStoryBoard()
        
    }
    
    func  openStoryBoard() {
        
        let storyboard = UIStoryboard(name: Constants.LocationDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.LocationDetailId)
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        if indexPath.row == lastRowIndex - 1 && viewState {
            locationdelegate?.locationTableHeight(height: locationTableView.contentSize.height)
            viewState = false
        }
    }
    
    
}
