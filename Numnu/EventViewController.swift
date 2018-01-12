//
//  EventViewController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/16/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import SwiftyJSON
import MapKit
import Nuke
import NVActivityIndicatorView
import GoogleMaps




struct MyVariables {
    
    static var fetchedLat  = String()
    static var fetchedLong = String()
    static var markerTitle = String()
    static var address     = String()
    static var link1 = String()
    static var link2 = String()
    static var link3 = String()
    
}
class EventViewController: ButtonBarPagerTabStripViewController {
    
    var token_str     : String = "empty"
    var apiClient     : ApiClient!
    var description_txt : String = ""
    var eventprimaryid  : Int    = 34
    
//    @IBOutlet weak var descriptionTopToWeblink1: NSLayoutConstraint!
    @IBOutlet weak var weblinkIcon1TopToEventmapIcon: NSLayoutConstraint!
    @IBOutlet weak var weblink2IconTopToweblinkIcon1: NSLayoutConstraint!
    @IBOutlet weak var weblink1TopToEventmap: NSLayoutConstraint!
//    @IBOutlet weak var descriptionTopToEventmap: NSLayoutConstraint!
    @IBOutlet weak var weblink3IconHeight: NSLayoutConstraint!
    @IBOutlet weak var weblink2IconHeight: NSLayoutConstraint!
    @IBOutlet weak var weblink1IconHeight: NSLayoutConstraint!
    @IBOutlet weak var mapIconTopToLocationIcon: NSLayoutConstraint!
    @IBOutlet weak var eventMapTopToLocationname: NSLayoutConstraint!
//    @IBOutlet weak var weblink3TopToLocationame: NSLayoutConstraint!
    @IBOutlet weak var mapIconTopToDateIcon: NSLayoutConstraint!
    @IBOutlet weak var dateIconHeight: NSLayoutConstraint!
    @IBOutlet weak var dateLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var mapLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var mapIconHeight: NSLayoutConstraint!
    @IBOutlet weak var locationIconHeight: NSLayoutConstraint!
    @IBOutlet weak var locationLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var weblink3Height: NSLayoutConstraint!
    @IBOutlet weak var weblink2Height: NSLayoutConstraint!
    @IBOutlet weak var weblink1Height: NSLayoutConstraint!
    @IBOutlet weak var dateIconTopToEventname: NSLayoutConstraint!
    @IBOutlet weak var dateTopToEventname: NSLayoutConstraint!
    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var descriptionTopcostraintToWeblink2: NSLayoutConstraint!
    @IBOutlet weak var descriptionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var weblink3TopConstraint: NSLayoutConstraint!
    @IBOutlet weak var weblink2TopConstraint: NSLayoutConstraint!
    @IBOutlet weak var myscrollView: UIScrollView!
    @IBOutlet weak var eventImageView: ImageExtender!
    @IBOutlet weak var eventTitleLabel: UILabel!
    
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventPlaceLabel: UILabel!
    @IBOutlet weak var eventMap: UILabel!
    @IBOutlet var eventMapIcon: UIImageView!
    
    
    @IBOutlet weak var EventLinkLabel1: UILabel!
    @IBOutlet weak var eventLinkLabel2: UILabel!
    @IBOutlet weak var eventLinkLabel3: UILabel!
    
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    
    
    @IBOutlet weak var TabBarView: ButtonBarView!
    @IBOutlet weak var pagerView: UIScrollView!
    @IBOutlet weak var tagScrollView: UIScrollView!
    
    @IBOutlet weak var navigationItemList: UINavigationItem!
    
    @IBOutlet weak var mainContainerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var mainContainerView: NSLayoutConstraint!
    var tagarray = [String]()
    @IBOutlet weak var shareView: UIView!
    /***************contraints***********************/
    
    @IBOutlet weak var eventDescriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var containerViewTop: NSLayoutConstraint!
    @IBOutlet weak var barButtonTop: NSLayoutConstraint!
    
    /***************Read more variable*********************/
    
    var isLabelAtMaxHeight = false
    var contentHeignt      = 649
    
    /**********************share label********************************/
    
    @IBOutlet weak var sharelabel: UILabel!
    @IBOutlet weak var bookmarklabel: UILabel!
    
    /**********************share********************************/
    
    lazy var bookmarkid   : Int       = 0
    lazy var bookmarkname : String    = "name"
    lazy var bookmarktype : String    = "empty"
    
    
    override func viewDidLoad() {
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarItemFont = UIFont(name: "Avenir-Medium", size: 14)!
        settings.style.viewcontrollersCount = 3
        super.viewDidLoad()
        myscrollView.delegate = self
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = UIColor.appBlackColor()
        settings.style.viewcontrollersCount = (self.view.frame.size.width / 3) - 10;
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarHeight = 1
        buttonBarView.selectedBar.backgroundColor = UIColor.appThemeColor()
        buttonBarView.moveTo(index: 0, animated: true, swipeDirection: .none, pagerScroll: .yes)
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.textlightDark()
            newCell?.label.textColor = UIColor.appBlackColor()
        
        }

        let centerImagetap = UITapGestureRecognizer(target: self, action: #selector(EventViewController.centerImagetap))
        eventImageView.addGestureRecognizer(centerImagetap)
        eventImageView.isUserInteractionEnabled = true
    
        /**********************set Nav bar****************************/
        
        setNavBar()
        alertTapRegister()

        /****************event label tap function************************/
        
        tapRegistration()
        myscrollView.isHidden = true
        
        apiClient = ApiClient()
        
        getFirebaseToken()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Light", size: 16)!]

        let navigationOnTap = UITapGestureRecognizer(target:self,action:#selector(EventViewController.navigationTap))
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
        vc.imagePassed = eventImageView.image!
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_1 = UIStoryboard(name: Constants.EventDetail, bundle: nil).instantiateViewController(withIdentifier: Constants.EventTabid1) as! BusinessEventViewController
        child_1.showentity      = true
        child_1.businesdelegate = self
        child_1.primaryId       = eventprimaryid
        
        let child_2 = UIStoryboard(name: Constants.EventDetail, bundle: nil).instantiateViewController(withIdentifier: Constants.EventTabid2) as! MenuEventViewController
        child_2.showentity   = true
        child_2.menuDelegate = self
        child_2.itemType     = "Event"
        child_2.primayId     = eventprimaryid
        
        let child_3 = UIStoryboard(name: Constants.EventDetail, bundle: nil).instantiateViewController(withIdentifier: Constants.EventTabid3) as! ReviewEventViewController
        child_3.popdelegate = self
        child_3.apiType     = "Event"
        child_3.primaryid   = eventprimaryid
        return [child_1,child_2,child_3]
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.tabBarController?.tabBar.isHidden = false
        reloadStripView()
       
    }
    

    @IBAction func ButtonReadMore(_ sender: UIButton) {
        
        if isLabelAtMaxHeight {
            
            readMoreButton.setTitle("more", for: .normal)
            isLabelAtMaxHeight = false
            eventDescriptionHeight.constant = 75
            
            
        } else {
            
            readMoreButton.setTitle("less", for: .normal)
            isLabelAtMaxHeight = true
            eventDescriptionHeight.constant = TextSize.sharedinstance.getLabelHeight(text: description_txt, width: eventDescriptionLabel.frame.width, font: eventDescriptionLabel.font)
           
        }
        
        
    }
    

}

extension EventViewController {
    
    /****************event label tap function************************/
    
    func tapRegistration() {
        
        let link1 = UITapGestureRecognizer(target: self, action: #selector(EventViewController.webLink1(sender:)))
        EventLinkLabel1.isUserInteractionEnabled = true
        EventLinkLabel1.addGestureRecognizer(link1)
        
        let link2 = UITapGestureRecognizer(target: self, action: #selector(EventViewController.webLink2(sender:)))
        eventLinkLabel2.isUserInteractionEnabled = true
        eventLinkLabel2.addGestureRecognizer(link2)
        
        let link3 = UITapGestureRecognizer(target: self, action: #selector(EventViewController.webLink1(sender:)))
        eventLinkLabel3.isUserInteractionEnabled = true
        eventLinkLabel3.addGestureRecognizer(link3)
        
        let maptap = UITapGestureRecognizer(target: self, action: #selector(EventViewController.mapRedirect(sender:)))
        eventMap.isUserInteractionEnabled = true
        eventMap.addGestureRecognizer(maptap)
        
        let maptapIcon = UITapGestureRecognizer(target: self, action: #selector(EventViewController.mapRedirect(sender:)))
        eventMapIcon.isUserInteractionEnabled = true
        eventMapIcon.addGestureRecognizer(maptapIcon)
        
    }
    
    func webLink1(sender:UITapGestureRecognizer) {
    
        openWebBoard(url: MyVariables.link1)

    }
    
    func webLink2(sender:UITapGestureRecognizer) {
        
        openWebBoard(url: MyVariables.link2)
        
    }
    
    func webLink3(sender:UITapGestureRecognizer) {
        
        openWebBoard(url: MyVariables.link3)
      // "http://www.totc.ca"
    }
    
    func mapRedirect(sender:UITapGestureRecognizer) {
        
//        openMapBoard()
          openApplemap()
    }
    
    /*************************Tag view updating************************************/
    
    func tagViewUpdate() {
        
        var expandableWidth : CGFloat = 0
        let textLabel : UILabel = UILabel()

        for (i,text) in tagarray.enumerated() {
            
            let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: text, fontname: "Avenir-Medium", size: 12)
            textLabel.font = UIFont(name: "Avenir-Medium", size: 12)
            textLabel.text = text
            textLabel.backgroundColor  = UIColor.tagBgColor()
            textLabel.textColor        = UIColor.tagTextColor()
    
            textLabel.layer.cornerRadius = 4
            textLabel.layer.masksToBounds = true
            textLabel.textAlignment = .center

            if i == 0 {
                
                textLabel.frame = CGRect(x: 0, y: 0, width: textSize.width+20, height: 22)
                
            } else {
                
                textLabel.frame = CGRect(x: expandableWidth, y: 0, width: textSize.width+20, height: 22)
                
            }
            expandableWidth += textSize.width+30
            tagScrollView.addSubview(textLabel) 
           
        }
        
        tagScrollView.contentSize = CGSize(width: expandableWidth, height: 0)
        tagScrollView.isScrollEnabled = true
     
        
    }
    
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
  
    
    func backButtonClicked() {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func openWebBoard (url: String) {
      
        let storyboard      = UIStoryboard(name: Constants.Event, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: Constants.WebViewStoryId) as! WebViewController
        vc.url_str          = url
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    func openMapBoard () {
        
        let storyboard      = UIStoryboard(name: Constants.Event, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: Constants.MapStoryId) as! EventMapViewController
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    func openApplemap(){
       //apple map
        let lat1:CLLocationDegrees = (MyVariables.fetchedLat as NSString).doubleValue
        let log1:CLLocationDegrees = (MyVariables.fetchedLong as NSString).doubleValue

//        var latitude   : CLLocationDegrees = (MyVariables.fetchedLat as NSString).doubleValue
//        let regionDistance:CLLocationDistance = 1000;
//        let coordinates = CLLocationCoordinate2DMake(lat1, log1)
//        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
//
//
//        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
//
//        let placemark = MKPlacemark(coordinate: coordinates)
//        let mapItem = MKMapItem(placemark: placemark)
//        mapItem.openInMaps(launchOptions: options)
//
//        //google map
////        let lat = (MyVariables.fetchedLat as NSString).doubleValue
////        let lon = (MyVariables.fetchedLong as NSString).doubleValue
//
//        let camera = GMSCameraPosition.camera(withLatitude: lat1, longitude: log1, zoom: 14)
//        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
//
//        let marker = GMSMarker()
//        marker.position = camera.target
//        marker.snippet = "location"
//        marker.appearAnimation = GMSMarkerAnimation.pop
//        marker.map = mapView

//        view = mapView
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            
            UIApplication.shared.openURL(NSURL(string:
                "comgooglemaps://?center=\(Float(lat1)),\(Float(log1))&zoom=14&views=traffic")! as URL)
//            UIApplication.shared.openURL(NSURL(string:
//                "comgooglemaps://?center=40.765819,-73.975866&zoom=14&views=traffic")! as URL)
            
            
        } else {
            // if GoogleMap App is not installed
            UIApplication.shared.openURL(NSURL(string:
                "http://maps.apple.com/?ll=\(Float(lat1)),\(Float(log1))")! as URL)
            
//            "http://maps.apple.com/?ll=\(Float(lat1)),\(Float(log1))")!
        }

        
        
    }//openApplemap
    
    func alertTapRegister() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closePopup(sender:)))
        self.shareView.addGestureRecognizer(tap)
        
        let bookmarktap = UITapGestureRecognizer(target: self, action: #selector(self.getBookmarkToken(sender:)))
        self.bookmarklabel.addGestureRecognizer(bookmarktap)
        
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
        
        bookmarkid   = eventprimaryid
        bookmarkname = eventTitleLabel.text ?? "name"
        bookmarktype = "event"
        
        openPopup()
        
    }
    
    


    
    func openPopup() {
        
        let Alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let FemaleAction: UIAlertAction = UIAlertAction(title: "Share", style: .default) { _ in
            
            let title = "Numnu"
            let textToShare = "Discover and share experiences with food and drink at events and festivals."
            let urlToShare = NSURL(string: "https://itunes.apple.com/ca/app/numnu/id1231472732?mt=8")

            let objectsToShare = [title, textToShare, urlToShare!] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
            
            
            
            
        }
        let MaleAction: UIAlertAction = UIAlertAction(title: "Bookmark", style: .default) { _ in
            
           self.getBookmarkToken()
            
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
    
}

/*************Post Delegate****************/

extension EventViewController : ReviewEventViewControllerDelegate {
   
    func postTableHeight(height: CGFloat) {
     
        mainContainerView.constant = (buttonBarView.frame.origin.y+64) + height
        mainContainerViewBottom.constant = 0
    }
    
    func popupClick(postid: Int, postname: String) {
        
        bookmarkid   = postid
        bookmarkname = postname
        bookmarktype = "post"
        
        openPopup()
    }
    
   
}


/*******************Business delegate****************************/

extension EventViewController : BusinessEventViewControllerDelegate {
    
    func BusinessTableHeight(height: CGFloat) {
        
        mainContainerView.constant = (buttonBarView.frame.origin.y+64) + height
        mainContainerViewBottom.constant = 0
    }
    
    
}

extension EventViewController : MenuEventViewControllerDelegate {
    
    func menuTableHeight(height: CGFloat) {
        
        mainContainerView.constant = (buttonBarView.frame.origin.y+64) + height
        mainContainerViewBottom.constant = 0
    }
    
}

extension EventViewController {
    
    func getFirebaseToken() {
        
        apiClient.getFireBaseToken(completion:{ token in
            
            self.token_str = token
            self.MethodToCallApi()
            
        })
        
    }
    
    func MethodToCallApi() {
       
        LoadingHepler.instance.show()
        let header     : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token_str)"]
        
        apiClient.getEventsDetailsApi(id : eventprimaryid,headers: header, completion: { status,Values in
            
            if status == "success" {
                if let response = Values {
                    
                    LoadingHepler.instance.hide()
                    
                    DispatchQueue.main.async {
                        
                        self.getDetails(response:response)
                        
                    }
                    
                }
                
            } else {
                print("json respose failure:::::::")
                LoadingHepler.instance.hide()
                
                DispatchQueue.main.async {
                    
                    self.myscrollView.isHidden = true
                    
                }
                
            }
        })
    }
    func getDetails(response:EventList) {
        
        if let name = response.name {
            eventTitleLabel.text = name
        }
        
        if let description = response.description {
            eventDescriptionLabel.text = description
        }
        
        if let startsat = response.startsat {
            print(startsat)
            if response.startsat != nil {
                dateLabelHeight.constant = 20
                dateIconHeight.constant  = 13
            }else{
                dateLabelHeight.constant = 0
                dateIconHeight.constant  = 0
            }
        }
        
        if let endsat = response.endsat {
            
            if response.endsat != "" {
               
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let date = formatter.date(from: endsat)
                let date2 = formatter.date(from: response.startsat!)
                
                formatter.dateFormat = "MMM dd, h:mm a"
                let dateString = formatter.string(from: date!)
                let dateString2 = formatter.string(from: date2!)
                eventDateLabel.text = dateString2 + " - " + dateString
                print("datestring:::::",dateString,dateString2)
            }
        }else{
            dateLabelHeight.constant = 0
            dateIconHeight.constant  = 0
            mapIconTopToDateIcon.constant = 5
       
        }
        
        
        if let eventLinkList = response.eventLinkList {
            if eventLinkList.count > 0 {
//                weblink1TopToEventmap.constant = 5
//                weblink2TopConstraint.constant = 5
//                weblinkIcon1TopToEventmapIcon.constant = 5
//                weblink2IconTopToweblinkIcon1.constant = 5
                if let weblink1 = eventLinkList[0].weblink {
                    EventLinkLabel1.text    = eventLinkList[0].linktext
                    MyVariables.link1       = weblink1
                }
                if eventLinkList.count > 1 {
                    if let weblink2 = eventLinkList[1].weblink {
                        eventLinkLabel2.text    = eventLinkList[1].linktext
                        MyVariables.link2       = weblink2

//                        weblink1TopToEventmap.constant = 10
                    }
                }else{
                    weblink2Height.constant     = 0
                    weblink2IconHeight.constant = 0
//                    descriptionTopToWeblink1.constant = 5
//                    weblink1TopToEventmap.constant = 0
                }
              
                
               
//                if let weblink3 = eventLinkList[2].weblink {
//                    eventLinkLabel3.text = eventLinkList[2].linktext
//                    MyVariables.link3    = weblink3
//                    weblink3Height.constant = 20
//
//                }
            }else {
                weblink1Height.constant     = 0
                weblink1IconHeight.constant = 0
                weblink2IconHeight.constant = 0
                weblink3IconHeight.constant = 0
                weblink2Height.constant     = 0
                weblink3Height.constant     = 0
            }
            
            if eventLinkList.count > 2 {
                if let weblink3 = eventLinkList[2].weblink {
                    eventLinkLabel3.text   = eventLinkList[2].linktext
                    MyVariables.link3      = weblink3
                }
            }else{
                weblink3Height.constant     = 0
                weblink3IconHeight.constant = 0
//                descriptionTopcostraintToWeblink2.constant = 3

//                descriptionTopcostraintToWeblink2.constant = -15
//                weblink1TopToEventmap.constant = 10
//                weblink2TopConstraint.constant = -20
//                weblinkIcon1TopToEventmapIcon.constant = 12
//                weblink2IconTopToweblinkIcon1.constant = 11
//                weblink1TopToEventmap.constant = 9
//                eventMapTopToLocationname.constant = 6
            }
        }else{
            weblink1Height.constant     = 0
            weblink1IconHeight.constant = 0
            weblink2IconHeight.constant = 0
            weblink3IconHeight.constant = 0
            weblink2Height.constant     = 0
            weblink3Height.constant     = 0
//            descriptionTopToEventmap.constant = 0
        }
        
        
        if let taglist = response.taglist {
           dateIconTopToEventname.constant = 40
            dateTopToEventname.constant    = 37
            tagarray.removeAll()
            if taglist.count > 0 {
                for item in taglist {
                    
                        tagarray.append(item.text_str ?? "")
                        print("tags::::",tagarray)
                    tagViewUpdate()

                }
            }
        }else{
            dateIconTopToEventname.constant = 8
            dateTopToEventname.constant     = 5
            

        }
        
        if let loclist = response.loclist {
            if response.loclist != nil {
              
                if let Eplace     = loclist.name_str {
                    eventPlaceLabel.text    = Eplace
                }
                if let Elat       = loclist.lattitude_str {
                    MyVariables.fetchedLat  = Elat
                }
                if let Elon       = loclist.longitude_str {
                    MyVariables.fetchedLong = Elon
                }
                if let Etitle     = loclist.name_str {
                    MyVariables.markerTitle = Etitle
                }
                if let addressval = loclist.address_str {
                    MyVariables.address = addressval
                }
            }
        }else{
            locationLabelHeight.constant = 0
            locationIconHeight.constant  = 0
            
            mapLabelHeight.constant  = 0
            mapIconHeight.constant   = 0
        }
        
        if let imglist = response.imagelist {
            if imglist.count > 0 {
                if let url = imglist[imglist.count-1].imageurl_str {
                    apiClient.getFireBaseImageUrl(imagepath: url, completion: { imageUrl in
                        if imageUrl != "empty" {
                            Manager.shared.loadImage(with: URL(string : imageUrl)!, into: self.eventImageView)
                        }
                    })
                }
            }
        }
        
        /****************Checking number of lines************************/
        
        if (eventDescriptionLabel.numberOfVisibleLines > 4) {
            
            readMoreButton.isHidden = false
            
        } else {
            readMoreButton.isHidden   = true
            containerViewTop.constant = 8
            barButtonTop.constant     = 8
            if let description = response.description {
            eventDescriptionHeight.constant = TextSize.sharedinstance.getLabelHeight(text: description, width: eventDescriptionLabel.frame.width, font: eventDescriptionLabel.font)
            description_txt = description
            }
        }
        self.myscrollView.isHidden = false
    }
}

/***************************Bookmark function********************************/

extension EventViewController {
    
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




