//
//  LocationDetailcontroller.swift
//  Numnu
//
//  Created by CZ Ltd on 11/1/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import GoogleMaps

class LocationDetailcontroller: ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var LocImageView: ImageExtender!
    @IBOutlet weak var LocTitleLabel: UILabel!
    @IBOutlet weak var myscrollView: UIScrollView!
    
    @IBOutlet weak var LocAddressLabel: UILabel!
    
    @IBOutlet weak var TabBarView: ButtonBarView!
    @IBOutlet weak var pagerView: UIScrollView!
    
    
    @IBOutlet weak var navigationItemList: UINavigationItem!
    
    @IBOutlet weak var mainContainerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var mainContainerView: NSLayoutConstraint!
    var tagarray = ["Festival","Wine","Party"]
    
    @IBOutlet weak var shareView: UIView!
    /***************Map and business view*********************/
    
    @IBOutlet weak var businessEntityImage: ImageExtender!
    @IBOutlet weak var mapview : UIView!
    @IBOutlet weak var businessEntityView : UIView!
    @IBOutlet weak var businessEntityNameLabel: UILabel!
    @IBOutlet weak var businessEntityScrollview : UIScrollView!
    
    @IBOutlet weak var maplabel: UILabel!
    /**********************Location cordinates***********************************/
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var zoomLevel: Float = 15.0
    
    var latitude   : CLLocationDegrees = 45.511278
    var longtitude : CLLocationDegrees = -73.565778
    
    override func viewDidLoad() {
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarItemFont = UIFont(name: "Avenir-Medium", size: 14)!
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        super.viewDidLoad()
        
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = UIColor.appBlackColor()
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        buttonBarView.selectedBar.backgroundColor = UIColor.appThemeColor()
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.textlightDark()
            newCell?.label.textColor = UIColor.appBlackColor()
            
        }
        
        
        let centerImagetap = UITapGestureRecognizer(target: self, action: #selector(EventViewController.centerImagetap))
        LocImageView.addGestureRecognizer(centerImagetap)
        LocImageView.isUserInteractionEnabled = true
        /**********************Location cordinates***********************************/
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
            
        {
            locationManager.distanceFilter = 50
            locationManager.startUpdatingLocation()
            locationManager.delegate = self
            
        }
        
        
        /**********************set Nav bar****************************/
        
        setNavBar()
        
        entitytagUpdate()
        
        /****************event label tap function************************/
        
        tapRegistration()
        alertTapRegister()
       
        setMap()
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let navigationOnTap = UITapGestureRecognizer(target: self, action: #selector(LocationDetailcontroller.navigationTap))
        self.navigationController?.navigationBar.addGestureRecognizer(navigationOnTap)
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    func navigationTap(){
        let offset = CGPoint(x: 0,y :0)
        self.myscrollView.setContentOffset(offset, animated: true)
        
    }
    
    func centerImagetap(){
        
        let storyboard = UIStoryboard(name: "PostDetail", bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "PostImageZoomViewController")
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
 
        let desiredOffset = CGPoint(x: -1, y: 0)
        pagerView.setContentOffset(desiredOffset, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_1 = UIStoryboard(name: Constants.EventDetail, bundle: nil).instantiateViewController(withIdentifier: Constants.EventTabid3) as! ReviewEventViewController
        child_1.popdelegate = self
        let child_2 = UIStoryboard(name: Constants.EventDetail, bundle: nil).instantiateViewController(withIdentifier: Constants.EventTabid2) as! MenuEventViewController
        child_2.menuDelegate = self
        return [child_1,child_2]
        
    }
    
    
    
    
}

extension LocationDetailcontroller {
    
    /****************etap function************************/
    
    func tapRegistration() {
        
        let completemenuTap = UITapGestureRecognizer(target: self, action: #selector(BusinessDetailViewController.openCompleteMenu(sender:)))
        businessEntityView.isUserInteractionEnabled = true
        businessEntityView.addGestureRecognizer(completemenuTap)
        
        let maptap = UITapGestureRecognizer(target: self, action: #selector(LocationDetailcontroller.mapRedirect(sender:)))
        maplabel.isUserInteractionEnabled = true
        maplabel.addGestureRecognizer(maptap)
        
    }
    
    func mapRedirect(sender:UITapGestureRecognizer) {
        
        openMapBoard()
    }
    
    func openCompleteMenu(sender:UITapGestureRecognizer) {
        
        openStoryBoard()
        
    }
    
    func entitytagUpdate() {
        
        var expandableWidth : CGFloat = 0
        
        for (i,text) in tagarray.enumerated() {
            
            let textLabel : UILabel = UILabel()
            let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: text, fontname: "Avenir-Medium", size: 12)
            textLabel.font = UIFont(name: "Avenir-Medium", size: 12)
            textLabel.text = text
            textLabel.backgroundColor  = UIColor.tagBgColor()
            textLabel.textColor        = UIColor.tagTextColor()
            textLabel.layer.cornerRadius  = 4
            textLabel.layer.masksToBounds = true
            textLabel.textAlignment   = .center
            
            if i == 0 {
                
                textLabel.frame = CGRect(x: 0, y: 0, width: textSize.width+20, height: 22)
                
            } else {
                
                textLabel.frame = CGRect(x: expandableWidth, y: 0, width: textSize.width+20, height: 22)
                
            }
            
            expandableWidth += textSize.width+30
            businessEntityScrollview.addSubview(textLabel)
            
        }
        
        businessEntityScrollview.contentSize = CGSize(width: expandableWidth, height: 0)
        businessEntityScrollview.isScrollEnabled = true
  
    }
    
    /******************Set navigation bar**************************/
    
    func setNavBar() {
        
        navigationItemList.title = "Location"
        
        let button: UIButton = UIButton(type: UIButtonType.custom)
        //set image for button
        button.setImage(UIImage(named: "ic_arrow_back"), for: UIControlState.normal)
        //add function for button
        button.addTarget(self, action: #selector(EventViewController.backButtonClicked), for: UIControlEvents.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        
        let button2 : UIButton = UIButton(type: UIButtonType.custom)
        //set image for button
        button2.setImage(UIImage(named: "eventDots"), for: UIControlState.normal)
        //add function for button
        button2.addTarget(self, action: #selector(EventViewController.openPopup), for: UIControlEvents.touchUpInside)
        //set frame
        button2.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(customView: button)
        let rightButton = UIBarButtonItem(customView: button2)
        
        // Create two buttons for the navigation item
        navigationItemList.leftBarButtonItem  = leftButton
        navigationItemList.rightBarButtonItem = rightButton
        
        
    }
    
    func setMap() {
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longtitude, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: mapview.bounds, camera: camera)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        mapview.addSubview(mapView)
        //        mapView.isHidden = true
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        marker.title = "BOUILLON BILK"
        marker.snippet = "1595 St Laurent Blvd, Montreal, QC H2X 2S9, Canada"
        marker.map = mapView
        
        
        
    }
    
    func backButtonClicked() {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func openStoryBoard () {
        
        let storyboard      = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: Constants.BusinessCompleteId)
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    func openMapBoard () {
        
        let storyboard      = UIStoryboard(name: Constants.Event, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: Constants.MapStoryId) as! EventMapViewController
        vc.boolForMapTitle = false
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    func alertTapRegister() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closePopup(sender:)))
        self.shareView.addGestureRecognizer(tap)
        
    }
    
    func closePopup(sender : UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            
            self.shareView.alpha                 = 0
            
        }, completion: nil)
        
    }
    
    func openPopup() {
        
        self.shareView.alpha   = 1
        
        let top = CGAffineTransform(translationX: 0, y: 0)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            self.shareView.isHidden = false
            self.shareView.transform = top
            
        }, completion: nil)
        
        
    }
    
}

extension LocationDetailcontroller : CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        DispatchQueue.main.async {
            
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: self.zoomLevel)
          
//            if self.mapView.isHidden {
//                self.mapView.isHidden = false
//                self.mapView.camera = camera
//            } else {
//                self.mapView.animate(to: camera)
//            }
            
        }
        
        
        
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

extension LocationDetailcontroller : ReviewEventViewControllerDelegate {
    
    func popupClick() {
        
        openPopup()
    }
    
    func postTableHeight(height: CGFloat) {
        
        mainContainerView.constant = 667 + height
        mainContainerViewBottom.constant = 0
    }
}



/*******************Item delegate****************************/

extension LocationDetailcontroller : MenuEventViewControllerDelegate {
    
    func menuTableHeight(height: CGFloat) {
        
        mainContainerView.constant = 667 + height
        mainContainerViewBottom.constant = 0
    }
    
}

