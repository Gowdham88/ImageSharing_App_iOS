//
//  PostViewModel.swift
//  Numnu
//
//  Created by CZ Ltd on 9/18/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class PostViewModel  {
    
    var myPostItem   : PostList!
    var postItemList = [PostList]()
    
    /********Retriving post func********/
    
    func getPostList(completion: @escaping () -> Void)  {
        
        postItemList.removeAll()
        
        DBProvider.Instance.handlerPost = DBProvider.Instance.postsRef.observe(.value, with: {
            (snapshot) in
            
          if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
            
             for (index,snap) in snapshots.enumerated() {
                
                if let postDict = snap.value as? [String : AnyObject] {
                    
                    self.myPostItem = PostList(dictionary: postDict)
                    self.postItemList.append(self.myPostItem)
                    
                }
                
                if (index == snapshots.count - 1) {
                    
                    completion()
                }
                
            }
            
            
          } else {
            
            completion()
            
          }
            
            
        });
        
    }
    
    /**********remove ************/
    
    func removepostObserver() {
        
        DBProvider.Instance.postsRef.removeObserver(withHandle: DBProvider.Instance.handlerPost)
        
    }
    
    /**************converting time*************************/
    
    func elapsedTime (datetime : String) -> String
    {
        //just to create a date that is before the current time
      
        let before = Date(timeIntervalSince1970: Double(datetime)!)
        
        //getting the current time
        let now = Date()
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1 //increase it if you want more precision
        formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute]
        formatter.includesApproximationPhrase = false //to write "About" at the beginning
        
        
        let formatString = NSLocalizedString("%@", comment: "Used to say how much time has passed. e.g. '2 hours ago'")
        let timeString = formatter.string(from: before, to: now)
        return String(format: formatString, timeString!)
    }
    
    
}
