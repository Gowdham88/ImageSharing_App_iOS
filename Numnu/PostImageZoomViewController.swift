//
//  PostImageZoomViewController.swift
//  Numnu
//
//  Created by CZSM3 on 14/11/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

class PostImageZoomViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imagePhoto: UIImageView!
    var imagePassed = UIImage()
    
    var isPresented = true // This property is very important, set it to true initially
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        scrollView.zoomScale = 1.0
        // Do any additional setup after loading the view.
        self.imagePhoto.image = self.imagePassed
        imagePhoto.isUserInteractionEnabled = true
//        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
//        swipeUp.direction = UISwipeGestureRecognizerDirection.up
//        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.scrollView.addGestureRecognizer(swipeDown)

//        NotificationCenter.default.addObserver(self, selector: #selector(changeMode), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        

    }
    
    
    
    
    //working
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        if UIDevice.current.orientation.isLandscape {
//            print("landscape mode on")
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.myOrientation = .landscape
//
//        }else{
//            print("potrait mode on")
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.myOrientation = .portrait
//
//        }
//    }
   
   

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true

    }

    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
        case .portraitUpsideDown:
            text="PortraitUpsideDown"
        case .landscapeLeft:
            text="LandscapeLeft"
        case .landscapeRight:
            text="LandscapeRight"
        default:
            text="Another"
        }
        print("You have moved: \(text)")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)


    }
    
    override func viewDidDisappear(_ animated: Bool) {

    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                dismiss(animated: true, completion: nil)
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
                
            default:
                break
            }
        }
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imagePhoto
    }

    @IBAction func removeButton(_ sender: Any) {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.orientationLock = .portrait
        
        isPresented = false // Set this flag to NO before dismissing controller, so that correct orientation will be chosen for the bottom controller
        self.presentingViewController!.dismiss(animated: true, completion: nil);

        
//     dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
