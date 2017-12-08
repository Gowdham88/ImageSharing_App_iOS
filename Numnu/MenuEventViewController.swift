//
//  MenuEventViewController.swift
//  Numnu
//
//  Created by CZ Ltd on 10/26/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip

protocol MenuEventViewControllerDelegate {
   
    func menuTableHeight(height : CGFloat)
}

class MenuEventViewController: UIViewController,IndicatorInfoProvider,UITableViewDelegate,UITableViewDataSource {
    
    var tagarray = ["Festival","Wine","Party","Rum","Barbaque","Pasta","Sandwich","Burger"]
    
    @IBOutlet weak var menuEventTableview: UITableView!
    @IBOutlet weak var menuCategoryTableview: UITableView!
    var showentity : Bool = false
    var menuDelegate : MenuEventViewControllerDelegate?
    var viewState    : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuEventTableview.delegate   = self
        menuEventTableview.dataSource = self
        
        menuCategoryTableview.delegate   = self
        menuCategoryTableview.dataSource = self
        
        menuCategoryTableview.isHidden = false
        menuEventTableview.isHidden    = true
        
        menuCategoryTableview.isScrollEnabled = false
        menuEventTableview.isScrollEnabled    = false
        
       

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        viewState = true
        menuCategoryTableview.reloadData()
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            self.menuDelegate?.menuTableHeight(height: self.menuCategoryTableview.contentSize.height)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: Constants.EventTab2)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.menuEventTableview {
            
            return 6
            
        } else {
            
            return 8
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.menuEventTableview {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuEventCell", for: indexPath) as! MenuItemEventCell
            
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "menucategoryCell", for: indexPath) as! MenuCategoryItemCell
            
            cell.eventCategoryLabel.text = tagarray[indexPath.row]
            
            return cell
            
        }
//        let tap = UITapGestureRecognizer(target: self, action: #selector(MenuEventViewController.imageTapped))
//        cell.postDEventImage.addGestureRecognizer(tap)
//        cell.postDEventImage.isUserInteractionEnabled = true
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastRowIndex = self.menuCategoryTableview.numberOfRows(inSection: 0)
        if indexPath.row == lastRowIndex - 1 && viewState {

            menuDelegate?.menuTableHeight(height: menuCategoryTableview.contentSize.height)
            viewState = false
        }
    }
//    func imageTapped() {
//        let storyboard = UIStoryboard(name: "PostDetail", bundle: nil)
//        let vc         = storyboard.instantiateViewController(withIdentifier: "PostImageZoomViewController")
//        self.navigationController?.present(vc, animated: true, completion: nil)
//    }
}

extension MenuEventViewController   {
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        openStoryBoard(name: Constants.EventDetail, id: Constants.MenuItemId,heading: tagarray[indexPath.row])
        
        
//        if tableView == menuEventTableview {
//
//            menuEventTableview.isHidden    = true
//            menuCategoryTableview.isHidden = false
//            if showentity {
//
//
//
//            } else {
//
//                openStoryBoard(name: Constants.ItemDetail, id: Constants.ItemDetailId)
//
//            }
//
//
//        } else {
//
//            menuEventTableview.isHidden    = false
//            menuCategoryTableview.isHidden = true
//
//
//        }
        
    }
    
    func openStoryBoard (name : String,id : String,heading : String) {
        
        let storyboard      = UIStoryboard(name: name, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: id) as! MenuItemViewController
        vc.heading          = heading
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    
}

extension MenuEventViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tagarray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventMenuTagCell", for: indexPath) as! EventTagCollectionCell
        
        let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: tagarray[indexPath.row], fontname: "Avenir-Medium", size: 12)
        
        cell.tagnamelabel.text = tagarray[indexPath.row]
        
        cell.setLabelSize(size: textSize)
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: tagarray[indexPath.row], fontname: "Avenir-Medium", size: 12)
        
        return CGSize(width: textSize.width+20, height: 22)
    }
    
    
    
}


