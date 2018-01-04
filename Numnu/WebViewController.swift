//
//  WebViewController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/25/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController,WKNavigationDelegate {
    
     var webView: WKWebView!
     var url_str : String = "empty"
    @IBOutlet weak var navigationItemList: UINavigationItem!
    var forwardButton  : UIBarButtonItem?
    var backwardButton : UIBarButtonItem?
    var browserButton  : UIBarButtonItem?
    var progressView   : UIProgressView?
    var vcCount:Int = 0{
        didSet{
            navigationItem.title = "Count: \(vcCount)"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView(frame: self.view.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.navigationDelegate = self
        
        let url = NSURL (string: url_str);
        let requestObj = NSURLRequest(url: url! as URL);
        webView.load(requestObj as URLRequest);
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
  
        setNavBar()
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView!.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: 2)
        progressView!.setProgress(0, animated: true)
        progressView!.trackTintColor = UIColor.lightGray
        progressView!.tintColor = UIColor.blue
        self.view.insertSubview(webView, belowSubview: progressView!)
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        LoadingHepler.instance.hide()
     
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        progressView?.setProgress(0.0, animated: false)
        
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
       LoadingHepler.instance.hide()
        
        backwardButton?.isEnabled = webView.canGoBack
        forwardButton?.isEnabled  = webView.canGoForward
   
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (keyPath == "estimatedProgress") {
            
            progressView?.isHidden = webView.estimatedProgress == 1
            progressView?.setProgress(Float(webView.estimatedProgress), animated: true)
            
        }
        
    }
    
    
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    
    /******************Set navigation bar**************************/
    
    func setNavBar() {
        
        navigationItemList.title = url_str
        
        let button: UIButton = UIButton(type: UIButtonType.custom)
        //set image for button
        button.setImage(UIImage(named: "ic_arrow_back"), for: UIControlState.normal)
        //add function for button
        button.addTarget(self, action: #selector(WebViewController.backButtonClicked), for: UIControlEvents.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(customView: button)
        
        backwardButton = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(WebViewController.backWard))
        forwardButton  = UIBarButtonItem(title: ">", style: .plain, target: self, action:  #selector(WebViewController.forWard))
        browserButton  = UIBarButtonItem(title: "Safari", style: .plain, target: self, action:  #selector(WebViewController.browser))
       
        backwardButton?.tintColor = UIColor.black
        forwardButton?.tintColor  = UIColor.black
        browserButton?.tintColor  = UIColor.black
        
        backwardButton?.isEnabled = false
        forwardButton?.isEnabled  = false
        
        // Create two buttons for the navigation item
        navigationItemList.leftBarButtonItem = leftButton
        navigationItemList.rightBarButtonItems = [browserButton!,forwardButton!,backwardButton!]
        
        
    }
    
    func backButtonClicked() {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func backWard() {
        
        if webView.canGoBack {
            
            webView.goBack()
        }
        
    }
    
    func forWard() {
       
        if webView.canGoForward {
            
            webView.goForward()
        }
        
    }
    
    
    func browser() {
        
        if let link = URL(string: url_str) {
            
            UIApplication.shared.openURL(link)
            
        }
        
        }


}
