//
//  EventMapViewController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/25/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import GoogleMaps

class EventMapViewController: UIViewController {
    var boolForMapTitle: Bool = true
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var zoomLevel: Float = 15.0
    @IBOutlet weak var navigationItemList: UINavigationItem!
    var myDouble = Double(MyVariables.fetchedLat)

    var latitude   : CLLocationDegrees = (MyVariables.fetchedLat as NSString).doubleValue
    var longtitude : CLLocationDegrees = (MyVariables.fetchedLong as NSString).doubleValue
//    var latitude   = 40.741895
//    var longtitude = -73.989308
    var markerAddress = MyVariables.address
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBar()
        setMap()
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    
        self.tabBarController?.tabBar.isHidden = true
     
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /******************Set navigation bar**************************/
    
    func setMap() {
      
        let camera = GMSCameraPosition.camera(withLatitude: self.latitude, longitude: self.longtitude, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
//        mapView.isHidden = true
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longtitude)
        marker.title    = MyVariables.markerTitle
        if MyVariables.address != "" {
            marker.snippet  = MyVariables.address
        }
        marker.map = mapView
        
        
        
    }
    
    func setNavBar() {
        if boolForMapTitle == true{
            navigationItemList.title = "Event Map"

        }else{
            navigationItemList.title = "Location Map"

        }
        
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
        navigationItemList.leftBarButtonItem = leftButton
        navigationItemList.rightBarButtonItem = rightButton
        
        
    }
    
    func backButtonClicked() {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    

   
}

extension EventMapViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        
        if let location: CLLocation = locations.last {
            
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.latitude,
                                                  zoom: self.zoomLevel)
            let marker = GMSMarker()
            marker.position        = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.latitude)
            marker.appearAnimation = .pop
            marker.title           = "Current Location"
            marker.snippet         = ""
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
            if CLLocationManager.locationServicesEnabled()
            {
                self.locationManager.distanceFilter = 50
                self.locationManager.startUpdatingLocation()
                
            }
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

