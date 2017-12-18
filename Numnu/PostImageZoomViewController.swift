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
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        scrollView.zoomScale = 1.0
        // Do any additional setup after loading the view.
        self.imagePhoto.image = self.imagePassed
        

        imagePhoto.isUserInteractionEnabled = true
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imagePhoto
    }

    @IBAction func removeButton(_ sender: Any) {
        
dismiss(animated: true, completion: nil)
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
