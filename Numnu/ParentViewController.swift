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

class ParentViewController: ButtonBarPagerTabStripViewController {
    
    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    
    
    @IBOutlet weak var editsearchbyLocation: UITextField!
    @IBOutlet weak var editsearchbyItem: UITextField!

    @IBOutlet weak var navigationItemList: UINavigationItem!
    
    @IBOutlet weak var buttonTabBarView: ButtonBarView!
    var searchClick : Bool = false
   
    @IBOutlet weak var tabScrollView: UIScrollView!
    
    @IBOutlet weak var collectionContainerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = purpleInspireColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
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
        
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
       
    }
    
    @IBAction func ButtonSearach(_ sender: UIButton) {
        
        dismissKeyboard()
        setNavBar()
        
    }
    @IBAction func ButtonLocation(_ sender: UIButton) {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    // Tab controllers switch func

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
            let child_1 = UIStoryboard(name: Constants.Tab, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid1)
            let child_2 = UIStoryboard(name: Constants.Tab, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid2)
            let child_3 = UIStoryboard(name: Constants.Tab, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid3)
            let child_4 = UIStoryboard(name: Constants.Tab, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid4)
            let child_5 = UIStoryboard(name: Constants.Tab, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid5)
            let child_6 = UIStoryboard(name: Constants.Tab, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid6)
            return [child_1, child_2,child_3,child_4,child_5,child_6]
    
       
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
        
        dismissKeyboard()
        setNavBar()
        
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
        
        navigationItemList.title = "Explore"
        
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
    
    func addCollectionContainer(){
        
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

extension ParentViewController: GMSAutocompleteViewControllerDelegate {
    
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


