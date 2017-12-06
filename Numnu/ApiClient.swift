//
//  ApiClient.swift
//  Numnu
//
//  Created by CZ Ltd on 11/20/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Firebase
import FirebaseAuth

class  ApiClient {
    
//    /*********************Login Api*****************************/
//
//    func userLogin(parameters : Parameters,completion : @escaping (String,UserList?) -> Void) {
//
//        Alamofire.request(Constants.LoginApiUrl, method: .post, parameters: parameters).validate().responseJSON { response in
//
//            switch response.result {
//
//            case .success:
//
//                if let value = response.result.value {
//
//                    let json = JSON(value)
//                    if let userList = UserList(json: json) {
//
//                        completion("success",userList)
//                    }
//
//
//                }
//
//
//            case .failure(let error):
//
//                print(error)
//                completion(error.localizedDescription,nil)
//
//            }
//       }
//
//    }
    
     /*********************Login Api*****************************/
    
    func userLogin(parameters : Parameters,headers : HTTPHeaders,completion : @escaping (String,UserList?) -> Void) {
        
        Alamofire.request(Constants.LoginApiUrl, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let userList = UserList(json: json) {
                        
                        completion("success",userList)
                    }
                    
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                completion(error.localizedDescription,nil)
                
            }
        }
        
    }
    
    func usernameexists(parameters : Parameters,headers : HTTPHeaders,completion : @escaping (String,Bool?) -> Void) {
        Alamofire.request(Constants.CheckUserName, method: .get, parameters: parameters,headers : headers).validate().responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let usernameexists = json["usernameexists"].bool {
                        
                        completion("success",usernameexists)
                    }
                    
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                completion(error.localizedDescription,nil)
                
            }
            
            
        }
    }
    
    /************************Tags Api**********************************/
    
    func getTagsApi(parameters : Parameters,headers : HTTPHeaders,completion : @escaping (String,TagList?) -> Void) {
        
        Alamofire.request(Constants.TagApiUrl, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let userList = TagList(json: json) {
                        
                        completion("success",userList)
                    }
                  
                }
                
                
            case .failure(let error):
                
                print(error)
                completion(error.localizedDescription,nil)
                
            }
            
        }
        
    }
    
     /************************Events Api**********************************/
    func getEventsApi(parameters : Parameters,completion : @escaping (String,EventModelList?) -> Void) {
        
        Alamofire.request(Constants.EventApiUrl, method: .get, parameters: parameters).validate().responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let eventList = EventModelList(json: json) {
                        
                        completion("success",eventList)
                    }
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                completion(error.localizedDescription,nil)
                
            }
            
        }
        
    }
    
    /************************Items Api**********************************/
    func getItemsApi(parameters : Parameters,completion : @escaping (String,ItemList?) -> Void) {
        
        Alamofire.request(Constants.ItemsApiUrl, method: .get, parameters: parameters).validate().responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let itemList = ItemList(json: json) {
                        
                        completion("success",itemList)
                    }
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                completion(error.localizedDescription,nil)
                
            }
            
        }
        
    }
    
    /*********************Complete Signup Api*****************************/
    
       func completeSignup(parameters : Parameters,headers : HTTPHeaders,completion : @escaping (String,UserList?) -> Void) {
        
        
        
        Alamofire.request(Constants.completeSignup, method: .post, parameters: parameters,encoding: JSONEncoding.default,headers: headers).validate().responseJSON { response in
            
           
            print(response.result)
            
            switch response.result {
                
            case .success:
                
               
                
                if let value = response.result.value {
                    
                    print(value)
                    
                    let json = JSON(value)
                    if let userList = UserList(json: json) {
                        
                        completion("success",userList)
                    }
                    
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                print(error.localizedDescription)
                completion(error.localizedDescription,nil)
                
            }
        }
        
       
        
    }
    
    func getFireBaseToken(completion : @escaping (String) -> Void) {
    
     if let currentUser = Auth.auth().currentUser {
        
        currentUser.getTokenForcingRefresh(true) {idToken, error in
            if let error = error {
              print(error.localizedDescription)
                completion(error.localizedDescription)
              return;
            }
            
            print(idToken ?? "empty")
            completion(idToken ?? "empty")
          
        }
            
            
        } else {
        
        completion("empty")
        
      }
        
    }
    
}
