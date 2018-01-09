//
//  Edit_ProfileVC.swift
//  Numnu
//
//  Created by CZ Ltd on 10/12/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GooglePlaces
import Alamofire
import IQKeyboardManagerSwift
import SwiftyJSON
import Firebase
import FirebaseAuth
import Nuke

class Edit_ProfileVC: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout {
    var dropdownArray = [String] ()
    var dropdownString = String ()
    var tagArray = [String] ()
    var selectedIndex = Int()
    var autocompleteUrls = [String]()
    var cancelBool : Bool = true
    
    @IBOutlet weak var dropDownAdjustView: UIView!
    
    @IBOutlet weak var dropAdjustViewEqualHeight: NSLayoutConstraint!
    
    /*************Parameters************************/
    
    var firebaseid : String = "empty"
    var cityDictonary : [String : Any]?
    var tagsDictonary = [[String: Any]]()
    
     /*************Location************************/
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    @IBOutlet weak var nameview: UIView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var usernamelabel: UILabel!
    
    @IBOutlet weak var usernameview: UIView!
    @IBOutlet weak var emailaddresslabel: UILabel!
    
    @IBOutlet weak var emailaddressview: UIView!
    
    @IBOutlet weak var citylabel: UILabel!
     @IBOutlet weak var genderlabel: UILabel!
     @IBOutlet weak var birthlabel: UILabel!
     @IBOutlet weak var fooflabel: UILabel!
     @IBOutlet weak var descriptionlabel: UILabel!
    
    @IBOutlet weak var cityview: UIView!
    @IBOutlet weak var genderview: UIView!
    @IBOutlet weak var foodview: UIView!
    @IBOutlet weak var birthview: UIView!
    @IBOutlet weak var descriptionview: UIView!

    
    @IBOutlet weak var cityTableView: UITableView!
    @IBOutlet weak var cancelDatePicker: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var doneButotn: UIButton!
    @IBOutlet weak var doneView: UIView!
    @IBOutlet var superVieww: UIView!
    @IBOutlet var genderdropButton: UIButton!
    @IBOutlet var dropdownTableView: UITableView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var editButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailaddress: UITextField!
    @IBOutlet var cityTextfield: UITextField!
    @IBOutlet var genderTextfield: UITextField!
    @IBOutlet var birthTextfield: UITextField!
    @IBOutlet var foodTextfield: UITextField!
    
    @IBOutlet weak var descriptionTextfield: UITextField!
    @IBOutlet weak var navigationItemList: UINavigationItem!
    var show : Bool = false
    var boolForTitle: Bool = false
    @IBOutlet var myscrollView: UIScrollView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
   
    var Alert = UIAlertController()
    //Upload Image Declaration
    let imagePicker = UIImagePickerController()
    var pickedImagePath: NSURL?
    var pickedImageData: NSData?
    var localPath: String?
    var apiClient : ApiClient!
    var autocompleteplaceArray = [String]()
    var autocompleteplaceID    = [String]()
    /***************Tags array*****************/

    var tagidArray   = [Int]()
    var tagnamearray = [String]()
    var token_str : String = "empty"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        LoadingHepler.instance.hide()

        imagePicker.delegate = self
        profileImage.isUserInteractionEnabled = true
        dropDownAdjustView.isHidden = true
        datePicker.isHidden = true
        superVieww.isHidden = true
        doneView.isHidden = true
        usernameTextField.delegate = self
        nameTextfield.delegate = self
        emailaddress.delegate = self
        genderTextfield.delegate = self
        cityTextfield.delegate = self
        birthTextfield.delegate = self
        foodTextfield.delegate = self
        descriptionTextfield.delegate = self
        
        // Tap gesture for city popup
        
        let tapGesturenew = UITapGestureRecognizer(target: self, action: #selector(self.tapEdit(recognizer:)))
        cityTableView.addGestureRecognizer(tapGesturenew)
        tapGesturenew.delegate = self as? UIGestureRecognizerDelegate
        
        
        let sampleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(recognizer:)))
       
        Alert.view.isUserInteractionEnabled = true
        Alert.view.addGestureRecognizer(sampleTapGesture)
        IQKeyboardManager.sharedManager().enable                     = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        IQKeyboardManager.sharedManager().enableAutoToolbar          = false

//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:))as Selector)
//        self.view.addGestureRecognizer(tapGesture)
//
        
        showPopup(table1: true, table2: true)
        
        genderdropButton.addTarget(self, action: #selector(genderClicked), for: UIControlEvents.allTouchEvents)
        doneButotn.addTarget(self, action: #selector(doneClick), for: UIControlEvents.allTouchEvents)
        addButton.addTarget(self, action: #selector(addClicked), for: UIControlEvents.allTouchEvents)
        cancelDatePicker.addTarget(self, action: #selector(dateCancelClicked), for: UIControlEvents.allTouchEvents)
//        datePicker.addTarget(self, action: #selector(Edit_ProfileVC.datePickerValueChanged), for: UIControlEvents.valueChanged)


        foodTextfield.addTarget(self, action: #selector(textFieldActive), for: UIControlEvents.allTouchEvents)
        
        let navigationOnTap = UITapGestureRecognizer(target: self, action: #selector(Edit_ProfileVC.navigationTap))
        self.navigationController?.navigationBar.addGestureRecognizer(navigationOnTap)
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        
        
        dropdownArray = []
        
        setNavBar()
        
        myscrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+100)
        saveButton.layer.cornerRadius = 25.0
        saveButton.clipsToBounds = true
        view.superview?.addSubview(saveButton)
        profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        profileImage.layer.masksToBounds = true
        self.editButton.layer.cornerRadius =  self.editButton.frame.size.height/2
        self.editButton.clipsToBounds = true
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.black,
             NSFontAttributeName: UIFont(name: "Avenir-Light", size: 16)!]
    
        
        cityTableView.layer.shadowColor = UIColor.darkGray.cgColor
        cityTableView.isUserInteractionEnabled = true
        cityTableView.backgroundColor = UIColor.clear
        cityTableView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cityTableView.layer.shadowOpacity = 2.0
        cityTableView.layer.shadowRadius = 5
        cityTableView.layer.cornerRadius = 10
        cityTableView.clipsToBounds = true
        cityTableView.layer.masksToBounds = false
        
        dropDownAdjustView.layer.shadowColor = UIColor.darkGray.cgColor
        dropDownAdjustView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        dropDownAdjustView.layer.shadowOpacity = 2.0
        dropDownAdjustView.layer.shadowRadius = 5
        
        /*************************getting location******************************/
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.distanceFilter = 50
            locationManager.startUpdatingLocation()
            
            
        }
        
        // Checking users login
        /***********************Api login******************************/
        apiClient = ApiClient()
        /************************getFirebaseToken*************************************/
        getFirebaseToken()
    }
    func tapEdit(recognizer: UITapGestureRecognizer)  {
        if recognizer.state == UIGestureRecognizerState.ended {
            let tapLocation = recognizer.location(in: self.cityTableView)
            if let tapIndexPath = self.cityTableView.indexPathForRow(at: tapLocation) {
                if let tappedCell = self.cityTableView.cellForRow(at: tapIndexPath) {
                    cityTextfield.text = tappedCell.textLabel?.text?.components(separatedBy: ",")[0]
                    
                    apiClient.getPlaceCordinates(placeid_Str: autocompleteplaceID[tapIndexPath.row], completion: { lat,lang in
                        
                        self.cityDictonary = ["name":self.autocompleteplaceArray[tapIndexPath.row],"address":self.autocompleteplaceArray[tapIndexPath.row],"isgoogleplace":true,"googleplaceid":self.autocompleteplaceID[tapIndexPath.row],"googleplacetype":"geocode","lattitude":lat,"longitude":lang]
                    })
                    cityTextfield.resignFirstResponder()

                }

                cityTableView.isHidden = true
            }
        }
    }
    func focusEdittext(textfield : UITextField,focus:Bool) {
        
        switch textfield {
            
        case nameTextfield:
            
            namelabel.textColor       = focus ? UIColor.textfieldFocus() : UIColor.labelunfocus()
            nameview.backgroundColor  = focus ? UIColor.textfieldFocus() : UIColor.textfieldUnfocus()
            
        case emailaddress:
            
            emailaddresslabel.textColor       = focus ? UIColor.textfieldFocus() : UIColor.labelunfocus()
            emailaddressview.backgroundColor  = focus ? UIColor.textfieldFocus() : UIColor.textfieldUnfocus()
            
        case cityTextfield:
            
            citylabel.textColor       = focus ? UIColor.textfieldFocus() : UIColor.labelunfocus()
            cityview.backgroundColor  = focus ? UIColor.textfieldFocus() : UIColor.textfieldUnfocus()
            
        case genderTextfield:
            
            genderlabel.textColor       = focus ? UIColor.textfieldFocus() : UIColor.labelunfocus()
            genderview.backgroundColor  = focus ? UIColor.textfieldFocus() : UIColor.textfieldUnfocus()
            
        case birthTextfield:
            
            birthlabel.textColor       = focus ? UIColor.textfieldFocus() : UIColor.labelunfocus()
            birthview.backgroundColor  = focus ? UIColor.textfieldFocus() : UIColor.textfieldUnfocus()
            
        case foodTextfield:
            
            fooflabel.textColor       = focus ? UIColor.textfieldFocus() : UIColor.labelunfocus()
            foodview.backgroundColor  = focus ? UIColor.textfieldFocus() : UIColor.textfieldUnfocus()
            
        case usernameTextField:
            
            usernamelabel.textColor       = focus ? UIColor.textfieldFocus() : UIColor.labelunfocus()
            usernameview.backgroundColor  = focus ? UIColor.textfieldFocus() : UIColor.textfieldUnfocus()
            
        case descriptionTextfield:
            
            descriptionlabel.textColor       = focus ? UIColor.textfieldFocus() : UIColor.labelunfocus()
            descriptionview.backgroundColor  = focus ? UIColor.textfieldFocus() : UIColor.textfieldUnfocus()
            
        default:
            
            namelabel.textColor       = focus ? UIColor.textfieldFocus() : UIColor.labelunfocus()
            nameview.backgroundColor  = focus ? UIColor.textfieldFocus() : UIColor.textfieldUnfocus()
            
        }
        
    }
    
    func navigationTap(){
        let offset = CGPoint(x: 0,y :0)
        myscrollView.setContentOffset(offset, animated: true)
     
    }
    func clickOnNavButton() {
        let offset = CGPoint(x: 0,y :0)
        myscrollView.setContentOffset(offset, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        let navigationOnTap = UITapGestureRecognizer(target:self,action:#selector(EventViewController.navigationTap))
        self.navigationController?.navigationBar.addGestureRecognizer(navigationOnTap)
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        // Hide the navigation bar on the this view controller
        dropDownAdjustView.isHidden = true
        showPopup(table1: true, table2: true)
        if boolForTitle == false {
            if PrefsManager.sharedinstance.isLoginned {
              
                addProfileContainer()
                
            } else {
                
                addCollectionContainer()
               
                
            }
        } else {
            
            setdetailsfromlogin()
            
        }
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        dropDownAdjustView.isHidden = true
       showPopup(table1: true, table2: true)
       
//        let offset = CGPoint(x: 0,y :0)
//        myscrollView.setContentOffset(offset, animated: true)
    }
    func dateCancelClicked() {
        cancelBool = true
       
//        if dateLabel.text == "" || monthLabel.text == "" || yearLabel.text == "" {
            birthTextfield.text = ""
            dateLabel.text = ""
            monthLabel.text = ""
            yearLabel.text = ""
//        }
    
        datePicker.isHidden = true
        doneView.isHidden = true
        superVieww.isHidden = true
        datePicker.resignFirstResponder()

    }
    func addClicked() {
        
        if foodTextfield.text == "" {
          print("could not add empty fields")
        }else{
            if tagArray.contains(foodTextfield.text!) {
                
                print("already added in collectionview")
                
            } else {
                
                tagArray.append(foodTextfield.text!)
                dropdownTableView.isHidden  = true
                dropDownAdjustView.isHidden = true
                
                /************Adding to dictonary**********************/
                let tagItem = ["text": foodTextfield.text!,"displayorder":tagArray.count] as [String : Any]
                tagsDictonary.append(tagItem)
                
            }
            if let index = tagArray.index(of:"") {
                
                tagArray.remove(at: index)
                tagsDictonary.remove(at: index)
                for (position,value) in tagsDictonary.enumerated() {
                    
                    var tagdic = value
                    tagdic.updateValue(position+1, forKey: "displayorder")
                    tagsDictonary[position] = tagdic
                    
                }
                
            }
            collectionView.reloadData()
            foodTextfield.resignFirstResponder()
        }
    }
    
    func genderClicked(){
        genderTextfield.resignFirstResponder()
       showGenderActionsheet()
    }
  
    func showGenderActionsheet() {

         Alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let FemaleAction = UIAlertAction(title: "Female", style: UIAlertActionStyle.default) { _ in
            self.genderTextfield.text = "Female"
            self.genderTextfield.resignFirstResponder()

        }
        let MaleAction = UIAlertAction(title: "Male", style: UIAlertActionStyle.default) { _ in
            self.genderTextfield.text = "Male"
            self.genderTextfield.resignFirstResponder()

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { _ in
        }
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
    func handleTap(recognizer: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
    func textFieldActive() {
    }
    // Validation func //
    public var emailRegEx = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
    public var nameRegEx = "[a-zA-Z]+$"
    
    func isValidEmail(testStr:String) -> Bool {
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func isValidName(testStr:String) -> Bool {
        let nameTest = NSPredicate(format:"SELF MATCHES %@",nameRegEx)
        let result = nameTest.evaluate(with: testStr)
        return result
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func savePressed(_ sender: Any) {
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
    }
    
    /// TextField delegates ///
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == foodTextfield {
            dropDownAdjustView.isHidden = true
            dropdownTableView.isHidden = true
            datePicker.isHidden = true
            doneView.isHidden = true
            
        } else if textField == cityTextfield {
            
            cityTableView.isHidden  = true
        } else if textField == genderTextfield {
            textField.resignFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == foodTextfield {
            let foodtext = foodTextfield.text!
            if foodtext.count > 1 {
                showPopup(table1: true, table2: false)
                dropDownAdjustView.isHidden = false
            }else{
                showPopup(table1: true, table2: true)
                dropDownAdjustView.isHidden = true
          }
//            dropdownTableView.isHidden = false
            let substring = (foodTextfield.text! as NSString).replacingCharacters(in: range, with: string )
            loadTagList(tag: substring)
        } else if textField == cityTextfield {
            let citytext = cityTextfield.text!
            if citytext.count > 1 {
                showPopup(table1: false, table2: true)
                
            }else{
                showPopup(table1: true, table2: true)
                
            }
                if let place = textField.text {
                    
                    getPlaceApi(place_Str: "\(place)\(string)" as String)
                    
                }
        
//            cityTableView.isHidden  = false
            
        } else {
            showPopup(table1: true, table2: true)

        }
            return true
    }
    
    func searchAutocompleteEntriesWithSubstring(substring: String)
    {
        autocompleteUrls.removeAll(keepingCapacity: false)
        var indexOfPastUrls = 0
        for curString in dropdownArray
        {
            print(curString)
            let myString: NSString! = curString as NSString
            let substringRange: NSRange! = myString.range(of: substring , options : [.caseInsensitive])
            if (substringRange.location == 0)
            {
                autocompleteUrls.append(curString)
            }
        }
        dropdownTableView.reloadData()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        focusEdittext(textfield: textField,focus: true)
        
        if !(textField == birthTextfield) {
            datePicker.isHidden = true
            superVieww.isHidden = true
            doneView.isHidden   = true
            
        }

        if textField == birthTextfield {
            dismissKeyboard()
            showDatePicker()
//            showPopup(table1: true, table2: true)
//            self.datePickerValueChanged(sender: datePicker)
            birthTextfield.resignFirstResponder()

        } else if textField == cityTextfield {
            let cityText = cityTextfield.text!
            if cityText.count > 1 {
                showPopup(table1: false, table2: true)

            }else{
                showPopup(table1: true, table2: true)

            }
            

        } else if textField == genderTextfield {
            dismissKeyboard()
            showPopup(table1: true, table2: true)
//            self.datePickerValueChanged(sender: datePicker)
            datePicker.isHidden = true
            superVieww.isHidden = true
            doneView.isHidden   = true

           genderTextfield.resignFirstResponder()
           showGenderActionsheet()
            
        }else if textField == foodTextfield {            
            let foodtext = foodTextfield.text!
            if foodtext.count > 1 {
                showPopup(table1: true, table2: false)
                dropDownAdjustView.isHidden = false
            }else{
                showPopup(table1: true, table2: true)
                dropDownAdjustView.isHidden = true
            }
        }
//        else {
//            showPopup(table1: true, table2: true)
//            genderTextfield.resignFirstResponder()
//            birthTextfield.resignFirstResponder()
//
//            self.datePickerValueChanged(sender: datePicker)
//            datePicker.isHidden = true
//            superVieww.isHidden = true
//            doneView.isHidden = true
//
//        }
}
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        focusEdittext(textfield: textField,focus: false)

        if textField == usernameTextField {
            if let userNamefield = textField.text {
                
                let header     : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token_str)"]
                apiClient.usernameexists(parameters: userNamefield,headers: header, completion:{status, Exists in
                    if Exists == true {
                        
                        print("the username already exists")
                        AlertProvider.Instance.showAlert(title: "Hey!", subtitle: "Username already exists", vc: self)
                        
                    } else {
                        
                        print("the username available")
                        
                        
                    }
                })
                
            }
            
        }
       
        if textField == birthTextfield {
            
                if cancelBool == true {
                    if dateLabel.text == "" || monthLabel.text == "" || yearLabel.text == "" {
                        birthTextfield.text = ""
                        dateLabel.text = ""
                        monthLabel.text = ""
                        yearLabel.text = ""
                    }
                }else{
                    self.datePickerValueChanged(sender: datePicker)
                    
                }
          
       
            datePicker.isHidden = true
            superVieww.isHidden = true
            doneView.isHidden   = true
            
        }
        if textField == genderTextfield {
            genderTextfield.tintColor = .clear
        }
        
        if textField == foodTextfield {
            
            foodTextfield.text = ""
            
        }
        
        if textField == cityTextfield {
            cityTableView.isHidden = true
        }
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            self.cityTableView.isHidden = true
        }, completion: nil)
        
        dismissKeyboard()
        
        if textField == cityTextfield {
            
            cityDictonary = nil
            cityTextfield.text = ""
            self.cityTableView.isHidden = true

        }
        if textField == foodTextfield {
            dropdownTableView.isHidden = true
            dropDownAdjustView.isHidden = true
        }
        
        return false
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//       
//        self.view.endEditing(true)
//    }
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        
//        self.view.endEditing(true)
//
//    }
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    func showDatePicker(){
        datePicker.datePickerMode = UIDatePickerMode.date
        birthTextfield.tintColor = UIColor.clear
        datePicker.isHidden = false
        superVieww.isHidden = false
        doneView.isHidden = false
        datePicker.addTarget(self, action: #selector(Edit_ProfileVC.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    func doneClick() {
        superVieww.isHidden = true
        datePicker.isHidden = true
        doneView.isHidden = true
        self.datePickerValueChanged(sender: datePicker)
        birthTextfield.resignFirstResponder()
        self.view.endEditing(true)
    }
  
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let year: String = dateFormatter.string(from: self.datePicker.date)
        dateFormatter.dateFormat = "MM"
        let month: String = dateFormatter.string(from: self.datePicker.date)
        dateFormatter.dateFormat = "dd"
        let day: String = dateFormatter.string(from: self.datePicker.date)
        dateLabel.text = day
        monthLabel.text = month
        yearLabel.text = year
}
    func addCollectionContainer(){
        let storyboard         = UIStoryboard(name: Constants.Auth, bundle: nil)
        let controller         = storyboard.instantiateViewController(withIdentifier: "signupwithEmailVC")
        controller.view.frame = self.view.bounds
        controller.willMove(toParentViewController: self)
        self.view.addSubview(controller.view)
        self.addChildViewController(controller)
        controller.didMove(toParentViewController: self)
    }
    
    func addProfileContainer() {
        
        /**************************Setting tabs*********************************/
        
        let nav1              = UINavigationController()
        let storyboard        = UIStoryboard(name: Constants.Main, bundle: nil)
        let controller        = storyboard.instantiateViewController(withIdentifier: "Profile_PostViewController") as! Profile_PostViewController
        nav1.viewControllers = [controller]
        self.tabBarController?.viewControllers?.append(nav1)
        let myImage = UIImage(named: "profileunselected")!
        self.tabBarItem.title        = nil
        controller.tabBarItem = UITabBarItem(title: nil, image: myImage, selectedImage: myImage)
        controller.tabBarItem.imageInsets  = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        
        
        /**************************Removing tabs*********************************/
        
        if let tabBarController = self.tabBarController {
            let indexToRemove = 2
            if indexToRemove < (tabBarController.viewControllers?.count)! {
                var viewControllers = tabBarController.viewControllers
                viewControllers?.remove(at: indexToRemove)
                tabBarController.viewControllers = viewControllers
            }
        }

    }
    
    @IBAction func didTappedSave(_ sender: Any) {
        saveClicked()
       
    }
    
    func uploadImage(image: UIImage,id : Int, completion:@escaping (String?) -> Void) {
        guard let data = UIImageJPEGRepresentation(image, 0.9) else {
            return
        }
        
        let header : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token_str)"]
        LoadingHepler.instance.show()
        
        Alamofire.upload(multipartFormData: { (form) in
            
            form.append(data, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
            
        }, to: "https://numnu-server-dev.appspot.com/users/\(id)/images",method: .post, headers: header,encodingCompletion: { result in
            switch result {
            case .success(let upload, _, _):
                upload.responseString { response in
                    print(response.value ?? "dsdks")
                    
                }
                upload.responseJSON { response in
                    
                    LoadingHepler.instance.hide()
                    
                    if let value = response.result.value {
                        
                        let json = JSON(value)
                        
                        if let imageurl = json["imageurl"].string {
                            
                            completion(imageurl)
                            
                        } else {
                            
                            completion(nil)
                        }
                        
                        
                    } else {
                        
                        completion(nil)
                        
                    }
                    
                }
                
            case .failure(let encodingError):
                print(encodingError)
                completion(nil)
                LoadingHepler.instance.hide()
            }
        })
    }
    
    // Image Picker //
     @IBAction func editPicture(_ sender: Any) {
        imagePicker.allowsEditing = false
        let Alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
       
        
        let CameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { ACTION in
            self.showCamera()
        }
        let GalleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default) { ACTION in
       
           self.showGallery()
        }
        let CancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) {_ in
        }
       
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            Alert.popoverPresentationController?.sourceView = self.view
            Alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
            present(Alert, animated: true, completion:nil )
        }else{
            present(Alert, animated: true, completion:nil )
        }
        Alert.addAction(CameraAction)
        Alert.addAction(GalleryAction)
        Alert.addAction(CancelAction)
    }
    
    func showCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(.camera))
        {
            self.imagePicker.sourceType = .camera
            self.imagePicker.delegate = self
            
        }
            present(imagePicker, animated: true, completion: nil)
    }
    func showGallery () {
        if(UIImagePickerController .isSourceTypeAvailable(.photoLibrary))
        {
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.delegate = self
            
        }
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profileImage.contentMode = .scaleAspectFill
            self.profileImage.image = pickedImage
         }
        dismiss(animated: true, completion: nil)
    }
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func setNavBar() {
        navigationItemList.title = "Complete Sign up"
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "ic_arrow_back"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(Edit_ProfileVC.backButtonClicked), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        let leftButton =  UIBarButtonItem(customView: button)
        leftButton.isEnabled = true
        
        let rightButton = UIBarButtonItem(title: "SignUp", style: .plain, target: self, action: #selector(saveClicked))
        navigationItemList.leftBarButtonItem = leftButton
        navigationItemList.rightBarButtonItem = rightButton
    }
   
    func backButtonClicked() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    func saveClicked(){
        if self.currentReachabilityStatus != .notReachable {
            
            let Email:NSString = emailaddress.text! as NSString
            if nameTextfield.text == "" || emailaddress.text == ""  || cityTextfield.text == "" || genderTextfield.text == "" || usernameTextField.text == ""  {
                AlertProvider.Instance.showAlert(title: "Oops", subtitle: "Fields Cannot be empty", vc: self)
            } else {
                if isValidEmail(testStr: Email as String) == true {
                    
                    if cityDictonary == nil {
                        
                        if let latlong = currentLocation {
                            
                            cityDictonary = ["name":cityTextfield.text!,"address":cityTextfield.text!,"isgoogleplace":false,"lattitude":latlong.coordinate.latitude,"longitude":latlong.coordinate.longitude]
                            
                        }
                     
                    }
                    
                    completeSignupApi()
                    
                }else {
                    AlertProvider.Instance.showAlert(title: "Oops", subtitle: "Please Enter Valid Email ID", vc: self)
                }
            }
            
        } else {
            
            AlertProvider.Instance.showInternetAlert(vc: self)
            
        }
    }
/// collectionView for food preferences ///
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagArray.count
    }
    
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvcell", for: indexPath as IndexPath) as! FoodPreferenceCollectionViewCell
        cell.foodtagLabel.text = tagArray[indexPath.row]
        cell.foodtagLabel.layer.cornerRadius = 4.0
        let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: tagArray[indexPath.row], fontname: "Avenir-Book", size: 13)
        cell.setLabelSize(size: textSize)
        cell.removetagButton.tag = indexPath.row
        cell.removetagButton.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let indexPath = collectionView.indexPathsForSelectedItems?.first
        let cell = collectionView.cellForItem(at: indexPath!) as? FoodPreferenceCollectionViewCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: tagArray[indexPath.row], fontname: "Avenir-Book", size: 13)
        return CGSize(width: textSize.width+30, height: 22)
    }
    func buttonClicked(sender: Any) {
        
        let tag = (sender as AnyObject).tag
        tagArray.remove(at: tag!)
        tagsDictonary.remove(at: tag!)
        for (position,value) in tagsDictonary.enumerated() {
            
            var tagdic = value
            tagdic.updateValue(position+1, forKey: "displayorder")
            tagsDictonary[position] = tagdic
            
        }
        collectionView.reloadData()
        
    }
    
    /// TableView Delegates and Datasources ///
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == dropdownTableView {
            
            return tagnamearray.count
            
        } else {
            
            return autocompleteplaceArray.count
        }
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == dropdownTableView {
            
            var cell : UITableViewCell? = dropdownTableView.dequeueReusableCell(withIdentifier: "cell")
            if(cell == nil)
            {
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
            }
            cell?.selectionStyle = .none
            
            guard tagnamearray.count > 0 else {
                
                return cell!
            }
            
            dropdownTableView.isScrollEnabled = true
            cell?.textLabel?.text = tagnamearray[indexPath.row]
            
            dropdownTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell?.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
           
            
//            tableView.transform = CGAffineTransform(rotationAngle: (-.pi))
//            cell?.transform = CGAffineTransform(rotationAngle: (-.pi))
//            cell?.backgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1.0)
            cell?.textLabel?.textColor = UIColor(red: 129/255.0, green: 135/255.0, blue: 155/255.0, alpha: 1.0)

            return cell!
            
            
        } else {
            
            var cell : UITableViewCell? = cityTableView.dequeueReusableCell(withIdentifier: "cell")
            if(cell == nil)
            {
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
            }
            cell?.selectionStyle = .none
            
            guard autocompleteplaceArray.count > 0 else {
                
                return cell!
            }
            
//            cell?.backgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1.0)
            cell?.textLabel?.text = autocompleteplaceArray[indexPath.row]
            cell?.textLabel?.textColor = UIColor(red: 129/255.0, green: 135/255.0, blue: 155/255.0, alpha: 1.0)
//            tableView.transform = CGAffineTransform(rotationAngle: (-.pi))
//            cell?.transform = CGAffineTransform(rotationAngle: (-.pi))
            
            cityTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell?.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell!
            
            
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = dropdownTableView.numberOfRows(inSection: 0)
        if indexPath.row == lastRowIndex {
            dropdownTableView.allowsSelection = true
         } else {
            dropdownTableView.allowsSelection = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == dropdownTableView {
            
            if let indexPath = dropdownTableView.indexPathForSelectedRow  {
                let currentCell = dropdownTableView.cellForRow(at: indexPath)
                dropdownString = (currentCell?.textLabel?.text)!
                if tagArray.contains(dropdownString) {

                    print("already exist")
                    
                } else {

                    tagArray.append(dropdownString)
                    let tagItem = ["id": tagidArray[indexPath.row],"displayorder":tagArray.count]
                    tagsDictonary.append(tagItem)
                }
                collectionView.reloadData()
                dropdownTableView.isHidden  = true
                dropDownAdjustView.isHidden = true
                foodTextfield.resignFirstResponder()
               
            }
            
        }
//        else {
//
//            if let indexPath = cityTableView.indexPathForSelectedRow  {
//                let currentCell = cityTableView.cellForRow(at: indexPath)
//                cityTextfield.text = (currentCell?.textLabel?.text)!.components(separatedBy: ",")[0]
//                print("city address is::::",cityTextfield.text as! String)
//                cityTableView.isHidden = true
//                cityTextfield.resignFirstResponder()
//
//                apiClient.getPlaceCordinates(placeid_Str: autocompleteplaceID[indexPath.row], completion: { lat,lang in
//
//                  self.cityDictonary = ["name":self.autocompleteplaceArray[indexPath.row],"address":self.autocompleteplaceArray[indexPath.row],"isgoogleplace":true,"googleplaceid":self.autocompleteplaceID[indexPath.row],"googleplacetype":"geocode","lattitude":lat,"longitude":lang]
//                  })
//            }
//        }
    }
}

extension Edit_ProfileVC : Profile_PostViewControllerDelegae {
    
    func sendlogoutstatus() {
        let rightButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        // Create two buttons for the navigation item
        navigationItemList.leftBarButtonItem = rightButton
    }
    
    func logout() {
        
        PrefsManager.sharedinstance.isLoginned = false
        addCollectionContainer()
     
    }
}

extension Edit_ProfileVC {
    
    func loadTagList(tag : String) {
        
        tagidArray.removeAll()
        tagnamearray.removeAll()
        let parameters : Parameters = ["beginWith" : tag]
        let header     : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token_str)"]
        apiClient.getTagsApi(parameters: parameters, headers: header, completion: { status,taglist in
            if status == "success" {
                if let tagList = taglist {
                    if tagList.id != nil {
                        self.tagidArray = tagList.id!
                    }
                    if let taglst = tagList.text {
                        self.tagnamearray = taglst

                    }
                   
                    DispatchQueue.main.async {
                        self.dropdownTableView.reloadData()
                        if self.tagnamearray.count < 5 {
                            if self.tagnamearray.count == 1        {
                                self.dropAdjustViewEqualHeight.constant   = 44
                            } else if self.tagnamearray.count == 2 {
                                self.dropAdjustViewEqualHeight.constant   = 88

                            } else if self.tagnamearray.count == 3 {
                                self.dropAdjustViewEqualHeight.constant   = 132
                            } else if self.tagnamearray.count == 0 {
                                self.dropDownAdjustView.isHidden = true
                                self.dropAdjustViewEqualHeight.constant   = 0
                            }
                        }else {
                            self.dropAdjustViewEqualHeight.constant   = 165
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.dropdownTableView.reloadData()
                }
            }
        })
    }
    
    func getFirebaseToken() {
        
        apiClient.getFireBaseToken(completion:{ token in
            
            self.token_str = token
            
        })
     
    }
    
    
    /************************City Api****************************/
    
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
                            
                                self.cityTableView.reloadData()
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            case .failure(let error) :
                print(error)
                
                DispatchQueue.main.async {
                    
                    self.cityTableView.reloadData()
                    
                }
                
            }
            
        }
        
    }
    
    /****************************************complete signup******************************************************/
    
    func completeSignupApi() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let birthdate : String = dateFormatter.string(from: self.datePicker.date)
        
        print(tagsDictonary)
        print(cityDictonary ?? ["name" : "unknown"])
        print(usernameTextField.text!)
        print(nameTextfield.text!)
        print(descriptionTextfield.text!)
        print(birthdate)
        print(emailaddress.text!)
        print(profileImage)
      
        let clientIp = ValidationHelper.Instance.getIPAddress() ?? "1.0.1"
        var gender : Int = 0
        if genderTextfield.text == "Female" {
            
            gender = 1
            
        }
        
        LoadingHepler.instance.show()
      
        let header     : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token_str)"]
        let parameters: Parameters = ["username": usernameTextField.text!, "name":nameTextfield.text! , "description" : descriptionTextfield.text! ,"firebaseuid" : firebaseid,"dateofbirth": birthdate, "gender": gender as Int,"tags":tagsDictonary,"isbusinessuser": false as Bool,"email": emailaddress.text! ,"citylocation":cityDictonary! ,"clientip": clientIp, "clientapp": Constants.clientApp]
       
        apiClient.completeSignup(parameters: parameters,headers: header,completion:{status, Values in
            
            
            print("statusfb: \(status)")
            if status == "success" {
                
                LoadingHepler.instance.hide()
                
                if let user = Values {
                    
                    self.getUserDetails(user: user)
                    
                    self.uploadImage(image: self.profileImage.image!, id: user.id ?? 0, completion: { imageurl in
                        
                            PrefsManager.sharedinstance.imageURL = imageurl ?? "empty"
                            let storyboard = UIStoryboard(name: Constants.Main, bundle: nil)
                            let vc         = storyboard.instantiateViewController(withIdentifier: "Profile_PostViewController") as! Profile_PostViewController
                            vc.boolForBack = true
                            vc.delegate    = self
                            self.navigationController!.pushViewController(vc, animated: true)
                
                        
                    })
                   
                } else {
                    
                    LoadingHepler.instance.hide()
                    AlertProvider.Instance.showAlert(title: "Oops!", subtitle: "Signup failed", vc: self)
                    
                }
          
               
            } else {
                
                    LoadingHepler.instance.hide()
                
                    if let user = Values {
                        
                        if let meassage = user.errormessage {
                            
                            if meassage.contains("There is already a user defined with the passed firebaseuid") {
                                
                                AlertProvider.Instance.showAlert(title: "Oops!", subtitle: "The email address is already in use by another account.", vc: self)
                                
                            } else {
                                
                                AlertProvider.Instance.showAlert(title: "Oops!", subtitle: meassage, vc: self)
                                
                            }
                            
                            return
                        }
                   
                    }
                    
                    AlertProvider.Instance.showAlert(title: "Oops!", subtitle: "Signup failed", vc: self)
                
            }
        })
        
        
    }
    
    func getUserDetails(user:UserList) {
        
        if let firebaseid = user.firebaseuid {
            
            PrefsManager.sharedinstance.UIDfirebase = firebaseid
            
        }
        
        if let userid = user.id {
            
            PrefsManager.sharedinstance.userId = userid
            
        }
        
        if let username = user.username {
            
            PrefsManager.sharedinstance.username = username
            
        }
        
        if let dateofbirth = user.dateofbirth {
            
            PrefsManager.sharedinstance.dateOfBirth = dateofbirth
            
        }
        
        if let gender = user.gender {
            
            PrefsManager.sharedinstance.gender = gender
            
        }
        
        if let desc = user.description {
            
            PrefsManager.sharedinstance.description = desc
            
        }
        
        if let name = user.name {
            
            PrefsManager.sharedinstance.name = name
            
        }
        
        if let userEmail = user.email {
            
            PrefsManager.sharedinstance.userEmail = userEmail
            
        }
        
        if let userImagesList = user.imgList {
            
            if userImagesList.count > 0 {
                
                PrefsManager.sharedinstance.imageURL = userImagesList[userImagesList.count-1].imageurl_str ?? "empty"
                
            }
            
        }
        
        if let taglist = user.tagList {
            
            PrefsManager.sharedinstance.tagList = taglist
        }
        
        if let locitem = user.locItem {
            
            PrefsManager.sharedinstance.userCity = "\(locitem.address_str ?? "")"
            PrefsManager.sharedinstance.userCityId = locitem.id_str ?? 0
            
        }
        
        PrefsManager.sharedinstance.isLoginned = true
    
    }
    
    
    
    
    func showPopup(table1: Bool,table2 : Bool) {
    
        cityTableView.isHidden      = table1
        dropdownTableView.isHidden  = table2
        
        if table1 == false || table2 == false {
            
//            self.datePickerValueChanged(sender: datePicker)
            datePicker.isHidden = true
            superVieww.isHidden = true
            doneView.isHidden = true
            
        }
     
    }
    
    func setdetailsfromlogin(){
        
        let user = Auth.auth().currentUser
        if let user = user {
            
            
            if let email = user.email {
                
                emailaddress.text = email
                
            }
            if let photoURL = user.photoURL {
                
                 Manager.shared.loadImage(with:photoURL, into: profileImage)
                
            }
            
            if let name = user.displayName {
                
                usernameTextField.text = name
                nameTextfield.text     = name
                
            }
            
            
           
        }
    }
    
}

extension Edit_ProfileVC : CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location: CLLocation = locations.last {
            
            currentLocation = location
            
        }
        
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
   
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
            locationManager.distanceFilter = 50
            locationManager.startUpdatingLocation()
        }
        
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
