//
//  ParentViewController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/9/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import GooglePlaces
import SwiftyJSON
import Alamofire
import IQKeyboardManagerSwift

class ParentViewController: ButtonBarPagerTabStripViewController {
    
    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    
    
    @IBOutlet weak var editsearchbyLocation: UITextField!
    @IBOutlet weak var editsearchbyItem: UITextField!

    @IBOutlet weak var navigationItemList: UINavigationItem!
    
    @IBOutlet var filtertable: UITableView!
    @IBOutlet var filtertableView: UIView!
    @IBOutlet weak var buttonTabBarView: ButtonBarView!
    var searchClick : Bool = false
    var hideDropdown : Bool = false
    var selectedIndex = 0
var getLocDetails = [String]()
   
    @IBOutlet weak var tabScrollView: UIScrollView!
    
    /*******************place api*************************/
    var autocompleteplaceArray = [String]()
    var autocompleteplaceID    = [String]()
    @IBOutlet weak var shareView : UIView!
    
    @IBOutlet weak var collectionContainerView: UIView!
    
    var locationDictonary : [String : Any]?
    var searchText        : String?
    var apiClient : ApiClient!
  
    override func viewDidLoad() {
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarItemFont = UIFont(name: "Avenir-Medium", size: 14)!
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.viewcontrollersCount = 5
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        // change selected bar color
        
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = purpleInspireColor
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true

        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        buttonBarView.selectedBar.backgroundColor = UIColor.appThemeColor()
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.textColor = UIColor.textlightDark()
            newCell?.label.textColor = UIColor.appBlackColor()
            IQKeyboardManager.sharedManager().enableAutoToolbar = false

        }
    
        hideKeyboardWhenTappedAround()
        buttonTabBarView.isHidden = true
        
        hideNavBar()
        addCollectionContainer()
        alertTapRegister()
        
        /*********FILTER VIEW*********/
        filtertableView.isHidden = true
        filtertable.delegate   = self
        filtertable.dataSource = self
        
        apiClient = ApiClient()
        
        if let address =  PrefsManager.sharedinstance.lastlocation {
            editsearchbyLocation.text = address
//            editsearchbyLocation.text = address.components(separatedBy: ",")[1]
        }
        
    }
  
    func navigationTap(){
        let offset = CGPoint(x: 0,y :0)
        self.containerView.setContentOffset(offset, animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.navigationBar.isHidden = false

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.isHidden = false
        reloadStripView()

    }
    override func viewWillAppear(_ animated: Bool){
        self.navigationController?.navigationBar.isHidden = false

        let navigationOnTap = UITapGestureRecognizer(target: self, action: #selector(ParentViewController.navigationTap))
        self.navigationController?.navigationBar.addGestureRecognizer(navigationOnTap)
        self.navigationController?.navigationBar.isUserInteractionEnabled = true

        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 16)!]

        
    }
    @IBAction func ButtonSearach(_ sender: UIButton) {
 
        
    }
    @IBAction func ButtonLocation(_ sender: UIButton) {

       
    }
    // Tab controllers switch func

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
            let child_1 = UIStoryboard(name: Constants.Tab, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid1) as! EventTabController
            child_1.scrolltableview = true
            child_1.locationDictonary = locationDictonary
            child_1.searchText        = searchText
            child_1.apiType           = "Home"
        
            let child_2 = UIStoryboard(name: Constants.Tab, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid2) as! BusinessTabController
            child_2.locationDictonary = locationDictonary
            child_2.searchText        = searchText
        
            let child_3 = UIStoryboard(name: Constants.Tab, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid3) as! MenuTabController
            child_3.locationDictonary = locationDictonary
            child_3.searchText        = searchText
        
            let child_4 = UIStoryboard(name: Constants.Tab, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid4) as! PostTabController
            child_4.popdelegate = self
            child_4.locationDictonary = locationDictonary
            child_4.searchText        = searchText
        
            let child_5 = UIStoryboard(name: Constants.Tab, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid5) as! UserTabController
            child_5.locationDictonary = locationDictonary
            child_5.searchText        = searchText
            return [child_1, child_2,child_3,child_4,child_5]
    
    }
}

extension ParentViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
      
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        if textField == editsearchbyItem  {
            let editsearchCount = editsearchbyItem.text!
            if editsearchCount.count > 0 {
                setNavBar()
            }
        }
        
        if textField == editsearchbyLocation  {
            let editsearchCount = editsearchbyItem.text!
            if editsearchCount.count > 0 {
//                 setNavBar()
                
            }
        }
        
        
        
        let top = CGAffineTransform(translationX: 0, y: 0)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            self.filtertableView.isHidden = true
            self.filtertableView.transform = top
        }, completion: nil)
        dismissKeyboard()
    
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            self.filtertableView.isHidden = true
        }, completion: nil)
        
        if textField == editsearchbyLocation {
            
            editsearchbyLocation.text = ""
            locationDictonary = nil
            reloadPagerTabStripView()
            
        } else {
            
            editsearchbyItem.text = ""
            searchText = nil
            reloadPagerTabStripView()
        }
        
        dismissKeyboard()
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let editsearchTextCount = editsearchbyItem.text!
        if editsearchTextCount.count > 0  {
            searchText   = editsearchbyItem.text!
            reloadPagerTabStripView()
        }
      
        dismissKeyboard()
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == editsearchbyLocation {
            if let place = textField.text {
               
                getPlaceApi(place_Str: "\(place)\(string)" as String)
           
                let top = CGAffineTransform(translationX: 0, y: 0)
                
                UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
                    self.filtertableView.isHidden = false
                    self.filtertableView.transform = top
                }, completion: nil)
//                dismissKeyboard()
                
            }
        }
        
        
        return true
    }
    
}

extension ParentViewController {
    
    /******************Set navigation bar**************************/
    
    func setNavBar() {
        
        searchClick = true
       
        buttonTabBarView.isHidden     = false
        tabScrollView.isScrollEnabled = true
        collectionContainerView.isHidden = true
        tabScrollView.isHidden           = false
        
        navigationItemList.title = "Numnu"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 16)!]

        let button: UIButton = UIButton(type: UIButtonType.custom)
        //set image for button
        button.setImage(UIImage(named: "ic_arrow_back"), for: UIControlState.normal)
        //add function for button
        button.addTarget(self, action: #selector(EventViewController.backButtonClicked), for: UIControlEvents.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(customView: button)
        leftButton.isEnabled = true
        
        let rightButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        // Create two buttons for the navigation item
        navigationItemList.leftBarButtonItem = leftButton
        navigationItemList.rightBarButtonItem = rightButton
     
        
    }
    
    func backButtonClicked() {
        
        hideNavBar()
        
    }
    
    
    func hideNavBar() {
        
        navigationItemList.title = "Numnu"
        searchClick = false
        buttonTabBarView.reloadData()
        buttonTabBarView.isHidden        = true
        tabScrollView.isScrollEnabled    = false
        collectionContainerView.isHidden = false
        tabScrollView.isHidden           = true
        
        let leftButton =  UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        leftButton.isEnabled = false
        navigationItemList.leftBarButtonItem = leftButton
        
    }
    
    func addCollectionContainer() {
        
        let storyboard        = UIStoryboard(name: Constants.Tab, bundle: nil)
        let controller        = storyboard.instantiateViewController(withIdentifier: Constants.DefaultTab)
        controller.view.frame = self.collectionContainerView.bounds;
        controller.willMove(toParentViewController: self)
        self.collectionContainerView.addSubview(controller.view)
        self.addChildViewController(controller)
        controller.didMove(toParentViewController: self)
    }
    
    
}

/*************************Google place autocomplete*******************************************/

extension ParentViewController : GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name)")
        
        editsearchbyLocation.text = place.name
        
        
        if let placeName = place.formattedAddress {
            
            print("Place address: \(placeName)")
        }
     
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
     
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
      
    }
    
}

extension ParentViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return autocompleteplaceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "placecell", for: indexPath) as! PlaceTableviewcellTableViewCell
        
        guard autocompleteplaceArray.count > 0 else {
            
            return cell
        }
        
        cell.placename.text = autocompleteplaceArray[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        if indexPath.row == lastRowIndex - 1  {
            
            tableView.allowsSelection = true
            
        } else {
            
            tableView.allowsSelection = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexPath = tableView.indexPathForSelectedRow  {
            let currentCell = tableView.cellForRow(at: indexPath) as! UITableViewCell
            editsearchbyLocation.text = (currentCell.textLabel?.text)
            editsearchbyLocation.text = autocompleteplaceArray[indexPath.row]
            apiClient.getPlaceCordinates(placeid_Str: autocompleteplaceID[indexPath.row], completion: { lat,lang in
                
                self.locationDictonary = ["lattitude":lat,"longitude":lang,"nearMeRadiusInMiles": 15000]
                PrefsManager.sharedinstance.lastlocationlat = lat
                PrefsManager.sharedinstance.lastlocationlat = lang
                PrefsManager.sharedinstance.lastlocation = self.editsearchbyLocation.text
            })
            
        }
 
        dismissKeyboard()
       
        let top = CGAffineTransform(translationX: 0, y: -self.filtertableView.frame.height)
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            self.filtertableView.transform = top
        }, completion: nil)
   
    }
    
    func getPlaceApi(place_Str:String) {
        
        autocompleteplaceArray.removeAll()
        autocompleteplaceID.removeAll()
        
        let parameters: Parameters = ["input": place_Str ,"types" : "(cities)" , "key" : "AIzaSyDmfYE1gIA6UfjrmOUkflK9kw0nLZf0nYw"]
        
        Alamofire.request(Constants.PlaceApiUrl, parameters: parameters).validate().responseJSON { response in
            
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    if let status = json["status"].string {
                        print(status)
                        if let place_dic = json["predictions"].array {
                            
                            for item in place_dic {
                                
                                let placeName = item["description"].string ?? "empty"
                                 let placeid   = item["place_id"].string ?? "empty"
                                if self.autocompleteplaceArray.count < 6 {
                                    
                                    self.autocompleteplaceArray.append(placeName)
                                    self.autocompleteplaceID.append(placeid)
                                }
                                
                                
                            }
                            
                            DispatchQueue.main.async {
                                
                                self.filtertable.reloadData()
                                
                            }
                            
                        }

                    }
                    
                }
                
            case .failure(let error):
                print(error)

                DispatchQueue.main.async {
                    
                    self.filtertable.reloadData()
                    
                }
                
            }
         
        }
      
    }
    
    
}

extension ParentViewController : PostTabControllerDelegate {
    
    func popupClick() {
        
        openPopup()
        
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
}


