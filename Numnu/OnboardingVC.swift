//
//  OnboardingVC.swift
//  Numnu
//
//  Created by CZ Ltd on 10/8/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import GoogleMaps


class OnboardingVC: UIViewController {
   
    @IBOutlet var letmeinButtonoutlet: UIButton!
    @IBOutlet var notificationsAlert: ViewExtender!
    @IBOutlet var onboardingText: UILabel!
    var window : UIWindow?
    
    @IBOutlet weak var shadowview: UIView!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.notificationsAlert.frame.origin.y += self.view.frame.height
        shadowview.isHidden = true
    }

    @IBAction func okPressed(_ sender: Any) {
        
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
      
    }
    
    @IBAction func ignorePressed(_ sender: Any) {
        
        notificationsAlert.isHidden = true
        letmeinButtonoutlet.isUserInteractionEnabled = true
        onboardingText.isHidden      = false
        letmeinButtonoutlet.isHidden = false
        
    }
    
    @IBAction func letmeinPressed(_ sender: Any) {
        
        onboardingText.isHidden      = true
        letmeinButtonoutlet.isHidden = true
        UIView.animate(withDuration: 0.5, animations: {
            
            self.notificationsAlert.frame.origin.y -= self.view.frame.height
            self.shadowview.isHidden = false
            
        }, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        
    }
    
    func openStoryBoard(name: String,id : String) {
        
        window         = UIWindow(frame: UIScreen.main.bounds)

        let storyboard                  = UIStoryboard(name: name, bundle: nil)
        let initialViewController       = storyboard.instantiateViewController(withIdentifier: id)
//        self.present(initialViewController, animated: false, completion: nil)
        let wnd = UIApplication.shared.keyWindow
        var options = UIWindow.TransitionOptions()
        options.direction = .toRight
        options.duration = 0.2
        options.style = .easeOut
        wnd?.setRootViewController(initialViewController, options: options)
    }
    

}//class

extension OnboardingVC: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        
        if let location: CLLocation = locations.last {
            
            print("Location: \(location)")
            
            LoadingHepler.instance.show()
            
            let apiclient : ApiClient = ApiClient()
            apiclient.getPlaceGeocode(placeid_Str: "\(location.coordinate.latitude),\(location.coordinate.longitude)", completion: { status,address in
                
                if status == "OK" {
                    
                    PrefsManager.sharedinstance.lastlocation = address
                    PrefsManager.sharedinstance.lastlocationlat = location.coordinate.latitude
                    PrefsManager.sharedinstance.lastlocationlat = location.coordinate.longitude
                    
                }
                
                DispatchQueue.main.async {
                    
                    LoadingHepler.instance.hide()
                    self.openStoryBoard(name: Constants.Main, id: Constants.TabStoryId)
                }
              
             
            })
        
        } else {
            
            self.openStoryBoard(name: Constants.Main, id: Constants.TabStoryId)
        }
    
    
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
            self.openStoryBoard(name: Constants.Main, id: Constants.TabStoryId)
        case .denied:
            print("User denied access to location.")
           self.openStoryBoard(name: Constants.Main, id: Constants.TabStoryId)
            
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
        self.openStoryBoard(name: Constants.Main, id: Constants.TabStoryId)
        print("Error: \(error)")
    }
}

