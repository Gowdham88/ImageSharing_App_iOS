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
    
    @IBOutlet weak var LocAddressLabel: UILabel!
    
    @IBOutlet weak var TabBarView: ButtonBarView!
    @IBOutlet weak var pagerView: UIScrollView!
    
    
    @IBOutlet weak var navigationItemList: UINavigationItem!
    
    @IBOutlet weak var mainContainerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var mainContainerView: NSLayoutConstraint!
    var tagarray = ["Festival","Wine","Party"]
    
   /***************Map and business view*********************/
    
    @IBOutlet weak var businessEntityImage: ImageExtender!
    @IBOutlet weak var mapview : UIView!
    @IBOutlet weak var businessEntityView : UIView!
    @IBOutlet weak var businessEntityNameLabel: UILabel!
    @IBOutlet weak var businessEntityScrollview : UIScrollView!
    
    /**********************Location cordinates***********************************/
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var zoomLevel: Float = 15.0
    
    override func viewDidLoad() {
        settings.style.selectedBarHeight = 3.0
        super.viewDidLoad()
        
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = UIColor.appBlackColor()
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        buttonBarView.selectedBar.backgroundColor = UIColor.appThemeColor()
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.textlightDark()
            newCell?.label.textColor = UIColor.appBlackColor()
            
        }
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
        
        /******************checking iphone device****************************/
        
        if self.view.frame.height <= 568 {
            
            mainContainerView.constant       = 850
            mainContainerViewBottom.constant = 0
            
        }
        
        setMap()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_1 = UIStoryboard(name: Constants.EventDetail, bundle: nil).instantiateViewController(withIdentifier: Constants.EventTabid3)
        let child_2 = UIStoryboard(name: Constants.ItemDetail, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid7)
        return [child_1,child_2]
        
    }
    
    
}

extension LocationDetailcontroller {
    
    /****************etap function************************/
    
    func tapRegistration() {
        
        let completemenuTap = UITapGestureRecognizer(target: self, action: #selector(BusinessDetailViewController.openCompleteMenu(sender:)))
        businessEntityView.isUserInteractionEnabled = true
        businessEntityView.addGestureRecognizer(completemenuTap)
        
    }
    
    func openCompleteMenu(sender:UITapGestureRecognizer) {
        
        openStoryBoard()
        
    }
    
    func entitytagUpdate() {
        
        var expandableWidth : CGFloat = 0
        
        for (i,text) in tagarray.enumerated() {
            
            let textLabel : UILabel = UILabel()
            let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: text, fontname: "AvenirNext-Regular", size: 15)
            textLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
            textLabel.text = text
            textLabel.backgroundColor  = UIColor.tagBgColor()
            textLabel.textColor        = UIColor.tagTextColor()
            textLabel.layer.cornerRadius = 10
            textLabel.layer.masksToBounds = true
            textLabel.textAlignment = .center
            
            if i == 0 {
                
                textLabel.frame = CGRect(x: 0, y: 0, width: textSize.width+20, height: 30)
                
            } else {
                
                textLabel.frame = CGRect(x: expandableWidth, y: 0, width: textSize.width+20, height: 30)
                
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
        
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(customView: button)
        
        let rightButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        // Create two buttons for the navigation item
        navigationItemList.leftBarButtonItem  = leftButton
        navigationItemList.rightBarButtonItem = rightButton
        
        
    }
    
    func setMap() {
        
        let camera = GMSCameraPosition.camera(withLatitude: 45.5017, longitude: -73.5673, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        mapview.addSubview(mapView)
        //        mapView.isHidden = true
        
        
        
    }
    
    func backButtonClicked() {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func openStoryBoard () {
        
        let storyboard      = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: Constants.BusinessCompleteId)
        self.navigationController!.pushViewController(vc, animated: true)
        
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
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            marker.appearAnimation = .pop
            marker.title = "Current location"
            marker.snippet = ""
            marker.map = self.mapView
            
            if self.mapView.isHidden {
                self.mapView.isHidden = false
                self.mapView.camera = camera
            } else {
                self.mapView.animate(to: camera)
            }
            
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
