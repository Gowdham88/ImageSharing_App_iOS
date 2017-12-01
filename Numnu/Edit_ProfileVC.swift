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

class Edit_ProfileVC: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UICollectionViewDelegateFlowLayout {
    var dropdownArray = [String] ()
    var dropdownString = String ()
    var tagArray = [String] ()
    var selectedIndex = Int()
    var autocompleteUrls = [String]()
    var cancelBool : Bool = true
    
    
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
    let locationManager = CLLocationManager()
    var Alert = UIAlertController()
    //Upload Image Declaration
    let imagePicker = UIImagePickerController()
    var pickedImagePath: NSURL?
    var pickedImageData: NSData?
    var localPath: String?
    var apiClient : ApiClient!
    var autocompleteplaceArray = [String]()
    /***************Tags array*****************/

    var tagidArray   = [Int]()
    var tagnamearray = [String]()
/*
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
 */
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        imagePicker.delegate = self
        profileImage.isUserInteractionEnabled = true
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
        
        let sampleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(recognizer:)))
       
        Alert.view.isUserInteractionEnabled = true
        Alert.view.addGestureRecognizer(sampleTapGesture)
    IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:))as Selector)
//        self.view.addGestureRecognizer(tapGesture)
//
        
        showPopup(table1: true, table2: true)
        
        genderdropButton.addTarget(self, action: #selector(genderClicked), for: UIControlEvents.allTouchEvents)
        doneButotn.addTarget(self, action: #selector(doneClick), for: UIControlEvents.allTouchEvents)
        addButton.addTarget(self, action: #selector(addClicked), for: UIControlEvents.allTouchEvents)
        cancelDatePicker.addTarget(self, action: #selector(dateCancelClicked), for: UIControlEvents.allTouchEvents)

        foodTextfield.addTarget(self, action: #selector(textFieldActive), for: UIControlEvents.allTouchEvents)
        
//        let navigationOnTap = UITapGestureRecognizer(target: self, action: #selector(Edit_ProfileVC.navigationTap))
//        self.navigationController?.navigationBar.addGestureRecognizer(navigationOnTap)
//        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        
        
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
        
            cityTableView.layer.shadowColor = UIColor.darkGray.cgColor
            cityTableView.backgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha:1.0)
            cityTableView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            cityTableView.layer.shadowOpacity = 2.0
            cityTableView.layer.shadowRadius = 5
            cityTableView.layer.cornerRadius = 10
            cityTableView.clipsToBounds = true
            cityTableView.layer.masksToBounds = false
        
        dropdownTableView.layer.shadowColor = UIColor.darkGray.cgColor
        dropdownTableView.backgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1.0)
        dropdownTableView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        dropdownTableView.layer.shadowOpacity = 2.0
        dropdownTableView.layer.shadowRadius = 5
        dropdownTableView.layer.cornerRadius = 10
        dropdownTableView.clipsToBounds = true
        dropdownTableView.layer.masksToBounds = false

        
        // Checking users login
        /***********************Api login******************************/
        apiClient = ApiClient()
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
            let navigationOnTap = UITapGestureRecognizer(target:self,action:#selector(EventViewController.navigationTap))
            self.navigationController?.navigationBar.addGestureRecognizer(navigationOnTap)
            self.navigationController?.navigationBar.isUserInteractionEnabled = true
        // Hide the navigation bar on the this view controller
        showPopup(table1: true, table2: true)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//        if PrefsManager.sharedinstance.isLoginned {
//            addProfileContainer()
//        } else {
            if boolForTitle == false {
                if PrefsManager.sharedinstance.isLoginned {
                    addProfileContainer()
                } else{
                    
                addCollectionContainer()
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
       showPopup(table1: true, table2: true)
       
        let offset = CGPoint(x: 0,y :0)
        myscrollView.setContentOffset(offset, animated: true)
    }
    func dateCancelClicked() {
        cancelBool == true
        datePicker.isHidden = true
        doneView.isHidden = true
        superVieww.isHidden = true
        birthTextfield.text = ""
    }
    func addClicked() {
        if foodTextfield.text == "" {
          print("could not add empty fields")
        }else{
            if tagArray.contains(foodTextfield.text!){
                print("already added in collectionview")
            }else{
                tagArray.append(foodTextfield.text!)
                dropdownTableView.isHidden = true
            }
            print("the appended item is:::::",foodTextfield.text!)
            //        tagArray.remove(at: 1)
            if let index = tagArray.index(of:"") {
                tagArray.remove(at: index)
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

         Alert = UIAlertController(title: "Select Gender", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
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
            dropdownTableView.isHidden = true
            
        } else if textField == cityTextfield {
            
            cityTableView.isHidden  = true
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == foodTextfield {
            
            dropdownTableView.isHidden = false
            let substring = (foodTextfield.text! as NSString).replacingCharacters(in: range, with: string )
            loadTagList(tag: substring)
            
        } else if textField == cityTextfield {
            
            if let place = textField.text {
                
                getPlaceApi(place_Str: "\(place)\(string)" as String)
                
            }
          
            
            cityTableView.isHidden  = false
            
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

        if textField == birthTextfield {
            showDatePicker()
            birthTextfield.resignFirstResponder()
            datePicker.isHidden = false
            superVieww.isHidden = false
            doneView.isHidden = false
            showPopup(table1: true, table2: true)
        }else if textField == cityTextfield {
            showPopup(table1: false, table2: true)
            
          

        } else if textField == genderTextfield {
            showPopup(table1: true, table2: true)

           genderTextfield.resignFirstResponder()
           showGenderActionsheet()
        }else if textField == foodTextfield {
            showPopup(table1: true, table2: false)
        }else{
            showPopup(table1: true, table2: true)
        }
}
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        focusEdittext(textfield: textField,focus: false)

        if textField == usernameTextField {
            let parameters: Parameters = ["checkusername": usernameTextField.text!]
            let userNameRequest: ApiClient = ApiClient()
            userNameRequest.usernameexists(parameters: parameters, completion:{status, Exists in
                if Exists == true {
                    print("the username already exists")
                }else{
                    print("the username available")
                }
            })
        }
        if textField == foodTextfield || textField == birthTextfield  {
            foodTextfield.text = ""
            animateViewMoving(up: false, moveValue: 0)
            showPopup(table1: true, table2: true)
        }
        if textField == birthTextfield {
            if cancelBool == true {
                birthTextfield.text = ""
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
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            self.cityTableView.isHidden = true
        }, completion: nil)
        
        dismissKeyboard()
        
        if textField == cityTextfield {
            
            cityTextfield.text = ""
            
        }
        
        return false
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
        // Creates the toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.blue
        toolBar.sizeToFit()
        datePicker.addTarget(self, action: #selector(Edit_ProfileVC.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    func doneClick() {
        birthTextfield.resignFirstResponder()
        self.view.endEditing(true)
        superVieww.isHidden = true
        datePicker.isHidden = true
        doneView.isHidden = true
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
    
    func addProfileContainer(){
        
        let storyboard        = UIStoryboard(name: Constants.Main, bundle: nil)
        let controller        = storyboard.instantiateViewController(withIdentifier: "Profile_PostViewController") as! Profile_PostViewController
        controller.delegate   = self
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    @IBAction func didTappedSave(_ sender: Any) {
        upload(image: profileImage.image!, completion: { URL in
        })
        let Email:NSString = emailaddress.text! as NSString
        if nameTextfield.text == "" || emailaddress.text == ""  || cityTextfield.text == "" || genderTextfield.text == "" || usernameTextField.text == ""  {
            AlertProvider.Instance.showAlert(title: "Oops", subtitle: "Fields Cannot be empty", vc: self)
        } else {
            if isValidEmail(testStr: Email as String) == true {
                PrefsManager.sharedinstance.isLoginned = true
                let storyboard = UIStoryboard(name: Constants.Main, bundle: nil)
                let vc         = storyboard.instantiateViewController(withIdentifier: "Profile_PostViewController") as! Profile_PostViewController
                vc.boolForBack = false
                vc.delegate    = self
                self.navigationController!.pushViewController(vc, animated: true)
                let parameters: Parameters = ["username": usernameTextField.text!, "firstname":nameTextfield.text! , "lastname" : "" ,"firebaseuid" : "bIBh7fZXL1OP7NkGJIsPHucAPQA3" ,"dateofbirth": birthTextfield.text! , "gender": genderTextfield.text! ,"isbusinessuser": "0" , "email": emailaddress.text! ,  "citylocationid": "1", "createdby": "2" , "updatedby": "2" , "clientApp": "iosapp"  , "clientip": "765.768.7868.8888"  ]
                let completeSignupApi: ApiClient = ApiClient()
                completeSignupApi.completeSignup(parameters: parameters, completion:{status, Values in
                    if status == "success" {
                        print("Values from json:::::::",Values!)
                    }else {
                    }
                })
            }else {
                AlertProvider.Instance.showAlert(title: "Oops", subtitle: "Please Enter Valid Email ID", vc: self)
            }
        }
    }
    
    func upload(image: UIImage, completion: (URL?) -> Void) {
        guard let data = UIImageJPEGRepresentation(image, 0.9) else {
            return
        }
        Alamofire.upload(multipartFormData: { (form) in
            form.append(data, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
        }, to: "https://numnu-server-dev.appspot.com/users/1/images", encodingCompletion: { result in
            switch result {
            case .success(let upload, _, _):
                upload.responseString { response in
                    print(response.value)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    
    // Image Picker //
     @IBAction func editPicture(_ sender: Any) {
        imagePicker.allowsEditing = false
        let Alert = UIAlertController(title: "Select Source Type", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let CameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { ACTION in
            if !UIImagePickerController.isSourceTypeAvailable(.camera){
                let alertController = UIAlertController.init(title: nil, message: "Device has no camera.", preferredStyle: .alert)
                let okAction = UIAlertAction.init(title: "Alright", style: .default, handler: {(alert: UIAlertAction!) in
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else{
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        let GalleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default) { ACTION in
       
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let CancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) {_ in
        }
        Alert.addAction(CameraAction)
        Alert.addAction(GalleryAction)
        Alert.addAction(CancelAction)
//        present(Alert, animated: true, completion: nil)
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            Alert.popoverPresentationController?.sourceView = self.view
            Alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
            present(Alert, animated: true, completion:nil )
        }else{
            present(Alert, animated: true, completion:nil )
        }
        
        present(imagePicker, animated: true, completion: nil)
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
        navigationItemList.title = "Complete Signup"
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "ic_arrow_back"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(EventViewController.backButtonClicked), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        let leftButton =  UIBarButtonItem(customView: button)
        leftButton.isEnabled = true
        let rightButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItemList.leftBarButtonItem = leftButton
        navigationItemList.rightBarButtonItem = rightButton
    }
   
    func backButtonClicked() {
        _ = self.navigationController?.popViewController(animated: true)
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
        return CGSize(width: textSize.width+50, height: 22)
    }
    func buttonClicked(sender: Any){
        let tag = (sender as AnyObject).tag
        tagArray.remove(at: tag!)
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
            cell?.textLabel?.text = tagnamearray[indexPath.row]
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
//            cell?.backgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1.0)
            cell?.textLabel?.text = autocompleteplaceArray[indexPath.row]
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
        if let indexPath = dropdownTableView.indexPathForSelectedRow  {
            let currentCell = dropdownTableView.cellForRow(at: indexPath)
            dropdownString = (currentCell?.textLabel?.text)!
            if tagArray.contains(dropdownString) {
                print("already exist")
            }else{
                tagArray.append(dropdownString)
            }
            collectionView.reloadData()
            dropdownTableView.isHidden = true
            foodTextfield.resignFirstResponder()
        } else if let indexPath = cityTableView.indexPathForSelectedRow  {
            let currentCell = cityTableView.cellForRow(at: indexPath)
            cityTextfield.text = (currentCell?.textLabel?.text)!
            cityTableView.isHidden = true
            cityTextfield.resignFirstResponder()
            
        }
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
        let header     : HTTPHeaders = ["Accept-Language" : "en-US"]
        apiClient.getTagsApi(parameters: parameters, headers: header, completion: { status,taglist in
            if status == "success" {
                if let tagList = taglist {
                    if tagList.id != nil {
                        self.tagidArray = tagList.id!
                    }
                    if tagList.text != nil {
                        self.tagnamearray = tagList.text!
                    }
                    DispatchQueue.main.async {
                        self.dropdownTableView.reloadData()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.dropdownTableView.reloadData()
                }
            }
        })
    }
    
    
    /************************City Api****************************/
    
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
                                
                                self.cityTableView.reloadData()
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            case .failure(let error):
                print(error)
                
                DispatchQueue.main.async {
                    
                    self.cityTableView.reloadData()
                    
                }
                
            }
            
        }
        
    }
    
    func showPopup(table1: Bool,table2 : Bool){
    
        cityTableView.isHidden      = table1
        dropdownTableView.isHidden  = table2
     
    }
}
