//
//  HomeViewController.swift
//  Numnu
//
//  Created by Paramesh on 18/09/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Nuke


class HomeViewController: UIViewController {

    @IBOutlet var ActTopSegment: UISegmentedControl!
    @IBOutlet var feed: UITableView!
    
    /**********viewModel*********/
    
    var postviewModel : PostViewModel!
    
  
    let buttonAttributes : [String: Any] = [
        NSFontAttributeName : UIFont.systemFont(ofSize: 14),
        NSForegroundColorAttributeName : UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0),
        NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        feed.delegate   = self
        feed.dataSource = self
        
        
        postviewModel = PostViewModel()
        
        /**************Retriving post********************/
        postviewModel.getPostList {
            
            DispatchQueue.main.async {
                
                self.postviewModel.removepostObserver()
                self.feed.reloadData()
                
                
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
        
    }
 

}

// Tableview delegate and datasource

extension HomeViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var numOfSections: Int = 0
        if postviewModel.postItemList.isEmpty == false
        {
            
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.feed.bounds.size.width, height:self.feed.bounds.size.height))
            label.text = "No post to show"
            label.textColor = UIColor.black;
            label.textAlignment = .center
            label.sizeToFit()
            label.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
            tableView.backgroundView  = label
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postviewModel.postItemList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:  indexPath as IndexPath) as! feedTableViewCell
        
        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: #selector(HomeViewController.starbuttonPressed(button:)), for: .touchUpInside)
        
        if postviewModel.postItemList[indexPath.row].name != "error" {
            
            cell.username.text = postviewModel.postItemList[indexPath.row].name
            
        }
        
        if postviewModel.postItemList[indexPath.row].photourl != "error" {
            
           
            
            let url = URL(string: postviewModel.postItemList[indexPath.row].photourl!)
            let request = Nuke.Request(url: url!).processed(key: "Avatar") {
                
                return $0.resize(CGSize(width: 40, height: 40), fitMode: .crop)
                    .maskWithEllipse()
            }
            
            Nuke.loadImage(with: request, into: cell.userpic)
            
        }
        
        if postviewModel.postItemList[indexPath.row].postdatetime != "error" {
            
            
            cell.postedTime.text = postviewModel.elapsedTime(datetime: postviewModel.postItemList[indexPath.row].postdatetime!)
        }
        
        
        if postviewModel.postItemList[indexPath.row].comment != "error" {
            
            
            cell.postDetail.text = postviewModel.postItemList[indexPath.row].comment
        }
        
        if postviewModel.postItemList[indexPath.row].cityname != "error" {
            
            
            cell.location.text = postviewModel.postItemList[indexPath.row].cityname
        }
        
        
        if postviewModel.postItemList[indexPath.row].comment != "error" {
            
            
            cell.postDetail.text = postviewModel.postItemList[indexPath.row].comment
        }
        
        if postviewModel.postItemList[indexPath.row].eventlist[0]["name"] as! String != "error" {
            
            cell.eventList.text = postviewModel.postItemList[indexPath.row].eventlist[0]["name"] as? String
            
        }
        
        
        if postviewModel.postItemList[indexPath.row].bussinesslist[0]["name"] as! String != "error" {
            
            cell.cottageLbl.text = postviewModel.postItemList[indexPath.row].bussinesslist[0]["name"] as? String
            
        }
        
        if postviewModel.postItemList[indexPath.row].itemlist[0]["name"] as! String != "error" {
            
            cell.clochelbl.text = postviewModel.postItemList[indexPath.row].itemlist[0]["name"] as? String
            
        }
        
        if postviewModel.postItemList[indexPath.row].itemlist[0]["photoUrl"] as! String != "error" {
            
            cell.postImg.layer.cornerRadius  = 5
            cell.postImg.layer.masksToBounds = true
            
            let url = URL(string: postviewModel.postItemList[indexPath.row].itemlist[0]["photoUrl"] as! String)
            Nuke.loadImage(with: url!, into: cell.postImg)
        }
        
        /**Tag friends label**/
        
        if postviewModel.postItemList[indexPath.row].taglist != "error" {
            
            let tagnameArray = postviewModel.postItemList[indexPath.row].taglist!.components(separatedBy: ",")
            
            if tagnameArray.isEmpty == false {
                
                cell.Usertags.isHidden  = false
                cell.tagCounts.isHidden = true
                
                
                if tagnameArray.count > 2 {
                    
                    cell.Usertags.setTitle("\(tagnameArray[0]),\(tagnameArray[1])", for: .normal)
                    
                    let attributeString = NSMutableAttributedString()
                    attributeString.append(NSAttributedString(string: "\(tagnameArray[0]),\(tagnameArray[1]) ",attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleNone.rawValue]))
                    attributeString.append(NSAttributedString(string: "+ \(tagnameArray.count - 2) others",attributes: buttonAttributes))
                    cell.Usertags.setAttributedTitle(attributeString, for: .normal)
                    
                   
                    
                } else if tagnameArray.count == 2 || tagnameArray.count < 2 {
                    
                    
                    
                    if tagnameArray.count == 2 {
                        
                        cell.Usertags.setTitle("\(tagnameArray[0]),\(tagnameArray[1])", for: .normal)
                        
                    } else {
                        
                        cell.Usertags.setTitle("\(tagnameArray[0])", for: .normal)
                    }
                    
                   
                    
                }
                
            } else {
                
                cell.Usertags.isHidden  = true
                cell.tagCounts.isHidden = true
                
            }
            
        }
        
        return cell
        
    }
     
    
    
}

extension HomeViewController {
    
    func starbuttonPressed(button: UIButton!)
    {
        
        if button.currentImage == UIImage(named: "unlike"){
            
            button.setImage(UIImage(named: "unShape"), for: .normal)
            
        } else {
            
            button.setImage(UIImage(named: "unlike"), for: .normal)
        }
        
        
    }
    
    
}

