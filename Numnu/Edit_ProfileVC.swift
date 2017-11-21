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

class Edit_ProfileVC: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,GMSAutocompleteViewControllerDelegate {
    var dropdownArray = [String] ()
    var dropdownString = String ()
    var tagArray = [String] ()
    var selectedIndex = Int()
    var autocompleteUrls = [String]()
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
//    @IBOutlet var usernameTextfield: UITextField!
    
    @IBOutlet var birthTextfield: UITextField!
    
    @IBOutlet var foodTextfield: UITextField!
    
    @IBOutlet weak var navigationItemList: UINavigationItem!
    var show : Bool = false
    var boolForTitle: Bool = false
//    var showProfile: Bool = true
    @IBOutlet var myscrollView: UIScrollView!
   
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
    let locationManager = CLLocationManager()
    
    //Upload Image Declaration
    let imagePicker = UIImagePickerController()
    var pickedImagePath: NSURL?
    var pickedImageData: NSData?
    
    var localPath: String?

    var apiClient : ApiClient!
//    static private let regexEmail = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
//    static private let regexMobNo = "^[0-9]{6,15}$"
//    static private let regexNameType = "^[a-zA-Z]+$"
    
    /***************Tags array*****************/

    var tagidArray   = [Int]()
    var tagnamearray = [String]()
    
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
//        let parameters: Parameters = ["checkusername":"siva"]
//
//        let userNameRequest: ApiClient = ApiClient()
//        userNameRequest.usernameexists(parameters: parameters, completion:{status, Exists in
//
//            if Exists! {
//
//            }else{
//
//            }
//
//
//        })

        if PrefsManager.sharedinstance.isLoginned {

            addProfileContainer()

        } else {

            if boolForTitle == false {

                addCollectionContainer()

            }

        }

        imagePicker.delegate = self
        
        profileImage.isUserInteractionEnabled = true
        datePicker.isHidden = true
        superVieww.isHidden = true
        doneView.isHidden = true
//        superVieww.addSubview(datePicker)
        usernameTextField.delegate = self
        nameTextfield.delegate = self
        emailaddress.delegate = self
        genderTextfield.delegate = self
        cityTextfield.delegate = self
        birthTextfield.delegate = self
        foodTextfield.delegate = self
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
//        self.view.addGestureRecognizer(tapGesture)
        genderdropButton.addTarget(self, action: #selector(genderClicked), for: UIControlEvents.allTouchEvents)
        doneButotn.addTarget(self, action: #selector(doneClick), for: UIControlEvents.allTouchEvents)
        addButton.addTarget(self, action: #selector(addClicked), for: UIControlEvents.allTouchEvents)

        foodTextfield.addTarget(self, action: #selector(textFieldActive), for: UIControlEvents.allTouchEvents)

        dropdownArray = ["Chicken","Chicken chilli","Chicken manjurian","Chicken 65","Chicken fried rice","Grill chicken","Pizza","Burger","Sandwich","Mutton","Mutton chukka","Mutton masala","Mutton fry","Prawn","Gobi chilli","Panneer","Noodles","Mutton soup","Fish fry","Dry fish"]
        
        setNavBar()
        
        dropdownTableView.isHidden = true
        
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
      
        // Checking users login
        /***********************Api login******************************/
        
        apiClient = ApiClient()
      
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let offset = CGPoint(x: 0,y :0)
        myscrollView.setContentOffset(offset, animated: true)
       
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
            //        let nonOptionals = tagArray.flatMap{$0}
            //        print(nonOptionals)
            collectionView.reloadData()
            foodTextfield.resignFirstResponder()
        }
    }
    
    func genderClicked(){
        genderTextfield.resignFirstResponder()
        let Alert = UIAlertController(title: "Select Gender", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)

        let MaleAction = UIAlertAction(title: "Male", style: UIAlertActionStyle.default) { _ in
            self.genderTextfield.text = "Male"
            self.genderTextfield.resignFirstResponder()
        }
        let FemaleAction = UIAlertAction(title: "Female", style: UIAlertActionStyle.default) { _ in
            self.genderTextfield.text = "Female"
            self.genderTextfield.resignFirstResponder()
        }
        Alert.addAction(MaleAction)
        Alert.addAction(FemaleAction)
        present(Alert, animated: true, completion: nil)

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
    override func touchesBegan(_: Set<UITouch>, with: UIEvent?) {
        nameTextfield.resignFirstResponder()
        emailaddress.resignFirstResponder()
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
       
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        dropdownTableView.isHidden = false
        if textField == foodTextfield {
            let substring = (foodTextfield.text! as NSString).replacingCharacters(in: range, with: string )
            print("the substrings are::::",substring)
            
             loadTagList(tag: substring)
        }else{
        }
       
        return true     // not sure about this - cou
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
        if textField == birthTextfield {
            showDatePicker()
            birthTextfield.resignFirstResponder()
            datePicker.isHidden = false
            superVieww.isHidden = false
            doneView.isHidden = false
        }else if textField == cityTextfield {
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
        }else if textField == genderTextfield {
            genderTextfield.resignFirstResponder()
            
            let Alert = UIAlertController(title: "Select Gender", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let MaleAction = UIAlertAction(title: "Male", style: UIAlertActionStyle.default) { _ in
                self.genderTextfield.text = "Male"
                self.genderTextfield.resignFirstResponder()
                
            }
            let FemaleAction = UIAlertAction(title: "Female", style: UIAlertActionStyle.default) { _ in
                self.genderTextfield.text = "Female"
                self.genderTextfield.resignFirstResponder()
                
            }
            
            Alert.addAction(MaleAction)
            Alert.addAction(FemaleAction)
            
            present(Alert, animated: true, completion: nil)
        }else if textField == foodTextfield {
            dropdownTableView.isHidden = false
        }else{
            dropdownTableView.isHidden = true
        }
        
       
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
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
        if textField == foodTextfield || textField == birthTextfield {
            foodTextfield.text = ""
//            dropdownTableView.isHidden = true
            animateViewMoving(up: false, moveValue: 0)
        }
        if textField == birthTextfield {
            
            self.datePickerValueChanged(sender: datePicker)
            datePicker.isHidden = true
            superVieww.isHidden = true
            doneView.isHidden = true
        }
    }
   
    func animateViewMoving (up:Bool, moveValue :CGFloat){
    
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)

//        self.view.frame = offsetBy(self.view.frame, 0, movement)
        
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
        upload(image: profileImage.image!, completion: { URL in
            
        })
        let Email:NSString = emailaddress.text! as NSString

        if nameTextfield.text == "" || emailaddress.text == ""  || cityTextfield.text == "" || genderTextfield.text == ""   {
            let Alert = UIAlertController(title: "Oops", message: "Fields Cannot be empty", preferredStyle: UIAlertControllerStyle.alert)
            
            let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { _ in
            
            }
            
           Alert.addAction(OkAction)
            present(Alert, animated: true, completion: nil)
        } else {
           
            if isValidEmail(testStr: Email as String) == true {
                
                PrefsManager.sharedinstance.isLoginned = true
                
                let storyboard = UIStoryboard(name: Constants.Main, bundle: nil)
                let vc         = storyboard.instantiateViewController(withIdentifier: "Profile_PostViewController") as! Profile_PostViewController
                vc.delegate    = self
                self.navigationController!.pushViewController(vc, animated: true)
//                self.navigationController?.present(vc, animated: true, completion: nil)
                
            }else {
                let Alert = UIAlertController(title: "Oops", message: "Please Enter valid mail ID", preferredStyle: UIAlertControllerStyle.alert)
                
                let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { _ in
                }
                
                Alert.addAction(OkAction)
                present(Alert, animated: true, completion: nil)
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
        present(Alert, animated: true, completion: nil)
        
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
        
        _ = self.navigationController?.popToRootViewController(animated: true)
        
    }
    
/// collectionView for food preferences ///
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagArray.count
    }
    
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvcell", for: indexPath as IndexPath) as! FoodPreferenceCollectionViewCell
        cell.foodtagLabel.text = tagArray[indexPath.row]
        cell.foodtagLabel.layer.cornerRadius = 4.0
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
    func buttonClicked(sender: Any){
        
        let tag = (sender as AnyObject).tag
        tagArray.remove(at: tag!)
        collectionView.reloadData()
        print("selceted tag is:::::",tag!)

    }
    // Food Textfield action ///
    
    @IBAction func didTappedFoodtext(_ sender: Any) {
        
        dropdownTableView.isHidden = false
    }
    /// TableView Delegates and Datasources ///
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagnamearray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = dropdownTableView.dequeueReusableCell(withIdentifier: "cell")
        if(cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.text = tagnamearray[indexPath.row]
        
        return cell!
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
            
            let currentCell = dropdownTableView.cellForRow(at: indexPath) as! UITableViewCell
            
            print(tagidArray[(indexPath.row)])
            dropdownString = (currentCell.textLabel?.text)!
           
            if tagArray.contains(dropdownString) {
                print("already exist")
            }else{
                tagArray.append(dropdownString)
            }
            collectionView.reloadData()
            
            dropdownTableView.isHidden = true
            foodTextfield.resignFirstResponder()
            
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
    
    
}
