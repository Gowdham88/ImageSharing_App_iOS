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

var dropdownArray = [String] ()
var dropdownString = String ()
var tagArray = [String] ()
var selectedIndex = Int()
var autocompleteUrls = [String]()

class Edit_ProfileVC: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,GMSAutocompleteViewControllerDelegate {
    
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
    
    @IBOutlet var myscrollView: UIScrollView!
   
    @IBOutlet var saveButton: UIButton!
    let locationManager = CLLocationManager()

    let imagePicker = UIImagePickerController()
//    static private let regexEmail = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
//    static private let regexMobNo = "^[0-9]{6,15}$"
//    static private let regexNameType = "^[a-zA-Z]+$"
    
    
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
   
        imagePicker.delegate = self
        profileImage.isUserInteractionEnabled = true
        datePicker.isHidden = true
        superVieww.isHidden = true
        doneView.isHidden = true
//        superVieww.addSubview(datePicker)
        nameTextfield.delegate = self
        emailaddress.delegate = self
        genderTextfield.delegate = self
        cityTextfield.delegate = self
        birthTextfield.delegate = self
        foodTextfield.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(Edit_ProfileVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(Edit_ProfileVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        genderdropButton.addTarget(self, action: #selector(genderClicked), for: UIControlEvents.allTouchEvents)
        doneButotn.addTarget(self, action: #selector(doneClick), for: UIControlEvents.allTouchEvents)
        addButton.addTarget(self, action: #selector(addClicked), for: UIControlEvents.allTouchEvents)

   // bottom border for textfields //
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(red: 232/255.0, green: 233/255.0, blue: 247/255.0, alpha: 1.0).cgColor
        border.frame = CGRect(x: 0, y: nameTextfield.frame.size.height - width, width:  nameTextfield.frame.size.width, height: nameTextfield.frame.size.height)
        border.borderWidth = width
        nameTextfield.layer.addSublayer(border)
        nameTextfield.layer.masksToBounds = true

        
        let border2 = CALayer()
        let width2 = CGFloat(1.0)
        border2.borderColor = UIColor(red: 232/255.0, green: 233/255.0, blue: 247/255.0, alpha: 1.0).cgColor
        border2.frame = CGRect(x: 0, y: emailaddress.frame.size.height - width2, width:  emailaddress.frame.size.width, height: emailaddress.frame.size.height)
        border2.borderWidth = width2
        emailaddress.layer.addSublayer(border2)
        emailaddress.layer.masksToBounds = true
        
        let border4 = CALayer()
        let width4 = CGFloat(1.0)
        border4.borderColor = UIColor(red: 232/255.0, green: 233/255.0, blue: 247/255.0, alpha: 1.0).cgColor
        border4.frame = CGRect(x: 0, y: genderTextfield.frame.size.height - width4, width:  genderTextfield.frame.size.width, height: genderTextfield.frame.size.height)
        border4.borderWidth = width4
        genderTextfield.layer.addSublayer(border4)
        genderTextfield.layer.masksToBounds = true
        
        let border5 = CALayer()
        let width5 = CGFloat(1.0)
        border5.borderColor = UIColor(red: 232/255.0, green: 233/255.0, blue: 247/255.0, alpha: 1.0).cgColor
        border5.frame = CGRect(x: 0, y: cityTextfield.frame.size.height - width5, width:  cityTextfield.frame.size.width, height: cityTextfield.frame.size.height)
        border5.borderWidth = width5
        cityTextfield.layer.addSublayer(border5)
        cityTextfield.layer.masksToBounds = true
        
        let border6 = CALayer()
        let width6 = CGFloat(1.0)
        border6.borderColor = UIColor(red: 232/255.0, green: 233/255.0, blue: 247/255.0, alpha: 1.0).cgColor
        border6.frame = CGRect(x: 0, y: foodTextfield.frame.size.height - width6, width:  foodTextfield.frame.size.width, height: foodTextfield.frame.size.height)
        border6.borderWidth = width6
        foodTextfield.layer.addSublayer(border6)
        foodTextfield.layer.masksToBounds = true
        
        
        let border7 = CALayer()
        let width7 = CGFloat(1.0)
        border7.borderColor = UIColor(red: 232/255.0, green: 233/255.0, blue: 247/255.0, alpha: 1.0).cgColor
        border7.frame = CGRect(x: 0, y: birthTextfield.frame.size.height - width7, width:  birthTextfield.frame.size.width, height: birthTextfield.frame.size.height)
        border7.borderWidth = width7
        birthTextfield.layer.addSublayer(border7)
        birthTextfield.layer.masksToBounds = true
        
        
        
        foodTextfield.addTarget(self, action: #selector(textFieldActive), for: UIControlEvents.allTouchEvents)

        dropdownArray = ["Chicken","Chicken chilli","Chicken manjurian","Chicken 65","Chicken fried rice","Grill chicken","Pizza","Burger","Sandwich","Mutton","Mutton chukka","Mutton masala","Mutton fry","Prawn","Gobi chilli","Panneer","Noodles","Mutton soup","Fish fry","Dry fish"]
        
        setNavBar()
        
        dropdownTableView.isHidden = true
        
        myscrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+100)
        
        saveButton.layer.cornerRadius = 25.0
        saveButton.clipsToBounds = true
        view.superview?.addSubview(saveButton)
        
        profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2
        profileImage.clipsToBounds = true
        
        self.editButton.layer.cornerRadius =  self.editButton.frame.size.height/2
        self.editButton.clipsToBounds = true
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.black,
             NSFontAttributeName: UIFont(name: "Avenir-Light", size: 16)!]

        // Do any additional setup after loading the view.
        
        if show == false {
            
            addCollectionContainer()

        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
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
    
    func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(show: true, notification: notification)

    }
    
    func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(show: false, notification: notification)

    }
    func adjustingHeight(show:Bool, notification:NSNotification) {
        // 1
//        var userInfo = notification.userInfo!
//        // 2
//        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
//        // 3
//        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
//        // 4
//        let changeInHeight = (CGRectGetHeight(keyboardFrame) + 40) * (show ? 1 : -1)
//        //5
//        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
//            self.bottomConstraint.constant += changeInHeight
//        })

//        self.myscrollView.isScrollEnabled = true
//        var info = notification.userInfo!
//        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
//
//        self.myscrollView.contentInset = contentInsets
//        self.myscrollView.scrollIndicatorInsets = contentInsets
//
//        var aRect : CGRect = self.view.frame
//        aRect.size.height -= keyboardSize!.height
//        if let activeField = self.foodTextfield {
//            if (!aRect.contains(activeField.frame.origin)){
//                self.myscrollView.scrollRectToVisible(activeField.frame, animated: true)
//            }
//        }
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    
    }
    
    /// TextField delegates ///
    
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
            
            searchAutocompleteEntriesWithSubstring(substring: substring)
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
        if textField == foodTextfield || textField == birthTextfield {
            foodTextfield.text = ""
            dropdownTableView.isHidden = true
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
//        let controller        = storyboard.instantiateViewController(withIdentifier: "signupvc")
        let controller        = storyboard.instantiateViewController(withIdentifier: "signupwithEmailVC")

//        let storyboard        = UIStoryboard(name: Constants.Main, bundle: nil)
//        let controller        = storyboard.instantiateViewController(withIdentifier: "SettingsVC")
        controller.view.frame = self.view.bounds;
        controller.willMove(toParentViewController: self)
        self.view.addSubview(controller.view)
        self.addChildViewController(controller)
        controller.didMove(toParentViewController: self)
    }
    
    @IBAction func didTappedSave(_ sender: Any) {
        let Email:NSString = emailaddress.text! as NSString

        if nameTextfield.text == "" || emailaddress.text == ""  || cityTextfield.text == "" || genderTextfield.text == ""   {
            let Alert = UIAlertController(title: "Oops", message: "Fields Cannot be empty", preferredStyle: UIAlertControllerStyle.alert)
            
            let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { _ in
            
            }
            
           Alert.addAction(OkAction)
            present(Alert, animated: true, completion: nil)
        } else {
           
            if isValidEmail(testStr: Email as String) == true {
                let storyboard = UIStoryboard(name: Constants.Main, bundle: nil)
                let vc         = storyboard.instantiateViewController(withIdentifier: "Profile_PostViewController")
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
    
    // Image Picker //
    
    @IBAction func editPicture(_ sender: Any) {
        imagePicker.allowsEditing = true
        
        let Alert = UIAlertController(title: "Select Source Type", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let CameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { ACTION in
            
//            self.imagePicker.sourceType = .camera
//            self.present(self.imagePicker, animated: true, completion: nil)
            
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
        
        
//        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profileImage.contentMode = .scaleToFill
            self.profileImage.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func setNavBar() {
                
        navigationItemList.title = "Complete Profile"
        
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
//        cell.foodtagLabel.sizeToFit()
        cell.removetagButton.tag = indexPath.row
        cell.removetagButton.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    let indexPath = collectionView.indexPathsForSelectedItems
//print("selected item index is",indexPath)
        let indexPath = collectionView.indexPathsForSelectedItems?.first
        let cell = collectionView.cellForItem(at: indexPath!) as? FoodPreferenceCollectionViewCell
  //      selectedIndex = (indexPath?.item)!
 //       print("selected index::::",selectedIndex)
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
        return autocompleteUrls.count
//        return 5
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = dropdownTableView.dequeueReusableCell(withIdentifier: "cell")
//        var cell : UITableViewCell? = (dropdownTableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell)
        var cell : UITableViewCell? = dropdownTableView.dequeueReusableCell(withIdentifier: "cell")
        if(cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.text = autocompleteUrls[indexPath.row]
        print("dropdown items are:::::",autocompleteUrls)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = dropdownTableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        
        let currentCell = dropdownTableView.cellForRow(at: indexPath!) as! UITableViewCell
        
        print(currentCell.textLabel!.text!)
        dropdownString = (currentCell.textLabel?.text)!
//        tagArray.append(dropdownString)
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
