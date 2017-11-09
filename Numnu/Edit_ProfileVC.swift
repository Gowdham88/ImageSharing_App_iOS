//
//  Edit_ProfileVC.swift
//  Numnu
//
//  Created by CZ Ltd on 10/12/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
var dropdownArray = [String] ()
var dropdownString = String ()
var tagArray = [String] ()

class Edit_ProfileVC: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var dropdownTableView: UITableView!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var editButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailaddress: UITextField!
    
    @IBOutlet var cityTextfield: UITextField!
    @IBOutlet var genderTextfield: UITextField!
    @IBOutlet var usernameTextfield: UITextField!
    
    @IBOutlet var birthTextfield: UITextField!
    
    @IBOutlet var foodTextfield: UITextField!
    
    @IBOutlet weak var navigationItemList: UINavigationItem!
    var show : Bool = false
    
    @IBOutlet var myscrollView: UIScrollView!
   
    @IBOutlet var saveButton: UIButton!
    let imagePicker = UIImagePickerController()
//    static private let regexEmail = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
//    static private let regexMobNo = "^[0-9]{6,15}$"
//    static private let regexNameType = "^[a-zA-Z]+$"
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        profileImage.isUserInteractionEnabled = true

//        nameTextfield.useUnderline()
//        emailaddress.useUnderline()
//        usernameTextfield.useUnderline()
//        genderTextfield.useUnderline()
//        cityTextfield.useUnderline()
//        birthTextfield.useUnderline()
//        foodTextfield.useUnderline()
        
        foodTextfield.addTarget(self, action: #selector(textFieldActive), for: UIControlEvents.touchDown)

        dropdownArray = ["chicken","Pizza","Burger","Sandwich","Mutton","Prawn","Gobi chilli","Panneer"]
        
        setNavBar()
        
        dropdownTableView.isHidden = true
        
        myscrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+100)
        
        saveButton.layer.cornerRadius = 30.0
        saveButton.clipsToBounds = true
        
        profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2
        profileImage.clipsToBounds = true
        
        self.editButton.layer.cornerRadius =  self.editButton.frame.size.height/2
        self.editButton.clipsToBounds = true
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.black,
             NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 19)!]

        // Do any additional setup after loading the view.
        
        if show == false {
            
           // addCollectionContainer()
            
        }
        
    }
    
    func textFieldActive() {
        
        dropdownTableView.isHidden = false
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
        
//        if genderTextfield == true {
//            let Alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
//
//            let MaleAction = UIAlertAction(title: "MALE", style: UIAlertActionStyle.default) { _ in
//
//            }
//            let femaleAction = UIAlertAction(title: "FEMALE", style: UIAlertActionStyle.default) { _ in
//            }
//            Alert.addAction(MaleAction)
//            Alert.addAction(femaleAction)
//
//            self.present(Alert, animated: true, completion: nil)
//
//        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func addCollectionContainer(){
        
        let storyboard        = UIStoryboard(name: Constants.Auth, bundle: nil)
        let controller        = storyboard.instantiateViewController(withIdentifier: "signupvc")
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

        if nameTextfield.text == "" || emailaddress.text == "" || usernameTextfield.text == "" || cityTextfield.text == "" || genderTextfield.text == "" || foodTextfield.text == "" || birthTextfield.text == "" {
            let Alert = UIAlertController(title: "Oops", message: "Fields Cannot be empty", preferredStyle: UIAlertControllerStyle.alert)
            
            let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { _ in
            
            }
            
           Alert.addAction(OkAction)
            present(Alert, animated: true, completion: nil)
        } else {
           
            if isValidEmail(testStr: Email as String) == true {
              let Alert = UIAlertController(title: "Success", message: "Profile saved", preferredStyle: UIAlertControllerStyle.alert)
                
                let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { _ in
                    
                    self.dismiss(animated: true, completion: nil)
                }
                
                Alert.addAction(OkAction)
                present(Alert, animated: true, completion: nil)
                 
 
//                let storyboard        = UIStoryboard(name: Constants.Auth, bundle: nil)
//                let controller        = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as!SettingsViewController
//                self.navigationController?.pushViewController(controller, animated: true)
                
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
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        
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
        
       
        
        navigationItemList.title = "Profile"
        
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
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Food Textfield action ///
    
    @IBAction func didTappedFoodtext(_ sender: Any) {
        
        dropdownTableView.isHidden = false

    }
    
    /// TableView Delegates and Datasources ///
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropdownArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = dropdownTableView.dequeueReusableCell(withIdentifier: "cell")
//        var cell : UITableViewCell? = (dropdownTableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell)
        
        var cell : UITableViewCell? = dropdownTableView.dequeueReusableCell(withIdentifier: "cell")

        
        if(cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.text = dropdownArray[indexPath.row]
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
        
    }
}
