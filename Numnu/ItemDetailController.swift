//
//  ItemDetailController.swift
//  Numnu
//
//  Created by CZ Ltd on 11/1/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import Nuke

class ItemDetailController : ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var ItImageView: ImageExtender!
    @IBOutlet weak var ItTitleLabel: UILabel!
    
    
    @IBOutlet weak var ItDescriptionLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    
    @IBOutlet weak var myscrollView: UIScrollView!
    
    @IBOutlet weak var TabBarView: ButtonBarView!
    @IBOutlet weak var pagerView: UIScrollView!
    @IBOutlet weak var tagScrollView: UIScrollView!
    
    @IBOutlet weak var navigationItemList: UINavigationItem!
    
    @IBOutlet weak var mainContainerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var mainContainerView: NSLayoutConstraint!
    
    var tagarray = [String]()
    var entintyTagarray = [String]()
    
    /***************contraints***********************/
    
    @IBOutlet weak var eventDescriptionHeight : NSLayoutConstraint!
    @IBOutlet weak var containerViewTop : NSLayoutConstraint!
    @IBOutlet weak var barButtonTop : NSLayoutConstraint!
    @IBOutlet weak var shareView: UIView!
    
    @IBOutlet weak var businessEntityView : UIView!
    @IBOutlet weak var businessEntityImage: ImageExtender!
    @IBOutlet weak var businessEntityNameLabel: UILabel!
    @IBOutlet weak var businessEntityScrollview : UIScrollView!
    /***************Read more variable*********************/
    
    var isLabelAtMaxHeight = false
    
    /**********************************************/
    
    var apiClient : ApiClient!
    var description_txt : String = ""
    var itemprimaryid   : Int  = 39

    @IBOutlet weak var bookmarkItemDetlabel: UILabel!
    @IBOutlet weak var shareItemDetlabel: UILabel!
    
    /*******************share***************************/
    
    lazy var bookmarkid   : Int       = 0
    lazy var bookmarkname : String    = "name"
    lazy var bookmarktype : String    = "empty"
    
    /********************Constraints****************************/
    @IBOutlet weak var titleTopContraints: UIView!
    @IBOutlet weak var tagscroltopConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var businessEntintyTitleConstraint: NSLayoutConstraint!
    @IBOutlet weak var businessEntintScrollTop: NSLayoutConstraint!
    
    @IBOutlet weak var BusinessEntinyTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarItemFont = UIFont(name: "Avenir-Medium", size: 14)!
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        super.viewDidLoad()
        myscrollView.delegate = self
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = UIColor.appBlackColor()
         
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        buttonBarView.selectedBar.backgroundColor = UIColor.appThemeColor()
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.textlightDark()
            newCell?.label.textColor = UIColor.appBlackColor()
            
        }

        
        let centerImagetap = UITapGestureRecognizer(target: self, action: #selector(EventViewController.centerImagetap))
        ItImageView.addGestureRecognizer(centerImagetap)
        ItImageView.isUserInteractionEnabled = true
        /**********************set Nav bar****************************/
        
        setNavBar()
        
        /****************event label tap function************************/
        
        tapRegistration()
        alertTapRegister()
        myscrollView.isHidden = true
      
        /******************Api**************************/
        
        apiClient = ApiClient()
        getItemIdApi()
       

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let navigationOnTap = UITapGestureRecognizer(target:self,action:#selector(EventViewController.navigationTap))
        self.navigationController?.navigationBar.addGestureRecognizer(navigationOnTap)
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    func navigationTap(){
        let offset = CGPoint(x: 0,y :0)
        self.myscrollView.setContentOffset(offset, animated: true)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        reloadStripView()
    }
    
    func centerImagetap(){
        
        let storyboard = UIStoryboard(name: "PostDetail", bundle: nil)
        let vc         = storyboard.instantiateViewController(withIdentifier: "PostImageZoomViewController")
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_1 = UIStoryboard(name: Constants.EventDetail, bundle: nil).instantiateViewController(withIdentifier: Constants.EventTabid3) as! ReviewEventViewController
        child_1.popdelegate = self
        child_1.apiType     = "Item"
        child_1.primaryid   = 149
        let child_2 = UIStoryboard(name: Constants.ItemDetail, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid7)  as! LocationTabController
        child_2.locationdelegate = self
        child_2.primaryid        = 35
        child_2.type             = "Item"
        let child_3 = UIStoryboard(name: Constants.Tab, bundle: nil).instantiateViewController(withIdentifier: Constants.Tabid1) as! EventTabController
        child_3.eventdelegate   = self
        child_3.scrolltableview = false
        return [child_1,child_2]
        
    }
    
    @IBAction func ButtonReadMore(_ sender: UIButton) {
        
        if isLabelAtMaxHeight {
            
            readMoreButton.setTitle("more", for: .normal)
            isLabelAtMaxHeight = false
            eventDescriptionHeight.constant = 75
            
        } else {
            
            readMoreButton.setTitle("less", for: .normal)
            isLabelAtMaxHeight = true
            eventDescriptionHeight.constant = TextSize.sharedinstance.getLabelHeight(text: description_txt, width: ItDescriptionLabel.frame.width, font: ItDescriptionLabel.font)
           
        }
        
        
    }
   

}

extension ItemDetailController {
    
    /****************event label tap function************************/
    
    func tapRegistration() {
        
        let completemenuTap = UITapGestureRecognizer(target: self, action: #selector(BusinessDetailViewController.openCompleteMenu(sender:)))
        businessEntityView.isUserInteractionEnabled = true
        businessEntityView.addGestureRecognizer(completemenuTap)
        
    }
    
    func openCompleteMenu(sender:UITapGestureRecognizer) {
        
        openStoryBoard()
        
    }
    
    
    
    /*************************Tag view updating************************************/
    
    func tagViewUpdate() {
        
        var expandableWidth : CGFloat = 0
        
        for (i,text) in tagarray.enumerated() {
            
            let textLabel : UILabel = UILabel()
            let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: text, fontname: "Avenir-Medium", size: 12)
            textLabel.font = UIFont(name: "Avenir-Medium", size: 12)
            textLabel.text = text
            textLabel.backgroundColor  = UIColor.tagBgColor()
            textLabel.textColor        = UIColor.tagTextColor()
            textLabel.layer.cornerRadius = 4
            textLabel.layer.masksToBounds = true
            textLabel.textAlignment = .center
            
            if i == 0 {
                
                textLabel.frame = CGRect(x: 0, y: 0, width: textSize.width+20, height: 22)
                
            } else {
                
                textLabel.frame = CGRect(x: expandableWidth, y: 0, width: textSize.width+20, height: 22)
                
            }
            
            expandableWidth += textSize.width+30
            tagScrollView.addSubview(textLabel)
            
        }
        
        tagScrollView.contentSize = CGSize(width: expandableWidth, height: 0)
        tagScrollView.isScrollEnabled = true
        
        
    }
    
    func entitytagUpdate() {
        
        var expandableWidth : CGFloat = 0
        
        for (i,text) in entintyTagarray.enumerated() {
            
            let textLabel : UILabel = UILabel()
            let textSize  : CGSize  = TextSize.sharedinstance.sizeofString(text: text, fontname: "Avenir-Medium", size: 12)
            textLabel.font = UIFont(name: "Avenir-Medium", size: 12)
            textLabel.text = text
            textLabel.backgroundColor  = UIColor.tagBgColor()
            textLabel.textColor        = UIColor.tagTextColor()
            textLabel.layer.cornerRadius = 4
            textLabel.layer.masksToBounds = true
            textLabel.textAlignment = .center
            
            if i == 0 {
                
                textLabel.frame = CGRect(x: 0, y: 0, width: textSize.width+20, height: 22)
                
            } else {
                
                textLabel.frame = CGRect(x: expandableWidth, y: 0, width: textSize.width+20, height: 22)
                
            }
            
            expandableWidth += textSize.width+30
            businessEntityScrollview.addSubview(textLabel)
            
        }
        
        businessEntityScrollview.contentSize     = CGSize(width: expandableWidth, height: 0)
        businessEntityScrollview.isScrollEnabled = true
  
    }
    
    /******************Set navigation bar**************************/
    
    func setNavBar() {
        
        navigationItemList.title = "Item"
        
        let button: UIButton = UIButton(type: UIButtonType.custom)
        //set image for button
        button.setImage(UIImage(named: "ic_arrow_back"), for: UIControlState.normal)
        //add function for button
        button.addTarget(self, action: #selector(EventViewController.backButtonClicked), for: UIControlEvents.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        
        let button2 : UIButton = UIButton(type: UIButtonType.custom)
        //set image for button
        button2.setImage(UIImage(named: "eventDots"), for: UIControlState.normal)
        //add function for button
        button2.addTarget(self, action: #selector(EventViewController.openSheet), for: UIControlEvents.touchUpInside)
        //set frame
        button2.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(customView: button)
        let rightButton = UIBarButtonItem(customView: button2)
        
        // Create two buttons for the navigation item
        navigationItemList.leftBarButtonItem  = leftButton
        navigationItemList.rightBarButtonItem = rightButton
        
        
    }
    
    func backButtonClicked() {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
  
    
    func openStoryBoard () {
        
        let storyboard      = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
        let vc              = storyboard.instantiateViewController(withIdentifier: Constants.BusinessCompleteId)
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    func alertTapRegister() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closePopup(sender:)))
        self.shareView.addGestureRecognizer(tap)
        
        let bookmarktap = UITapGestureRecognizer(target: self, action: #selector(self.getBookmarkToken(sender:)))
        self.bookmarkItemDetlabel.addGestureRecognizer(bookmarktap)
        
    }
    
    func closePopup(sender : UITapGestureRecognizer) {
        
        bookmarkid   = 0
        bookmarkname = "name"
        bookmarktype = "empty"
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            
            self.shareView.alpha                 = 0
            
        }, completion: nil)
        
    }
    
    func openSheet() {
        
        bookmarkid   = itemprimaryid
        bookmarkname = ItTitleLabel.text ?? "Item name"
        bookmarktype = "item"
        
        openPopup()
        
    }
    
    func openPopup() {
        
        let Alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let FemaleAction = UIAlertAction(title: "Share", style: UIAlertActionStyle.default) { _ in
            
            
        }
        let MaleAction = UIAlertAction(title: "Bookmark", style: UIAlertActionStyle.default) { _ in
            
            self.getBookmarkToken()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { _ in
        }
        Alert.addAction(FemaleAction)
        Alert.addAction(MaleAction)
        Alert.addAction(cancelAction)
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            Alert.popoverPresentationController?.sourceView = self.view
            Alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
            present(Alert, animated: true, completion:nil )
        }else{
            present(Alert, animated: true, completion:nil )
        }
    }
    
//    func openPopup() {
//
//        self.shareView.alpha   = 1
//
//        let top = CGAffineTransform(translationX: 0, y: 0)
//
//        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
//            self.shareView.isHidden = false
//            self.shareView.transform = top
//
//        }, completion: nil)
//
//
//    }
    
}



/*************Post Delegate****************/

extension ItemDetailController : ReviewEventViewControllerDelegate {
    
    func popupClick(postid: Int, postname: String) {
        
        bookmarkid   = postid
        bookmarkname = postname
        bookmarktype = "post"
        
        openPopup()
    }
    
    func postTableHeight(height: CGFloat) {
        
        mainContainerView.constant = 548 + height
        mainContainerViewBottom.constant = 0
    }
  
}


/*******************Business delegate****************************/

extension ItemDetailController : EventTabControllerDelegate {
    
    func eventTableHeight(height: CGFloat) {
        
        mainContainerView.constant = 548 + height
        mainContainerViewBottom.constant = 0
    }
  
}

/*******************Location delegate****************************/

extension ItemDetailController : LocationTabControllerDelegate {
    
    func locationTableHeight(height: CGFloat) {
        
        mainContainerView.constant = 548 + height
        mainContainerViewBottom.constant = 0
    }
  
    
}

extension ItemDetailController {
    
    func getItemIdApi() {
        
        LoadingHepler.instance.show()
        
        apiClient.getFireBaseToken(completion: { token in
            
            let header : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
            
            self.apiClient.getItemById(id: self.itemprimaryid, headers: header, completion: { status,item in
                
                if status == "success" {
                    
                    LoadingHepler.instance.hide()
                    
                    if let itemlist = item {
                        
                        DispatchQueue.main.async {
                            
                            self.getItemDetails(item: itemlist)
                        }
                        
                    }
                   
                    
                } else {
                    
                    LoadingHepler.instance.hide()
                    
                    DispatchQueue.main.async {
                        
                       self.myscrollView.isHidden = true
                    }
                   
                    
                }
                
                
            })
            
            
        })
        
    }
    
    func getItemDetails(item : ItemList) {
        
        /****************Name************************/
        
        if let itemname = item.name {
            
            ItTitleLabel.text = itemname
        
        }
        
        /****************Imagee************************/
        
        if let imageList = item.itemImageList {
            
            if imageList.count > 0 {
                
                if let url = imageList[imageList.count-1].imageurl {
                    
                    apiClient.getFireBaseImageUrl(imagepath: url, completion: { imageUrl in
                        
                        if imageUrl != "empty" {
                            
                            Manager.shared.loadImage(with: URL(string : imageUrl)!, into: self.ItImageView)
                        }
                        
                    })
                    
                    
                }
      
                
            }
        }
        
        /****************Description************************/
        
        if let itemDes = item.description {
            
            ItDescriptionLabel.text = itemDes
        }
        
        /****************Checking number of lines************************/
        
        if (ItDescriptionLabel.numberOfVisibleLines > 4) {
            
            readMoreButton.isHidden = false
            
        } else {
            
            readMoreButton.isHidden         = true
            if let description = item.description {
                eventDescriptionHeight.constant = TextSize.sharedinstance.getLabelHeight(text: description, width: ItDescriptionLabel.frame.width, font: ItDescriptionLabel.font)
                 description_txt = description
            }
            
            containerViewTop.constant = 8
        }
        
         /****************Tags************************/
        
        if let itemTag = item.tagList {
            
            if itemTag.count > 0 {
                
                tagarray.removeAll()
                
                for tag in itemTag {
                    
                    tagarray.append(tag.text_str ?? "")
                    
                }
                
                tagViewUpdate()
                
            }
            
            
        } else {
            
            tagscroltopConstraint.constant  = 0
            scrollHeightConstraint.constant = 0
        }
        

        
        self.myscrollView.isHidden = false
        
        /****************Business Entity************************/
        
        if let entinty = item.businessEntity {
            
            if let entintyname = entinty.businessname {
                
                businessEntityNameLabel.text = entintyname
            } else {
                
                businessEntintScrollTop.constant = 0
            }
            
            if let itemTag = entinty.taglist {
                
                if itemTag.count > 0 {
                    
                    entintyTagarray.removeAll()
                    
                    for tag in itemTag {
                        
                        entintyTagarray.append(tag.text_str ?? "")
                        
                    }
                    
                    entitytagUpdate()
                }
                
                
            }
            
            
            /****************Business Entity image************************/
            
            if let entintyimgaelist = entinty.imagelist {
                
                if entintyimgaelist.count > 0 {
                    
                    if let url = entintyimgaelist[entintyimgaelist.count-1].imageurl_str {
                        
                        apiClient.getFireBaseImageUrl(imagepath: url, completion: { imageUrl in
                            
                            if imageUrl != "empty" {
                                
                                Manager.shared.loadImage(with: URL(string : imageUrl)!, into: self.businessEntityImage)
                            }
                            
                        })
                        
                        
                    }
                    
                    
                }
                
            }
            
            
        }
        
        
       
    }
    
    
}

extension ItemDetailController {
    
    /***************************Bookmark function********************************/
    
    func bookmarkpost(token : String) {
        
        let clientIp  = ValidationHelper.Instance.getIPAddress() ?? "1.0.1"
        let userid    = PrefsManager.sharedinstance.userId
        let eventname = ItTitleLabel.text ?? "Item name"
        
        LoadingHepler.instance.show()
        
        let header     : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
        let parameters: Parameters = ["entityid": itemprimaryid, "entityname":eventname , "type" : "item" ,"createdby" : userid,"updatedby": userid ,"clientip": clientIp, "clientapp": Constants.clientApp]
        apiClient.bookmarEntinty(parameters: parameters,headers: header, completion: { status,response in
            
            if status == "success" {
                
                DispatchQueue.main.async {
                    LoadingHepler.instance.hide()
                    AlertProvider.Instance.showAlert(title: "Hey!", subtitle: "Bookmarked successfully.", vc: self)
                    self.closePopup()
                }
                
            } else {
                
                LoadingHepler.instance.hide()
                if status == "422" {
                    
                    AlertProvider.Instance.showAlert(title: "Hey!", subtitle: "Already bookmarked.", vc: self)
                    
                } else {
                    
                    AlertProvider.Instance.showAlert(title: "Oops!", subtitle: "Bookmark failed.", vc: self)
                    
                }
            }
            
        })
        
    }
    
    func getBookmarkToken(sender : UITapGestureRecognizer) {
        
        apiClient.getFireBaseToken(completion:{ token in
            
            
            self.bookmarkpost(token: token)
            
        })
        
    }
    
    func getBookmarkToken() {
        
        apiClient.getFireBaseToken(completion:{ token in
            
            self.bookmarkpost(token: token)
            
        })
        
    }
    
    func closePopup() {
        
        bookmarkid   = 0
        bookmarkname = "name"
        bookmarktype = "empty"
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            
            self.shareView.alpha                 = 0
            
        }, completion: nil)
        
    }
    
    
    
}

