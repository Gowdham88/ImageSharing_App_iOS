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
import FirebaseStorage



class  ApiClient {
    
    
    /*********************Complete Signup Api*****************************/
    
    func completeSignup(parameters : Parameters,headers : HTTPHeaders,completion : @escaping (String,UserList?) -> Void) {
        
        Alamofire.request(Constants.completeSignup, method: .post, parameters: parameters,encoding: JSONEncoding.default,headers: headers).validate().responseJSON { response in
            
            
            print(response.result.value as Any)
            
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
                
                print(error.localizedDescription)
                completion(error.localizedDescription,nil)
                
            }
        }
        
        
    }
    
     /*********************Login Api*****************************/
    
    func userLogin(headers : HTTPHeaders,completion : @escaping (String,UserList?) -> Void) {
        
        Alamofire.request(Constants.LoginApiUrl, method: .get, headers: headers).validate().responseJSON { response in
            
            print(response.result.value)
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let userList = UserList(json: json) {
                        
                        completion("success",userList)
                    }
                    
                    
                }
                
                
            case .failure(let error):
                
                print(error.localizedDescription)
                completion(error.localizedDescription,nil)
                
            }
        }
        
    }
    
    /************************Username check Api**********************************/
    
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
        
        Alamofire.request(Constants.TagApiUrl, method: .get, parameters: parameters,headers: headers).validate().responseJSON { response in
            
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
    func getEventsApi(headers : HTTPHeaders,parameter : String,completion : @escaping (String,EventTypeList?) -> Void) {
        
        Alamofire.request("\(Constants.EventTypeApiUrl)?/\(parameter)",encoding: JSONEncoding.default,headers: headers).validate().responseJSON { response in
            
            print(response.request as Any)
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let eventList = EventTypeList(json: json) {
                        
                        completion("success",eventList)
                    }
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                completion(error.localizedDescription,nil)
                
            }
            
        }
        
    }
    
    /************************Event Detail*******************************/
    func getEventsDetailsApi(id:Int,headers : HTTPHeaders,completion : @escaping (String,EventList?) -> Void) {
        
        Alamofire.request("\(Constants.EventApiUrl)/\(id)", encoding: JSONEncoding.default,headers: headers).validate().responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let eventList = EventList(json: json) {
                        
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
        
        Alamofire.request(Constants.ItemsApiUrl, method: .get, parameters: parameters,encoding: JSONEncoding.default).validate().responseJSON { response in
            
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
    
    
    /*********************************PostsByEventId********************************************************/
    func PostsByEventId(id : Int,page : String,headers: HTTPHeaders,completion : @escaping (String,PostListByEventId?) -> Void) {
        
        Alamofire.request("\(Constants.EventApiUrl)/\(id)/posts?\(page)", method: .get, encoding: JSONEncoding.default,headers: headers).validate().responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let itemList = PostListByEventId(json: json) {
                        
                        completion("success",itemList)
                    }
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                completion(error.localizedDescription,nil)
                
            }
            
        }
        
    }
    
    
    /********************************getItemTag based Event*************************************************/
    
    func getItemTagEvent(id : Int,page : String,headers : HTTPHeaders,completion : @escaping (String,EventItemTagModel?)-> Void) {
        
        Alamofire.request("\(Constants.EventApiUrl)/\(id)/itemtags?\(page)", method: .get,encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            print(response.request as Any)
            print(response.result.value as Any)
            
            switch response.result {
                
            case .success :
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let list = EventItemTagModel(json: json) {
                        
                        completion("success",list)
                        
                    }
                  
                }
                
                
            case .failure(let error):
                
                print(error.localizedDescription)
                completion(error.localizedDescription,nil)
                
                }
            
            }
            
     }
    
    /********************************getItemTag based Business*************************************************/
    
    func getItemTagBusiness(id : Int,page : String,headers : HTTPHeaders,completion : @escaping (String,BusinessItemTagModel?)-> Void) {
        
        Alamofire.request("\(Constants.BusinessDetailApi)/\(id)/itemtags?\(page)", method: .get,encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            print(response.request as Any)
            print(response.result.value as Any)
            
            switch response.result {
                
            case .success :
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let list = BusinessItemTagModel(json: json) {
                        
                        completion("success",list)
                        
                    }
                    
                }
                
                
            case .failure(let error):
                
                print(error.localizedDescription)
                completion(error.localizedDescription,nil)
                
            }
            
        }
        
    }
    
    /********************************getBussiness based Event*************************************************/
    
    func getBussinessEvent(id : Int,page : String,headers : HTTPHeaders,completion : @escaping (String,BusinessEventModel?)-> Void) {
        
        Alamofire.request("\(Constants.EventApiUrl)/\(id)/businesses?\(page)", method: .get,encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            print(response.request as Any)
            print(response.result.value as Any)
            
            switch response.result {
                
            case .success :
                
                if let value = response.result.value {
                    
                        let json = JSON(value)
                        if let list = BusinessEventModel(json: json) {
                            
                            completion("success",list)
                            
                        }
                    
                }
            
            case .failure(let error):
                
                print(error.localizedDescription)
                completion(error.localizedDescription,nil)
                
            }
            
        }
        
    }
    
    /********************************getItemList based Item Tag id*************************************************/
    
    func getItemListByTagId(primaryid : Int,tagid : Int,type:String,page : String,headers : HTTPHeaders,completion : @escaping (String,ItemListModel?)-> Void) {
        
        var BaseUrl :String?
        
        switch type {
        case "Event":
            BaseUrl = Constants.EventApiUrl
            
        case "Business":
            BaseUrl = Constants.BusinessDetailApi
            
        default:
            BaseUrl = Constants.EventApiUrl
        }
        
        Alamofire.request("\(BaseUrl!)/\(primaryid)/itemtags/\(tagid)/items?\(page)", method: .get,encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            print(response.request as Any)
            print(response.result.value as Any)
            
            switch response.result {
                
            case .success :
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let list = ItemListModel(json: json) {
                        
                        completion("success",list)
                        
                    }
                    
                }
                
            case .failure(let error):
                
                print(error.localizedDescription)
                completion(error.localizedDescription,nil)
                
            }
            
        }
        
    }
    
    /************************get Events By Businessid**********************************/
    func getEventsByBusinessApi(id : Int,page : String,headers : HTTPHeaders,completion : @escaping (String,EventTypeList?) -> Void) {
        
        Alamofire.request("\(Constants.EventTypeApiUrl)/\(id)/events?\(page)", method: .get,encoding: JSONEncoding.default,headers: headers).validate().responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let eventList = EventTypeList(json: json) {
                        
                        completion("success",eventList)
                    }
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                completion(error.localizedDescription,nil)
                
            }
            
        }
        
    }
        
    /********************************getItemsbasedid*************************************************/
    
    func getItemById(id : Int,headers : HTTPHeaders,completion : @escaping (String,ItemList?)-> Void) {
        
        Alamofire.request("\(Constants.ItemsApiUrl)/\(id)", method: .get,encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            print(response.request as Any)
            print(response.result.value as Any)
            
            switch response.result {
                
            case .success :
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let itemList = ItemList(json: json) {
                        
                        completion("success",itemList)
                    }
                  
                }
                
                
            case .failure(let error):
                
                print(error.localizedDescription)
                completion(error.localizedDescription,nil)
                
            }
            
        }
        
    }
    
    /********************************getItemsbasedid*************************************************/
    
    func getBusinessById(id : Int,headers : HTTPHeaders,completion : @escaping (String,BusinessDetailModel?)-> Void) {
        
        Alamofire.request("\(Constants.BusinessDetailApi)/\(id)", method: .get,encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            print(response.request as Any)
            print(response.result.value as Any)
            
            switch response.result {
                
            case .success :
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let businesList = BusinessDetailModel(json: json) {
                        
                        completion("success",businesList)
                    }
                    
                }
                
                
            case .failure(let error):
                
                print(error.localizedDescription)
                completion(error.localizedDescription,nil)
                
            }
            
        }
        
    }
    
    /************************Events Api**********************************/
    func getEventsTypesApi(parameters : Parameters,completion : @escaping (String,EventTypeList?) -> Void) {
        
        Alamofire.request(Constants.EventTypeApiUrl, method: .get, parameters: parameters,encoding: JSONEncoding.default).validate().responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let eventList = EventTypeList(json: json) {
                        
                        completion("success",eventList)
                    }
                    
                }
                
                
            case .failure(let error):
                
                print(error)
                completion(error.localizedDescription,nil)
                
            }
            
        }
        
    }
    
    
    
    func getFireBaseToken(completion : @escaping (String) -> Void) {
    
     if let currentUser = Auth.auth().currentUser {
        
        currentUser.getIDToken{ idToken, error in
            if let error = error {
                print(error.localizedDescription)
                completion(error.localizedDescription)
                return;
            }
            
            print(idToken ?? "empty")
            completion(idToken ?? "empty")
            
        }
            
            
     } else {
        
        Auth.auth().signInAnonymously() { (user, error) in
            
            if error != nil {
                
                completion("empty")
            }
            
            if let annoymususer = user {
                
                annoymususer.getIDToken{ idToken, error in
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
        
    }
    
    func getFireBaseImageUrl(imagepath : String,completion : @escaping (String) -> Void) {
        
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        // Create a reference to the file you want to download
        let starsRef = storageRef.child(imagepath)
        
        // Fetch the download URL
        starsRef.downloadURL { url, error in
            if let error = error {
                print(error.localizedDescription)
                completion("empty")
                
            } else {
                
                completion((url?.absoluteString)!)
                
            }
        }
        
        
        
    }
    
    
    
}
