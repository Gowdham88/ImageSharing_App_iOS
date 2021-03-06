//
//  SettingsEdit_ProfieViewController.swift
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
import Nuke


class SettingsEdit_ProfieViewController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,GMSAutocompleteViewControllerDelegate,UICollectionViewDelegateFlowLayout {
    var dropdownArray  = [String]()
    var dropdownString = String ()
    var tagArray       = [String] ()
    var tagIdArray     = [Int]()
    var selectedIndex = Int()
    var autocompleteUrls = [String]()
    var tagArrayList = [TagList]()
    var activeTextField = UITextField()

    @IBOutlet weak var dropAdjustViewEqualHeight: NSLayoutConstraint!
    @IBOutlet weak var dropDownAdjustView: UIView!
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
    @IBOutlet var cityTextfield    : UITextField!
    @IBOutlet var genderTextfield: UITextField!
    @IBOutlet var birthTextfield: UITextField!
    @IBOutlet var foodTextfield: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailaddresslabel : UILabel!
    @IBOutlet var citylabel    : UILabel!
    @IBOutlet var genderlabel  : UILabel!
    @IBOutlet var birthlabel   : UILabel!
    @IBOutlet var foodlabel    : UILabel!
    @IBOutlet weak var usernamelabel : UILabel!
    @IBOutlet weak var descriptionlabel: UILabel!
    
    @IBOutlet weak var nameview: UIView!
    @IBOutlet weak var emailaddressview : UIView!
    @IBOutlet var cityview    : UIView!
    @IBOutlet var genderview  : UIView!
    @IBOutlet var birthview   : UIView!
    @IBOutlet var foodview    : UIView!
    @IBOutlet weak var usernameview : UIView!
    @IBOutlet weak var descriptionview : UIView!
    
    @IBOutlet weak var citytableview: UITableView!
    @IBOutlet weak var navigationItemList: UINavigationItem!
    var show : Bool = false
    var boolForTitle: Bool = false
    @IBOutlet var myscrollView: UIScrollView!
    @IBOutlet var saveButton: UIButton!
    let locationManager = CLLocationManager()
//    var Alert = UIAlertController()
    //Upload Image Declaration
    let imagePicker = UIImagePickerController()
    var pickedImagePath: NSURL?
    var pickedImageData: NSData?
    var localPath: String?
    var apiClient : ApiClient!
    var autocompleteplaceArray = [String]()
    var autocompleteplaceID    = [String]()
    /***************Tags array*****************/
    
    @IBOutlet weak var dropdowntableheight: NSLayoutConstraint!
    var tagidArray   = [Int]()
    var tagnamearray = [String]()
    var token_str    : String = "empty"
    var setdatebirth : Bool   = false
    /*****************Parameters*************************/
    
    var cityDictonary : [String : Any]?
    var tagsDictonary = [[String: Any]]()
    
    // place autocomplete //
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
        self.cityTextfield.text = place.name
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropdownTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        citytableview.transform     = CGAffineTransform(scaleX: 1, y: -1)
        
        dropdownTableView.isHidden = true
        dropDownAdjustView.isHidden = true
        
        imagePicker.delegate = self
        profileImage.isUserInteractionEnabled = true
        datePicker.isHidden = true
        superVieww.isHidden = true
        doneView.isHidden = true
        cancelDatePicker.isHidden = true

        usernameTextField.delegate = self
        nameTextfield.delegate = self
        emailaddress.delegate = self
        genderTextfield.delegate = self
        cityTextfield.delegate = self
        birthTextfield.delegate = self
        foodTextfield.delegate = self
        
        
        // Tap gesture for city popup
        
        let tapGesturenew = UITapGestureRecognizer(target: self, action: #selector(self.tapEdit(recognizer:)))
        citytableview.addGestureRecognizer(tapGesturenew)
        tapGesturenew.delegate = self as? UIGestureRecognizerDelegate
        
        let sampleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(recognizer:)))
//        Alert.view.isUserInteractionEnabled = true
//        Alert.view.addGestureRecognizer(sampleTapGesture)

        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false

        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:))as Selector)
        //        self.view.addGestureRecognizer(tapGesture)
        //
        
        genderdropButton.addTarget(self, action: #selector(genderClicked), for: UIControlEvents.allTouchEvents)
        doneButotn.addTarget(self, action: #selector(doneClick), for: UIControlEvents.allTouchEvents)
        addButton.addTarget(self, action: #selector(addClicked), for: UIControlEvents.allTouchEvents)
        cancelDatePicker.addTarget(self, action: #selector(datecancelClicked), for: UIControlEvents.allTouchEvents)
        
        dropdownArray = ["Chicken","Chicken chilli","Chicken manjurian","Chicken 65","Chicken fried rice","Grill chicken","Pizza","Burger","Sandwich","Mutton","Mutton chukka","Mutton masala","Mutton fry","Prawn","Gobi chilli","Panneer","Noodles","Mutton soup","Fish fry","Dry fish"]
        
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
        
        let navigationOnTap = UITapGestureRecognizer(target: self, action: #selector(Edit_ProfileVC.navigationTap))
        self.navigationController?.navigationBar.addGestureRecognizer(navigationOnTap)
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        
        citytableview.layer.shadowColor    = UIColor.darkGray.cgColor
        citytableview.backgroundColor      = UIColor.white
        citytableview.layer.shadowOffset   = CGSize(width: 0.0, height: 0.0)
        citytableview.layer.shadowOpacity  = 2.0
        citytableview.layer.shadowRadius   = 5
        citytableview.layer.cornerRadius   = 10
        citytableview.clipsToBounds        = true
        citytableview.layer.masksToBounds  = false
        citytableview.isScrollEnabled      = false
        
        dropDownAdjustView.backgroundColor      = UIColor.white
        dropDownAdjustView.layer.shadowColor = UIColor.darkGray.cgColor
        dropDownAdjustView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        dropDownAdjustView.layer.shadowOpacity = 2.0
        dropDownAdjustView.layer.shadowRadius = 5
        
        // Checking users login
        /***********************Api login******************************/
        apiClient = ApiClient()
        /************************getFirebaseToken*************************************/
        getFirebaseToken()
        setUserDetails()
        
    }
    
    func tapEdit(recognizer: UITapGestureRecognizer)  {
        if recognizer.state == UIGestureRecognizerState.ended {
            let tapLocation = recognizer.location(in: self.citytableview)
            if let tapIndexPath = self.citytableview.indexPathForRow(at: tapLocation) {
                if let tappedCell = self.citytableview.cellForRow(at: tapIndexPath) {
                    print("selected index is::::::::",tappedCell)
                    cityTextfield.text = tappedCell.textLabel?.text
                    apiClient.getPlaceCordinates(placeid_Str: autocompleteplaceID[tapIndexPath.row], completion: { lat,lang in
                        
                        self.cityDictonary = ["name":self.autocompleteplaceArray[tapIndexPath.row],"address":self.autocompleteplaceArray[tapIndexPath.row],"isgoogleplace":true,"googleplaceid":self.autocompleteplaceID[tapIndexPath.row],"googleplacetype":"geocode","lattitude":lat,"longitude":lang]
                    })
                    cityTextfield.resignFirstResponder()
                    
                }
                citytableview.isHidden = true
            }
        }

    }
    
    
    func navigationTap(){

        let offset = CGPoint(x: 0,y :0)
        self.myscrollView.setContentOffset(offset, animated: true)
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            let navigationOnTap = UITapGestureRecognizer(target:self,action:#selector(EventViewController.navigationTap))
            self.navigationController?.navigationBar.addGestureRecognizer(navigationOnTap)
            self.navigationController?.navigationBar.isUserInteractionEnabled = true
        
        // Hide the navigation bar on the this view controller
         showPopup(table1: true, table2: true)
         dropDownAdjustView.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        if PrefsManager.sharedinstance.isLoginned {
        } else {
            if boolForTitle == false {
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        showPopup(table1: true, table2: true)
    }
    func datecancelClicked () {
        datePicker.isHidden       = true
        doneView.isHidden         = true
        cancelDatePicker.isHidden = true
        superVieww.isHidden       = true
        getDateDetails()
        datePicker.resignFirstResponder()
    }
    func addClicked() {
        if foodTextfield.text == "" {
        }else{
            if tagArray.contains(foodTextfield.text!){
            }else{
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
        
        let Alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let FemaleAction: UIAlertAction = UIAlertAction(title: "Female", style:  .default) { _ in
            self.genderTextfield.text = "Female"
            self.genderTextfield.resignFirstResponder()
            
        }
        let MaleAction: UIAlertAction = UIAlertAction(title: "Male", style: .default) { _ in
            self.genderTextfield.text = "Male"
            self.genderTextfield.resignFirstResponder()
            
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")

        Alert.addAction(FemaleAction)
        Alert.addAction(MaleAction)
        Alert.addAction(cancelAction)
        present(Alert, animated: true, completion:nil )
        
    }
    func handleTap(recognizer: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
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
            dropdownTableView.isHidden = true
            dropDownAdjustView.isHidden = true

            
        } else if textField == cityTextfield {
            
            citytableview.isHidden  = true
            
        }
        if let nextField = activeTextField.superview?.viewWithTag(activeTextField.tag + 1) as? UITextField {
            if activeTextField == genderTextfield {
                nextField.resignFirstResponder

            }else{
                nextField.becomeFirstResponder()
            }
        } else {
            textField.resignFirstResponder()
        }
        return false
      
        
       
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == foodTextfield {
            let foodtext = foodTextfield.text!
            if foodtext.count > 1 {
                showPopup(table1: true, table2: false)
                dropDownAdjustView.isHidden = false
                let substring = (foodTextfield.text! as NSString).replacingCharacters(in: range, with: string )
                loadTagList(tag: substring)
            }else{
                showPopup(table1: true, table2: true)
                dropDownAdjustView.isHidden = true
            }
            
        }else if textField == cityTextfield {
            
            dropDownAdjustView.isHidden = true
            dropdownTableView.isHidden  = true

                let citytext = cityTextfield.text!
                if citytext.count > 1 {
                    showPopup(table1: false, table2: true)
                    dropdownTableView.isHidden  = true

                }else{
                    showPopup(table1: true, table2: true)
                    dropDownAdjustView.isHidden = true
                    dropdownTableView.isHidden  = true


                }
            if let place = textField.text {
                getPlaceApi(place_Str: "\(place)\(string)" as String)
            }
            
        } else {
            showPopup(table1: true, table2: true)
            dropDownAdjustView.isHidden = true
            dropdownTableView.isHidden  = true


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
        self.activeTextField = textField

           focusEdittext(textfield: textField,focus: true)
        
        if textField == birthTextfield {
            dismissKeyboard()
            showDatePicker()
            datePicker.isHidden = false
            superVieww.isHidden = false
            doneView.isHidden = false
            cancelDatePicker.isHidden = false
            showPopup(table1: true, table2: true)
            dropDownAdjustView.isHidden = true
            self.datePickerValueChanged(sender: datePicker)

        }else if textField == cityTextfield {
//            let cityText = cityTextfield.text!
//            if cityText.count > 1 {
//                showPopup(table1: true, table2: true)
//                dropDownAdjustView.isHidden = true
//
//            }else{
//                showPopup(table1: true, table2: true)
//                dropDownAdjustView.isHidden = true
//
//                
//            }
//            showPopup(table1: false, table2: true)
            self.datePickerValueChanged(sender: datePicker)
            datePicker.isHidden = true
            superVieww.isHidden = true
            doneView.isHidden   = true
            cancelDatePicker.isHidden = true

        }else if textField == genderTextfield {
            dismissKeyboard()
            showPopup(table1: true, table2: true)
//            genderTextfield.resignFirstResponder()
            showGenderActionsheet()
        } else if textField == foodTextfield {
            let foodtext = foodTextfield.text!
            if foodtext.count > 1 {
                showPopup(table1: true, table2: false)
                dropDownAdjustView.isHidden = false
            }else{
                showPopup(table1: true, table2: true)
                dropDownAdjustView.isHidden = true
            }
           
        }
//        else{
//            showPopup(table1: true, table2: true)
//            self.datePickerValueChanged(sender: datePicker)
//            datePicker.isHidden = true
//            superVieww.isHidden = true
//            doneView.isHidden   = true
//            cancelDatePicker.isHidden = true
//
//        }
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        if textField == foodTextfield {
            dropDownAdjustView.isHidden = true
            dropdownTableView.isHidden  = true

        }
        if textField == cityTextfield {
            citytableview.isHidden = true
            cityDictonary = nil
            cityTextfield.text = ""
            dropDownAdjustView.isHidden = true
            dropdownTableView.isHidden  = true
        }
      
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        focusEdittext(textfield: textField,focus: false)
       
        if textField == usernameTextField {
            
            if let userNamefield = textField.text,userNamefield != PrefsManager.sharedinstance.username {
                
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
            self.datePickerValueChanged(sender: datePicker)
            datePicker.isHidden = true
            superVieww.isHidden = true
            doneView.isHidden = true
            cancelDatePicker.isHidden = true
        birthTextfield.resignFirstResponder()
        }
        if textField == genderTextfield {
            genderTextfield.tintColor = .clear
            genderTextfield.resignFirstResponder()
        }
        if textField == foodTextfield {
            
            foodTextfield.text = ""
            foodTextfield.resignFirstResponder()
            
        }
        if textField == cityTextfield {
            
        citytableview.isHidden = true
            
            cityTextfield.resignFirstResponder()
            
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
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
        cancelDatePicker.isHidden = false
        datePicker.addTarget(self, action: #selector(SettingsEdit_ProfieViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    func doneClick() {
        birthTextfield.resignFirstResponder()
        self.view.endEditing(true)
        superVieww.isHidden = true
        datePicker.isHidden = true
        doneView.isHidden = true
        cancelDatePicker.isHidden = true

    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let year: String = dateFormatter.string(from: self.datePicker.date)
        dateFormatter.dateFormat = "MM"
        let month: String = dateFormatter.string(from: self.datePicker.date)
        dateFormatter.dateFormat = "dd"
        let day: String = dateFormatter.string(from: self.datePicker.date)
        
//        if setdatebirth {
        
            dateLabel.text = day
            monthLabel.text = month
            yearLabel.text = year
            
//        }
        
    }
    func addCollectionContainer(){
        let storyboard        = UIStoryboard(name: Constants.Auth, bundle: nil)
        let controller        = storyboard.instantiateViewController(withIdentifier: "signupwithEmailVC")
        controller.view.frame = self.view.bounds;
        controller.willMove(toParentViewController: self)
        self.view.addSubview(controller.view)
        self.addChildViewController(controller)
        controller.didMove(toParentViewController: self)
    }
    
    func addProfileContainer(){
        
        let storyboard        = UIStoryboard(name: Constants.Main, bundle: nil)
        let controller        = storyboard.instantiateViewController(withIdentifier: "Profile_PostViewController") as! Profile_PostViewController
        controller.delegate   = self
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    @IBAction func didTappedSave(_ sender: Any) {
      
        saveClicked()
    }
    
    // Image Picker //
    @IBAction func editPicture(_ sender: Any) {
        imagePicker.allowsEditing = false
        let Alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let CameraAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { ACTION in
            self.showCamera()
            }
    
        let GalleryAction: UIAlertAction = UIAlertAction(title: "Gallery", style: .default) { ACTION in
            self.showGallery()
        }
        let CancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        CancelAction.setValue(UIColor.red, forKey: "titleTextColor")

        Alert.addAction(CameraAction)
        Alert.addAction(GalleryAction)
        Alert.addAction(CancelAction)
        present(Alert, animated: true, completion: nil)
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
            
            /***********************Image upload api*******************************/
            getFirebaseToken()
            self.uploadImage(image: pickedImage, id: PrefsManager.sharedinstance.userId, completion: { url in
                
                if let url_str = url {
                    
                   LoadingHepler.instance.show()
                    
                    let apiclient : ApiClient = ApiClient()
                    let imageRemove = PrefsManager.sharedinstance.imageURL.replacingOccurrences(of: "/images/users/", with: "")
                    let header : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(self.token_str)"]
                    apiclient.deleteImage(id: PrefsManager.sharedinstance.userId, image: imageRemove, headers: header, completion: { status in
                        
                        apiclient.getFireBaseImageUrl(imagepath: url_str, completion: { url in
                            
                            LoadingHepler.instance.hide()
                            
                            if url != "empty" {
                                
                                PrefsManager.sharedinstance.imageURL = url_str
                                Manager.shared.loadImage(with:URL(string:url)!, into: self.profileImage)
                                
                            } else {
                                
                                AlertProvider.Instance.showAlert(title: "Oops!", subtitle: "Image upload failed", vc: self)
                                
                            }
                            
                        })
                        
                        
                    })
                  
                } else {
                    
                    LoadingHepler.instance.hide()
                    AlertProvider.Instance.showAlert(title: "Oops!", subtitle: "Image upload failed", vc: self)
                }
                
                
            })
        }
        dismiss(animated: true, completion: nil)
    }
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func setNavBar() {
        navigationItemList.title = "Edit Profile"
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "ic_arrow_back"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(EventViewController.backButtonClicked), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        let leftButton =  UIBarButtonItem(customView: button)
        leftButton.isEnabled = true
        
     // Another method to add right bar button item
        
//        let button2: UIButton = UIButton(type: UIButtonType.custom)
//        button2.addTarget(self, action: #selector(SettingsEdit_ProfieViewController.saveClicked), for: UIControlEvents.touchUpInside)
//        button2.frame = CGRect(x: 0, y: 0, width: 100, height: 22)
//        let rightButton =  UIBarButtonItem(customView: button2)
//        rightButton.title = "Save"
//        rightButton.titleTextAttributes(for: UIControlState.normal)
//        if let font = UIFont(name: "Avenir-Medium", size: 15) {
//            rightButton.setTitleTextAttributes([NSFontAttributeName:font], for: .normal)
//        }
//
//        rightButton.isEnabled = true
        
        //        let rightButton = UIBarButtonItem(title: "Save", for: UIControlEvents.touchUpInside, style: .plain, target: self, action: #selector(saveClicked))
        //        rightButton.isEnabled = true
        //        navigationItemList.rightBarButtonItem = rightButton
        
        
        let button2 = UIButton.init(type: .custom)
        button2.setTitle("Save", for: .normal)
        button2.setTitleColor(.darkGray, for: .normal)
        button2.setTitleColor(UIColor(displayP3Red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1.0), for: .normal)
        button2.addTarget(self, action: #selector(self.saveClicked), for: .touchUpInside)
        if let font = UIFont(name: "Avenir-Medium", size: 16) {
            navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName:font], for: .normal)
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button2)

//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveClicked))
//        navigationItem.rightBarButtonItem?.tintColor = UIColor(displayP3Red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1.0)
//       navigationItem.rightBarButtonItem?.titleTextAttributes(for: .normal)
       

        navigationItemList.leftBarButtonItem = leftButton
//        navigationItemList.rightBarButtonItem = button2
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
                
                ediprofileApi()
                
                
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
    func buttonClicked(sender: Any){
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
                dropDownAdjustView.isHidden = true
            }
            
            guard tagnamearray.count > 0 else {
                
                return cell!
            }
            cell?.selectionStyle = .none
            cell?.backgroundColor = UIColor.white
            cell?.textLabel?.text = tagnamearray[indexPath.row]
            cell?.textLabel?.font = UIFont(name: "Avenir-Medium", size: 14)
            cell?.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
//            view.transform = view.transform.rotated(by angle: CGFloat(45 * M_PI / 180))
//            cell?.backgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1.0)
            cell?.textLabel?.textColor = UIColor(red: 129/255.0, green: 135/255.0, blue: 155/255.0, alpha: 1.0)
            return cell!
            
            
        } else {
            
            var cell : UITableViewCell? = citytableview.dequeueReusableCell(withIdentifier: "cell")
            if(cell == nil)
            {
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
                citytableview.isHidden = true
            }
            
            guard autocompleteplaceArray.count > 0 else {
                
                return cell!
            }
            cell?.selectionStyle  = .none
            cell?.backgroundColor = UIColor.white
            cell?.textLabel?.text = autocompleteplaceArray[indexPath.row]
            cell?.textLabel?.font = UIFont(name: "Avenir-Medium", size: 14)
            cell?.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell?.textLabel?.textColor = UIColor(red: 129/255.0, green: 135/255.0, blue: 155/255.0, alpha: 1.0)
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
            

        } else {
            
            
        }

    }
    
   
}

extension SettingsEdit_ProfieViewController : Profile_PostViewControllerDelegae {
    
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

extension SettingsEdit_ProfieViewController {
    
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
                            }else if self.tagnamearray.count == 0 {
                                self.dropDownAdjustView.isHidden = true
                                self.dropdownTableView.isHidden  = true
                                self.dropAdjustViewEqualHeight.constant   = 0
                            }
                        }else {
                            self.dropAdjustViewEqualHeight.constant   = 165
                        }
                    }
                }else {
                    self.showPopup(table1: true, table2: true)
                    self.dropDownAdjustView.isHidden = true

                }
                
            } else {
                
                DispatchQueue.main.async {
                    self.dropdownTableView.reloadData()
                    self.showPopup(table1: true, table2: true)
                    self.dropDownAdjustView.isHidden = true

                }
                
            }
        })
        
    }
    
    func getFirebaseToken() {
        
        apiClient.getFireBaseToken(completion:{ token in
            
            self.token_str = token
            
        })
        
    }
   
    func focusEdittext(textfield : UITextField,focus:Bool) {
       
        switch textfield {
            
        case nameTextfield:
            
            nameLabel.textColor       = focus ? UIColor.textfieldFocus() : UIColor.labelunfocus()
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
            
            foodlabel.textColor       = focus ? UIColor.textfieldFocus() : UIColor.labelunfocus()
            foodview.backgroundColor  = focus ? UIColor.textfieldFocus() : UIColor.textfieldUnfocus()
            
        case usernameTextField:
            
            usernamelabel.textColor       = focus ? UIColor.textfieldFocus() : UIColor.labelunfocus()
            usernameview.backgroundColor  = focus ? UIColor.textfieldFocus() : UIColor.textfieldUnfocus()
            
        case descriptionTextField:
            
            descriptionlabel.textColor       = focus ? UIColor.textfieldFocus() : UIColor.labelunfocus()
            descriptionview.backgroundColor  = focus ? UIColor.textfieldFocus() : UIColor.textfieldUnfocus()
            
        default:
            
            nameLabel.textColor       = focus ? UIColor.textfieldFocus() : UIColor.labelunfocus()
            nameview.backgroundColor  = focus ? UIColor.textfieldFocus() : UIColor.textfieldUnfocus()
            
        }
   
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
                                
                                self.citytableview.reloadData()
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            case .failure(let error):
                print(error)
                
                DispatchQueue.main.async {
                    
                    self.citytableview.reloadData()
                    
                }
                
            }
            
        }
        
    }
    
    func showPopup(table1: Bool,table2 : Bool) {
        dropDownAdjustView.isHidden = table2
        citytableview.isHidden      = table1
        dropdownTableView.isHidden  = table2
        
        if table1 == false || table2 == false {
            
            self.datePickerValueChanged(sender: datePicker)
            datePicker.isHidden = true
            superVieww.isHidden = true
            doneView.isHidden = true
            cancelDatePicker.isHidden = true
            


            
        }
   
    }
    
    /*********************************setuserdetails********************************************/

    
    func setUserDetails() {
        
        nameTextfield.text = PrefsManager.sharedinstance.name
        emailaddress.text  = PrefsManager.sharedinstance.userEmail
        cityTextfield.text = PrefsManager.sharedinstance.userCity
        descriptionTextField.text = PrefsManager.sharedinstance.description
        usernameTextField.text    = PrefsManager.sharedinstance.username
        
        if PrefsManager.sharedinstance.userCityId == 0 {
            
            cityDictonary = nil
            
        } else {
            
            cityDictonary = ["id" : PrefsManager.sharedinstance.userCityId]
        }
        
        if PrefsManager.sharedinstance.gender == 0 {
            
            genderTextfield.text = "Male"
            
        } else {
            
             genderTextfield.text = "Female"
            
        }
        
        getDateDetails()
        
            let apiclient : ApiClient = ApiClient()
            apiclient.getFireBaseImageUrl(imagepath: PrefsManager.sharedinstance.imageURL, completion: { url in
            
            if url != "empty" {
                
                Manager.shared.loadImage(with:URL(string:url)!, into: self.profileImage)
                
            }
            
           })
        
        /**************/
        tagArray.removeAll()
        tagArrayList = PrefsManager.sharedinstance.tagList
        if tagArrayList.count > 0 {
            
            for item in tagArrayList {
                
                if let tagName = item.text_str,let tagid = item.id_str {
                    
                    tagArray.append(tagName)
                    let tagItem = ["id": tagid,"displayorder":tagArray.count] as [String : Any]
                    tagsDictonary.append(tagItem)
                }
                
                
                
            }
            
            collectionView.reloadData()
            
          }
        
        /**********/
        
     }
    func getDateDetails(){
        let date = DateFormatterManager.sharedinstance.stringtoDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", date: PrefsManager.sharedinstance.dateOfBirth)
        
        if let dateStr = DateFormatterManager.sharedinstance.datetoString(format: "dd", date: date) {
            
            dateLabel.text = dateStr
            
        }
        
        if let monthStr = DateFormatterManager.sharedinstance.datetoString(format: "MM", date: date) {
            
            monthLabel.text = monthStr
            
        }
        
        if let yearStr = DateFormatterManager.sharedinstance.datetoString(format: "yyyy", date: date) {
            
            yearLabel.text = yearStr
            
        }
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
}


extension SettingsEdit_ProfieViewController {
    
    /****************************************complete signup******************************************************/
    
    func ediprofileApi() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let birthdate : String = dateFormatter.string(from: self.datePicker.date)
        
        print(tagsDictonary)
        print(cityDictonary ?? ["name" : "unknown"])
        print(usernameTextField.text!)
        print(nameTextfield.text!)
        print(descriptionTextField.text!)
        print(birthdate)
        print(emailaddress.text!)
        print(profileImage)
        
        let clientIp = ValidationHelper.Instance.getIPAddress() ?? "1.0.1"
        var gender : Int = 0
        if genderTextfield.text == "Female" {
            
            gender = 1
            
        }
        
        let userid = PrefsManager.sharedinstance.userId
        LoadingHepler.instance.show()
        
        let header     : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token_str)"]
        let parameters: Parameters = ["username": usernameTextField.text!, "name":nameTextfield.text! , "description" : descriptionTextField.text!,"dateofbirth": birthdate, "gender": gender as Int,"tags":tagsDictonary,"isbusinessuser": false as Bool,"email": emailaddress.text! ,"citylocation":cityDictonary ?? [],"clientip": clientIp, "clientapp": Constants.clientApp]
        
        apiClient.editProfileApi(parameters: parameters,id: userid,headers: header,completion:{status, Values in

            print("statusfb: \(status)")
            if status == "success" {

                LoadingHepler.instance.hide()

                if let user = Values {

                    self.getUserDetails(user: user)
                    let alert = UIAlertController(title: "Hey!", message: "Profile updated successfully.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        
                        let storyboard = UIStoryboard(name: Constants.Main, bundle: nil)
                        let vc         = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsViewController
                        vc.delegate    = self as? SettingsViewControllerDelegate
                        self.navigationController?.popViewController(animated: true)
                        
                    }))
                    self.present(alert, animated: true, completion: nil)

                } else {

                    LoadingHepler.instance.hide()
                    AlertProvider.Instance.showAlert(title: "Oops!", subtitle: "Some error occured.", vc: self)

                }


            } else {

                LoadingHepler.instance.hide()

                if let user = Values {

                    if let meassage = user.errormessage {

                        AlertProvider.Instance.showAlert(title: "Oops!", subtitle: meassage, vc: self)

                        return
                    }

                }

                AlertProvider.Instance.showAlert(title: "Oops!", subtitle: "Some error occured.", vc: self)

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
    
}

