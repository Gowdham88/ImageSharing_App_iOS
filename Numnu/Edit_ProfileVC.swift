//
//  Edit_ProfileVC.swift
//  Numnu
//
//  Created by CZ Ltd on 10/12/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

class Edit_ProfileVC: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

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
        
        setNavBar()
        
        myscrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+100)
        
        saveButton.layer.cornerRadius = 30.0
        saveButton.clipsToBounds = true
        
        profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2
        profileImage.clipsToBounds = true
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.black,
             NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 21)!]

        // Do any additional setup after loading the view.
        
        if show == false {
            
            addCollectionContainer()
            
        }
        
        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if textField == genderTextfield {
            let Alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let MaleAction = UIAlertAction(title: "MALE", style: UIAlertActionStyle.default) { _ in
                
            }
            let femaleAction = UIAlertAction(title: "FEMALE", style: UIAlertActionStyle.default) { _ in
            }
            Alert.addAction(MaleAction)
            Alert.addAction(femaleAction)
                
            self.present(Alert, animated: true, completion: nil)

        }
        
        return true
    }
    
    func addCollectionContainer(){
        
        let storyboard        = UIStoryboard(name: Constants.Auth, bundle: nil)
        let controller        = storyboard.instantiateViewController(withIdentifier: "signupvc")
        controller.view.frame = self.view.bounds;
        controller.willMove(toParentViewController: self)
        self.view.addSubview(controller.view)
        self.addChildViewController(controller)
        controller.didMove(toParentViewController: self)
        
        
    }
    
    @IBAction func didTappedSave(_ sender: Any) {
        let Email:NSString = emailaddress.text! as NSString

        if nameTextfield.text == "" || emailaddress.text == "" || usernameTextfield.text == "" || cityTextfield.text == "" || genderTextfield.text == "" || foodTextfield.text == "" || birthTextfield.text == "" {
            let Alert = UIAlertController(title: "Oops", message: "Enter Username", preferredStyle: UIAlertControllerStyle.alert)
            
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

}
