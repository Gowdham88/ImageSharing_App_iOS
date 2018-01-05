//
//  BookmarkViewController.swift
//  Numnu
//
//  Created by Siva on 02/01/18.
//  Copyright © 2018 czsm. All rights reserved.
//

import UIKit
import Alamofire

class BookmarkViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkdataitems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BookmarkTableViewCell
        cell.item = bookmarkdataitems[indexPath.row]

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
            self.deleteBookmark(id: bookmarkdataitems[indexPath.row].id ?? 0,position: indexPath.row)
            self.bookmarkTableView.reloadData()
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             if apiType == "Event" {
                let storyboard = UIStoryboard(name: Constants.Event, bundle: nil)
                let vc         = storyboard.instantiateViewController(withIdentifier:Constants.EventStoryId) as! EventViewController
                self.navigationController?.pushViewController(vc, animated: true)

            }else if apiType == "Business" {
                
                let storyboard = UIStoryboard(name: Constants.BusinessDetailTab, bundle: nil)
                let vc         = storyboard.instantiateViewController(withIdentifier:Constants.BusinessCompleteId) as! BusinessCompleteViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if apiType == "Item" {
                
                let storyboard = UIStoryboard(name: Constants.ItemDetail, bundle: nil)
                let vc         = storyboard.instantiateViewController(withIdentifier:Constants.ItemDetailId)
                self.navigationController?.pushViewController(vc, animated: true)
            }else if apiType == "Post" {
                
                let storyboard = UIStoryboard(name: Constants.PostDetail, bundle: nil)
                let vc         = storyboard.instantiateViewController(withIdentifier:Constants.PostDetailId) as! PostDetailViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
      
    }
    
    var primaryid    : Int = PrefsManager.sharedinstance.userId
    var pageno       : Int = 1
    var limitno      : Int = 25
    var apiType      : String?// = "Event"
    var apiClient    : ApiClient!
    var bookmarkdataitems    =  [BookmarksDataItems]()
    var bookmarklist : BookMarkMainModel?

    @IBOutlet weak var navigationItemList: UINavigationItem!
    @IBOutlet weak var bookmarkTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        apiClient = ApiClient()
        // Do any additional setup after loading the view.
        if apiType == "Event" || apiType == "Business" || apiType == "Item" || apiType == "Post"{
            methodToCallApi(pageno: pageno, limit: limitno)
        }
        setNavBar()
    }
    func methodToCallApi(pageno:Int,limit:Int) {
        
        LoadingHepler.instance.show()
        
        apiClient.getFireBaseToken(completion: { token in
            
            let header : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
            let param  : String  = "page=\(pageno)&limit\(limit)"
           
            self.apiClient.getBookmarks(id: self.primaryid, page: param, headers: header, completion: { status,taglist in
                
                if status == "success" {
                    
                    if let item = taglist {
                        
                        self.bookmarklist = item
                        
                        if let list = item.itemlist {
                            
                            switch self.apiType{
                            case "Event"?:
                                for bookmarkitem in list {
                                    if bookmarkitem.type == "event"{
                                        self.bookmarkdataitems.append(bookmarkitem)
                                    }
                                }
                            case "Item"?:
                                for bookmarkitem in list {
                                    if bookmarkitem.type == "item" {
                                        self.bookmarkdataitems.append(bookmarkitem)
                                    }
                                }
                            case "Business"?:
                                for bookmarkitem in list {
                                    if bookmarkitem.type == "business" {
                                        self.bookmarkdataitems.append(bookmarkitem)
                                    }
                                }
                            case "Post"?:
                                for bookmarkitem in list {
                                    if bookmarkitem.type == "post" {
                                        self.bookmarkdataitems.append(bookmarkitem)
                                    }
                                }
                            default:
                                for bookmarkitem in list {
                                    if bookmarkitem.type == "event"{
                                        self.bookmarkdataitems.append(bookmarkitem)
                                    }
                                }
                            }                            
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.bookmarkTableView.reloadData()
                        
                    }
                    
//                    self.reloadTable()
                    LoadingHepler.instance.hide()

                    
                } else {
                    
                    LoadingHepler.instance.hide()
                    DispatchQueue.main.async {
                        
                        self.bookmarkTableView.reloadData()
                        
                    }
//                    self.reloadTable()
                    
                }
                
                
            })
            
            
        })
        
        
    }
    
    func setNavBar() {
        
        switch self.apiType{
        case "Event"?:         navigationItemList.title = "Event"

            
        case "Item"?:         navigationItemList.title = "Item"

            
        case "Business"?:         navigationItemList.title = "Business"

            
        case "Post"?:         navigationItemList.title = "Post"

            
        default:         navigationItemList.title = "Bookmarks"

            
        }
        
//        navigationItemList.title = "Bookmarks"
        
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
        
        _ = self.navigationController?.popViewController(animated: true)
        
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
    
    func deleteBookmark(id: Int,position:Int){
        apiClient.getFireBaseToken(completion: { token in
            let header : HTTPHeaders = ["Accept-Language" : "en-US","Authorization":"Bearer \(token)"]
        
            self.apiClient.deleteBookmark(id: id, headers: header, completion: { (status) in
                
                if status == "success"{
                    
                    self.bookmarkdataitems.remove(at: position)
                    self.bookmarkTableView.reloadData()

                    
                } else {
                    
                    AlertProvider.Instance.showAlert(title: "Bookmarks", subtitle: "Delete failure", vc: self)
                }
                
            })
            
            
        })
        
    }

}
