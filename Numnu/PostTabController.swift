//
//  PostTabController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/9/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip



class PostTabController: UIViewController,IndicatorInfoProvider {
    
    @IBOutlet weak var postEventTableView: UITableView!
    var window : UIWindow?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postEventTableView.delegate   = self
        postEventTableView.dataSource = self

//        postEventTableView.sizeToFit()
        postEventTableView.estimatedRowHeight = 388
        postEventTableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: Constants.Tab4)
    }
    

}

extension PostTabController : UITableViewDelegate,UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postEventCell", for: indexPath) as! PostEventTableViewCell
        
        cell.delegate = self
        cell.postEventBookMark.tag = indexPath.row
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell : PostEventTableViewCell = tableView.cellForRow(at: indexPath) as! PostEventTableViewCell
        cell.contentView.backgroundColor = UIColor.white
        
        openStoryBoard()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {



        return UITableViewAutomaticDimension;
    }
    
}

extension PostTabController {
    
    
    func  openStoryBoard() {
        
        let storyboard = UIStoryboard(name: Constants.PostDetail, bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: Constants.PostDetailId)
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    
}

/**************custom delegate******************/

extension PostTabController : PostEventTableViewCellDelegate {
    
    func bookmarkPost(tag: Int) {
    
        share()
    
    }
    
    func share() {
        
        let optionMenu = UIAlertController(title:"Post", message: "", preferredStyle: .actionSheet)
        
        let Bookmark = UIAlertAction(title: "Bookmark", style: .default, handler: {
            
            (alert : UIAlertAction!) -> Void in
            
            self.window    = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: Constants.Auth, bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "signupvc")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
        })
        
        let Share = UIAlertAction(title: "Share", style: .default, handler: {
            
            (alert : UIAlertAction!) -> Void in
            
        })
        
        let Cancel = UIAlertAction(title: "Cancel", style: .default, handler: {
            
            (alert: UIAlertAction!) -> Void in
            
        })
    
        optionMenu.addAction(Bookmark)
        optionMenu.addAction(Share)
        optionMenu.addAction(Cancel)
       
        optionMenu.popoverPresentationController?.sourceView = self.view
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        self.present(optionMenu, animated: true, completion: nil)
    
    }
}


