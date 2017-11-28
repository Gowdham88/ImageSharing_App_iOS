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
   
    @IBOutlet weak var tabScrollView: UIScrollView!
    
    /*******************place api*************************/
    var autocompleteplaceArray = [String]()
    @IBOutlet weak var shareView : UIView!
    
    @IBOutlet weak var collectionContainerView: UIView!
    override func viewDidLoad() {
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarItemFont = UIFont(name: "Avenir-Medium", size: 14)!
        super.viewDidLoad()
        // change selected bar color
        
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = purpleInspireColor
        
        
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
        
        hideKeyboardWhenTappedAround()
        buttonTabBarView.isHidden = true
        
        hideNavBar()
        addCollectionContainer()
        alertTapRegister()
        
        /*********FILTER VIEW*********/
        filtertableView.isHidden = true
        filtertable.delegate   = self
        filtertable.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
        
    }
    
    @IBAction func ButtonSearach(_ sender: UIButton) {
        
        let top = CGAffineTransform(translationX: 0, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            self.filtertableView.transform = top
            self.filtertableView.isHidden = false
        }, completion: nil)
        
        
    }
    @IBAction func ButtonLocation(_ sender: UIButton) {
        
        let top = CGAffineTransform(translationX: 0, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            self.filtertableView.transform = top
            self.filtertableView.isHidden = false
        }, completion: nil)
       
    }
    // Tab controllers switch func

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
            let child_1 = UIStoryboard(name: Constants.Tab, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid1) as! EventTabController
            child_1.scrolltableview = true
            let child_2 = UIStoryboard(name: Constants.Tab, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid2)
            let child_3 = UIStoryboard(name: Constants.Tab, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid3)
            let child_4 = UIStoryboard(name: Constants.Tab, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid4) as! PostTabController
            child_4.popdelegate = self
            let child_5 = UIStoryboard(name: Constants.Tab, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid5)
            let child_6 = UIStoryboard(name: Constants.Tab, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid6)
            return [child_1, child_2,child_3,child_4,child_5]
    
       
    }
  
    func setnavBar()  {
        
        let searchController = UISearchController(searchResultsController: nil)
        if #available(iOS 11.0, *) {
           navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            // Fallback on earlier versions
        }
       
        
    }

}

extension ParentViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
      
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        if let place = textField.text {
            
            getPlaceApi(place_Str: place)
            
        }
        
        let top = CGAffineTransform(translationX: 0, y: 0)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            self.filtertableView.isHidden = false
            self.filtertableView.transform = top
        }, completion: nil)
        dismissKeyboard()
    
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            self.filtertableView.isHidden = true
        }, completion: nil)
        
        dismissKeyboard()
        
        if textField == editsearchbyLocation {
            
            editsearchbyLocation.text = ""
            
        } else {
            
            editsearchbyItem.text = ""
        }
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        dismissKeyboard()
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        
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
        reloadPagerTabStripView()
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
        
        cell.placename.text = autocompleteplaceArray[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        if indexPath.row == lastRowIndex - 1  {
            
            tableView.allowsSelection = true
            
        } else {
            
            tableView.allowsSelection = false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        editsearchbyLocation.text = autocompleteplaceArray[indexPath.row]
        dismissKeyboard()
        setNavBar()
        
        let top = CGAffineTransform(translationX: 0, y: -self.filtertableView.frame.height)
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            self.filtertableView.transform = top
        }, completion: nil)
   
    }
    
    func getPlaceApi(place_Str:String) {
        
        autocompleteplaceArray.removeAll()
        
        let parameters: Parameters = ["input": place_Str ,"types" : "geocode" , "key" : "AIzaSyDmfYE1gIA6UfjrmOUkflK9kw0nLZf0nYw"]
        
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
                                self.autocompleteplaceArray.append(placeName)
                                
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
        
        self.shareView.alpha   = 1
        
        let top = CGAffineTransform(translationX: 0, y: 0)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            self.shareView.isHidden = false
            self.shareView.transform = top
            
        }, completion: nil)
        
        
    }
}
