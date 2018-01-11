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
import Alamofire
import Nuke
import MapKit

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
    var tagarray = [String]()
    
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
    
    
    @IBOutlet weak var bookmarkloclabel: UILabel!
    @IBOutlet weak var shareloclabel: UILabel!
    
    var apiClient     : ApiClient!
    var primaryId     : Int = 0
    
    /**********************share********************************/
    
    lazy var bookmarkid   : Int       = 0
    lazy var bookmarkname : String    = "name"
    lazy var bookmarktype : String    = "empty"
    
    /************************Constraints**********************************/
    
    
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var addressImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var businessEntintyLabelTop: NSLayoutConstraint!
    @IBOutlet weak var busineesEntintScrolTop: NSLayoutConstraint!
    @IBOutlet weak var addressLabelConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarItemFont = UIFont(name: "Avenir-Medium", size: 14)!
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.viewcontrollersCount = 2
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
        
        myscrollView.isHidden = true
        
        apiClient  = ApiClient()
        getLocationIdApi()
        
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
        let vc         = storyboard.instantiateViewController(withIdentifier: "PostImageZoomViewController") as! PostImageZoomViewController
        vc.imagePassed = LocImageView.image!
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
 
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        reloadStripView()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_1 = UIStoryboard(name: Constants.EventDetail, bundle: nil).instantiateViewController(withIdentifier: Constants.EventTabid3) as! ReviewEventViewController
        child_1.popdelegate = self
        child_1.apiType     = "Location"
        child_1.primaryid   = primaryId
        
        let child_2 = UIStoryboard(name: Constants.EventDetail, bundle: nil).instantiateViewController(withIdentifier: Constants.EventTabid2) as! MenuEventViewController
        child_2.menuDelegate = self
        child_2.itemType     = "Location"
        child_2.primayId     = primaryId
        
        return [child_1,child_2]
        
    }
  
    
}

@available(iOS 10.0, *)
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
        
//        openMapBoard()
        openApplemap()
        
    }
    
    func openCompleteMenu(sender:UITapGestureRecognizer) {
        
        let storyboard      = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: Constants.BusinessCompleteId) as! BusinessCompleteViewController
        vc.businessprimaryid = sender.view?.tag ?? 0
        self.navigationController!.pushViewController(vc, animated: true)
        
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
        button2.addTarget(self, action: #selector(EventViewController.openSheet), for: UIControlEvents.touchUpInside)
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
        
        bookmarkid   = 0
        bookmarkname = "name"
        bookmarktype = "empty"
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            
            self.shareView.alpha   = 0
            
        }, completion: nil)
        
    }
    
    func openSheet() {
        
        bookmarkid   = primaryId
        bookmarkname = LocTitleLabel.text ?? "name"
        bookmarktype = "location"
        
        openPopup()
        
    }
    
    func openPopup() {
        
        let Alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let FemaleAction: UIAlertAction = UIAlertAction(title: "Share", style: .default) { _ in
            
            
        }
        let MaleAction: UIAlertAction = UIAlertAction(title: "Bookmark", style: .default) { _ in
            
//            self.getBookmarkToken()
            
        }
        //        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { _ in
        //        }
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")

        Alert.addAction(FemaleAction)
        Alert.addAction(MaleAction)
        Alert.addAction(cancelAction)
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            Alert.popoverPresentationController?.sourceView = self.view
            Alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
            present(Alert, animated: true, completion:nil )
        }else{
            present(Alert, animated: true, completion:nil )
        }
    }
    
    func closePopup() {
        
        bookmarkid   = 0
        bookmarkname = "name"
        bookmarktype = "empty"
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            
            self.shareView.alpha                 = 0
            
        }, completion: nil)
        
    }
    
    func openApplemap(){
        let lat:CLLocationDegrees = (MyVariables.fetchedLat as NSString).doubleValue

        let log:CLLocationDegrees = (MyVariables.fetchedLong as NSString).doubleValue

        
        let regionDistance:CLLocationDistance = 1000;
        let coordinates = CLLocationCoordinate2DMake(lat, log)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.openInMaps(launchOptions: options)
    }//openApplemap
    
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
    
    func popupClick(postid: Int, postname: String) {
        
        bookmarkid   = postid
        bookmarkname = postname
        bookmarktype = "post"
        
        openPopup()
    }
    
    func postTableHeight(height: CGFloat) {
        
        mainContainerView.constant = (buttonBarView.frame.origin.y+64) + height
        mainContainerViewBottom.constant = 0
    }
}



/*******************Item delegate****************************/

extension LocationDetailcontroller : MenuEventViewControllerDelegate {
    
    func menuTableHeight(height: CGFloat) {
        
        mainContainerView.constant = (buttonBarView.frame.origin.y+64) + height
        mainContainerViewBottom.constant = 0
    }
    
}

extension LocationDetailcontroller {
    
    func bookmarkpost(token : String) {
        
        let clientIp  = ValidationHelper.Instance.getIPAddress() ?? "1.0.1"
        let userid    = PrefsManager.sharedinstance.userId
        
        LoadingHepler.instance.show()
        
        let header     : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
        let parameters: Parameters = ["entityid": bookmarkid, "entityname":bookmarkname , "type" : bookmarktype ,"createdby" : userid,"updatedby": userid ,"clientip": clientIp, "clientapp": Constants.clientApp]
        apiClient.bookmarEntinty(parameters: parameters,headers: header, completion: { status,response in
            
            if status == "success" {
                
                DispatchQueue.main.async {
                    
                    LoadingHepler.instance.hide()
                    AlertProvider.Instance.showAlert(title: "Hey!", subtitle: "Bookmarked successfully.", vc: self)
                    self.closePopup()
                }
                
            } else {
                
                LoadingHepler.instance.hide()
                
                if status == "422" {
                    
                    AlertProvider.Instance.showAlert(title: "Hey!", subtitle: "Already bookmarked.", vc: self)
                    
                } else {
                    
                    AlertProvider.Instance.showAlert(title: "Oops!", subtitle: "Bookmark failed.", vc: self)
                    
                }
                
                
            }
            
        })
        
    }
    
    func getBookmarkToken(sender : UITapGestureRecognizer) {
        
        apiClient.getFireBaseToken(completion:{ token in
            
            self.bookmarkpost(token: token)
            
        })
        
    }
    
    
    func getBookmarkToken() {
        
        apiClient.getFireBaseToken(completion:{ token in
            
            self.bookmarkpost(token: token)
            
        })
        
    }
    
    
    
}

extension LocationDetailcontroller {


 func getLocationIdApi() {
    
    LoadingHepler.instance.show()
    
    apiClient.getFireBaseToken(completion: { token in
        
        let header : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
        
        self.apiClient.getLocationsById(id: self.primaryId, headers: header, completion: { status,item in
            
            if status == "success" {
                
                LoadingHepler.instance.hide()
                
                if let itemlist = item {
                    
                    DispatchQueue.main.async {
                        
                        self.getItemDetails(item: itemlist)
                    }
                    
                }
                
                
            } else {
                
                LoadingHepler.instance.hide()
                
                DispatchQueue.main.async {
                    
                    self.myscrollView.isHidden = true
                }
                
                
            }
            
            
        })
        
        
    })
    
}

func getItemDetails(item : LocationModel) {
    
    
    
    /****************Name************************/
    
    if let itemname = item.name {
        
        LocTitleLabel.text = itemname
        
    }
    
    /****************Address************************/
    
    if let itemDes = item.address {
        
        LocAddressLabel.text = itemDes
         
    } else {
        
        addressTopConstraint.constant = 0
        addressImageTopConstraint.constant = 0
        addressLabelConstraint.constant    = 0
    }
    
    /****************Imagee************************/
    
    if let imageList = item.locationimages {
        
        if imageList.count > 0 {
            
            if let url = imageList[imageList.count-1].imageurl {
                
                apiClient.getFireBaseImageUrl(imagepath: url, completion: { imageUrl in
                    
                    if imageUrl != "empty" {
                        
                        Manager.shared.loadImage(with: URL(string : imageUrl)!, into: self.LocImageView)
                    }
                    
                })
                
                
            }
            
            
        }
    }
    
    if let lat = item.lattitude,let long = item.longitude {
        
        if let lat_double = Double(lat),let long_double = Double(long) {
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat_double, longitude: long_double)
            if let itemname = item.name {
                
                marker.title = itemname
                MyVariables.markerTitle = itemname
                
            }
            if let itemDes = item.address {
                
                marker.snippet = itemDes
                MyVariables.address = itemDes
            }
            
           MyVariables.fetchedLat  = lat
           MyVariables.fetchedLong = long
            
           marker.map = mapView
            
        }
        
       
    }
    
 
    
    
    self.myscrollView.isHidden = false
    
    /****************Business Entity************************/
    
    if let entinty = item.business {
        
        businessEntityView.tag = entinty.id ?? 0
        
        if let entintyname = entinty.businessname {
            
            businessEntityNameLabel.text = entintyname
            
        } else {
            
            busineesEntintScrolTop.constant = 0
        }
        
        if let itemTag = entinty.taglist {
            
            if itemTag.count > 0 {
                
                tagarray.removeAll()
                
                for tag in itemTag {
                    
                    tagarray.append(tag.text_str ?? "")
                    
                }
                
                entitytagUpdate()
            }
            
            
        }
        
        
        /****************Business Entity image************************/
        
        if let entintyimgaelist = entinty.imagelist {
            
            if entintyimgaelist.count > 0 {
                
                if let url = entintyimgaelist[entintyimgaelist.count-1].imageurl_str {
                    
                    apiClient.getFireBaseImageUrl(imagepath: url, completion: { imageUrl in
                        
                        if imageUrl != "empty" {
                            
                            Manager.shared.loadImage(with: URL(string : imageUrl)!, into: self.businessEntityImage)
                        }
                        
                    })
                    
                    
                }
                
                
            }
            
        }
        
        
    }
  
    
}


}


