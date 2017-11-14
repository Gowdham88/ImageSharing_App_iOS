//
//  PostdetailImageViewController.swift
//  Numnu
//
//  Created by CZSM3 on 13/11/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

class PostdetailImageViewController: UIViewController {
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var bottom: NSLayoutConstraint!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var fullImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        scrollview.delegate = self as? UIScrollViewDelegate
        
        scrollview.minimumZoomScale = 1.0
        scrollview.maximumZoomScale = 10.0//maximum zoom scale you want
        scrollview.zoomScale = 1.0
        
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return fullImageView
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        updateMinZoomScaleForSize(view.bounds.size)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
//        let widthScale = size.width / fullImageView.bounds.width
//        let heightScale = size.height / fullImageView.bounds.height
//        let minScale = min(widthScale, heightScale)
//
//        scrollview.minimumZoomScale = minScale
//        scrollview.zoomScale = minScale
//    }
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        updateConstraintsForSize(view.bounds.size)
//    }
//
//    fileprivate func updateConstraintsForSize(_ size: CGSize) {
//
//        let yOffset = max(0, (size.height - fullImageView.frame.height) / 2)
//        top.constant = yOffset
//        bottom.constant = yOffset
//
//        let xOffset = max(0, (size.width - fullImageView.frame.width) / 2)
//        leading.constant = xOffset
//        trailing.constant = xOffset
//
//        view.layoutIfNeeded()
//    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
