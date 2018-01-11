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
import CoreLocation


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
                
                if let httpStatusCode = response.response?.statusCode {
                    
                    if let value = response.data,httpStatusCode == 400 {
                        let json = JSON(value)
                        if let message = UserList(json: json) {
                            
                            completion("400",message)  
                            return
                        }
                        
                    }
                   
                }
               
                completion(error.localizedDescription,nil)
                
            }
        }
        
        
    }
    
     /*********************Login Api*****************************/
    
    func userLogin(headers : HTTPHeaders,completion : @escaping (String,UserList?) -> Void) {
        
        Alamofire.request(Constants.LoginApiUrl, method: .get, headers: headers).validate().responseJSON { response in
            
            print(response.result.value as Any)
            
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
    
    /*********************Edit Profile Api*****************************/
    
    func editProfileApi(parameters : Parameters,id : Int,headers : HTTPHeaders,completion : @escaping (String,UserList?) -> Void) {
        
        Alamofire.request("\(Constants.completeSignup)/\(id)", method: .put, parameters: parameters,encoding: JSONEncoding.default,headers: headers).validate().responseJSON { response in
            
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
                
                if let httpStatusCode = response.response?.statusCode {
                    
                    if let value = response.data,httpStatusCode == 400 {
                        let json = JSON(value)
                        if let message = UserList(json: json) {
                            
                            completion("400",message)
                            return
                        }
                        
                    }
                    
                }
                
                completion(error.localizedDescription,nil)
                
            }
        }
        
        
    }
    
    /************************Username check Api**********************************/
    
    func usernameexists(parameters : String,headers : HTTPHeaders,completion : @escaping (String,Bool?) -> Void) {
       
        Alamofire.request("\(Constants.CheckUserName)?checkusername=\(parameters)",encoding: JSONEncoding.default,headers : headers).validate().responseJSON { response in
            
            print(response.result.value as Any)
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let usernameexistsno = json["usernameexists"].int {
                        
                        completion("success",usernameexistsno == 1 ? true : false)
                    }
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
    
    /*********************Home search api*****************************/
    
    func homeSearchApi(parameters : Parameters,type : String,pageno : Int,headers : HTTPHeaders,completion : @escaping (String,HomeSearchModel?) -> Void) {
        
        var baseUrl : String =  Constants.homeSearchApi
        
        switch type {
        case "events":
            
            baseUrl = "\(Constants.homeSearchApi)/events?page=\(pageno)"
            
        case "items":
            
            baseUrl = "\(Constants.homeSearchApi)/items?page=\(pageno)"
            
        case "businesses":
            
            baseUrl = "\(Constants.homeSearchApi)/businesses?page=\(pageno)"
            
        case "posts":
            
            baseUrl = "\(Constants.homeSearchApi)/posts?page=\(pageno)"
            
        case "users":
            
            baseUrl = "\(Constants.homeSearchApi)/users?page=\(pageno)"
            
        default:
            baseUrl = "\(Constants.homeSearchApi)/events?page=\(pageno)"
        }
        
        Alamofire.request(baseUrl, method: .post, parameters: parameters,encoding: JSONEncoding.default,headers: headers).validate().responseJSON { response in
            
            print(response.result.value as Any)
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    print(value)
                    
                    let json = JSON(value)
                    
                    if let homeList = HomeSearchModel(json: json,type : type) {
                        
                        completion("success",homeList)
                    }
                    
                    
                }
                
                
            case .failure(let error):
                
                print(error.localizedDescription)
                
                if let httpStatusCode = response.response?.statusCode {
                    
                    if let value = response.data,httpStatusCode == 400 {
                        let json = JSON(value)
                        if UserList(json: json) != nil {
                            
                            completion("400",nil)
                            return
                        }
                        
                    }
                    
                }
                
                completion(error.localizedDescription,nil)
                
            }
        }
      
    }
    
    
    /*********************Home horizontal search api*****************************/
    
    func homeHorizontalSearchApi(parameters : Parameters,headers : HTTPHeaders,completion : @escaping (String,HomehorizontalListModel?) -> Void) {
      
        
        Alamofire.request(Constants.homeListApi, method: .post, parameters: parameters,encoding: JSONEncoding.default,headers: headers).validate().responseJSON { response in
            
            print(response.result.value as Any)
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    print(value)
                    
                    if let json = JSON(value).array {
                    
                    if let homeList = HomehorizontalListModel(json: json) {
                        
                        completion("success",homeList)
                    }
                        
                    } else {
                        
                        completion("failure",nil)
                        
                    }
                    
                    
                }
                
                
            case .failure(let error):
                
                print(error.localizedDescription)
                
                if let httpStatusCode = response.response?.statusCode {
                    
                    if let value = response.data,httpStatusCode == 400 {
                        let json = JSON(value)
                        if UserList(json: json) != nil {
                            
                            completion("400",nil)
                            return
                        }
                        
                    }
                    
                }
                
                completion(error.localizedDescription,nil)
                
            }
        }
        
    }
    
    /*********************Home horizontal search api*****************************/
    
    func homeHorizontalSearchApiPagination(parameters : Parameters,id:Int,page : Int,headers : HTTPHeaders,completion : @escaping (String,HomehorizontalModel?) -> Void) {
        
        
        Alamofire.request("\(Constants.homeListApi)/\(id)?page=\(page)", method: .post, parameters: parameters,encoding: JSONEncoding.default,headers: headers).validate().responseJSON { response in
            
            print(response.result.value as Any)
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    print(value)
                    
                     let json = JSON(value)
                        
                        if let homeList = HomehorizontalModel(json: json) {
                            
                            completion("success",homeList)
                        }
                   
                }
                
                
            case .failure(let error):
                
                print(error.localizedDescription)
                
                if let httpStatusCode = response.response?.statusCode {
                    
                    if let value = response.data,httpStatusCode == 400 {
                        let json = JSON(value)
                        if UserList(json: json) != nil {
                            
                            completion("400",nil)
                            return
                        }
                        
                    }
                    
                }
                
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
    
    
    /*********************************Posts********************************************************/
    func getPostList(id : Int,page : String,type : String,headers: HTTPHeaders,completion : @escaping (String,PostListByEventId?) -> Void) {
        
        var Baseurl : String?
        
        switch  type {
            case "Event":
            Baseurl = Constants.EventApiUrl
            
            case "Business":
            Baseurl = Constants.BusinessDetailApi
            
            case "Item":
            Baseurl = Constants.PostsByItemId

            case "Location":
            Baseurl = Constants.LocationApiUrl
            
            case "Users":
            Baseurl = Constants.Bookmarkpost
            
            default:
            Baseurl = Constants.EventApiUrl
        }
        
        
        Alamofire.request("\(Baseurl!)/\(id)/posts?\(page)", method: .get, encoding: JSONEncoding.default,headers: headers).validate().responseJSON { response in
            
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
    
    /*********************************PostsByEventContextBusiness********************************************************/
    func getPostListByEvent(eventId : Int,id : Int,page : String,type : String,headers: HTTPHeaders,completion : @escaping (String,PostListByEventId?) -> Void) {
        
        Alamofire.request("\(Constants.EventApiUrl)/\(eventId)/businesses/\(id)/posts?\(page)", method: .get, encoding: JSONEncoding.default,headers: headers).validate().responseJSON { response in
            
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
    
    /*********************************PostsByEventContextBusiness********************************************************/
    func getPostListByItemEvent(eventId : Int,id : Int,page : String,type : String,headers: HTTPHeaders,completion : @escaping (String,PostListByEventId?) -> Void) {
        
        Alamofire.request("\(Constants.EventApiUrl)/\(eventId)/items/\(id)/posts?\(page)", method: .get, encoding: JSONEncoding.default,headers: headers).validate().responseJSON { response in
            
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
    
    /********************************getItemTag based Location*************************************************/
    
    func getItemTagLocation(id : Int,page : String,headers : HTTPHeaders,completion : @escaping (String,EventItemTagModel?)-> Void) {
        
        Alamofire.request("\(Constants.LocationApiUrl)/\(id)/itemtags?\(page)", method: .get,encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
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
    
    /********************************getItemTag based Event*************************************************/
    /********************************Event context******************************************/
    
    func getItemTagBusinessEvent(id : Int,businessid : Int,page : String,headers : HTTPHeaders,completion : @escaping (String,BusinessItemTagModel?)-> Void) {
        
        Alamofire.request("\(Constants.EventApiUrl)/\(id)/businesses/\(businessid)/itemtags?\(page)", method: .get,encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
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
            
        case "Business":
            BaseUrl = Constants.BusinessDetailApi
        
        case "Location":
            BaseUrl = Constants.LocationApiUrl
            
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
    
    /********************************getItemList based Item Tag id*************************************************/
    /********************************Event context******************************************/
    
    func getItemListByTagIdEvent(eventid : Int,businessid:Int,tagid : Int,page : String,headers : HTTPHeaders,completion : @escaping (String,ItemListModel?)-> Void) {
        
        Alamofire.request("\(Constants.EventApiUrl)/\(eventid)/businesses/\(businessid)/itemtags/\(tagid)/items?\(page)", method: .get,encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
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
        
        Alamofire.request("\(Constants.BusinessDetailApi)/\(id)/events?\(page)", method: .get,encoding: JSONEncoding.default,headers: headers).validate().responseJSON { response in
            
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
    
    /********************************getItemsbasedidEvent*************************************************/
    
    func getItemByIdEvent(eventid : Int,id : Int,headers : HTTPHeaders,completion : @escaping (String,ItemList?)-> Void) {
        
        Alamofire.request("\(Constants.EventApiUrl)/\(eventid)/items/\(id)", method: .get,encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
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
    
    
    
    /********************************getItemsbasedid*************************************************/
    
    func getBusinessByIdEvent(eventid : Int,businessid: Int , headers : HTTPHeaders,completion : @escaping (String,BusinessDetailModel?)-> Void) {
        
        Alamofire.request("\(Constants.EventApiUrl)/\(eventid)/businesses/\(businessid)", method: .get,encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
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
    
    /********************************getItemsbasedid*************************************************/
    
    func getUserById(id : Int,headers : HTTPHeaders,completion : @escaping (String,UserList?)-> Void) {
        
        Alamofire.request("\(Constants.Bookmarkpost)/\(id)", method: .get,encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            print(response.request as Any)
            print(response.result.value as Any)
            
            switch response.result {
                
            case .success :
                
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
    
    /************************Events Api**********************************/
    func bookmarEntinty(parameters : Parameters,headers : HTTPHeaders,completion : @escaping (String,BookmarkModel?) -> Void) {
        
        Alamofire.request("\(Constants.Bookmarkpost)/\(PrefsManager.sharedinstance.userId)/bookmarks", method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            print(response.request)
            
            switch response.result {
                
            case .success:
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let bookmarkresponse = BookmarkModel(json: json) {
                        
                        print(bookmarkresponse)
                        completion("success",bookmarkresponse)
                    }
                    
                }
                
                
            case .failure(let error) :
                
                print(error)
                if let httpStatusCode = response.response?.statusCode {
                    
                    if let value = response.data,httpStatusCode == 422  {
                        let json = JSON(value)
                        print(json)
                       completion("422",nil)
                        return
                    }
                    
                }
                
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
    
    ////******************************* Get Location by Item Id ****************************************/////
    
    func getLocationByItemId(id : Int,page : String,type : String,headers : HTTPHeaders,completion : @escaping (String,ItemLocationList?)-> Void) {
        
        var BaseUrl :String?
        
        switch type {
        case "Item":
            BaseUrl = Constants.ItemsApiUrl
            
        case "Business":
            BaseUrl = Constants.BusinessDetailApi
            
        default:
            BaseUrl = Constants.ItemsApiUrl
        }
        
        Alamofire.request("\(BaseUrl!)/\(id)/locations?\(page)", method: .get,encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            print("response request is:::::::::::",response.request as Any)
            print("response result is:::::::",response.result.value as Any)
            
            switch response.result {
                
            case .success :
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let list = ItemLocationList(json: json) {
                        
                        completion("success",list)
                        
                    }
                    
                }
                
                
            case .failure(let error):
                
                print(error.localizedDescription)
                completion(error.localizedDescription,nil)
                
            }
            
        }
        
    }
   
    /************************Location detail api**********************************/
    
    func getLocationsById(id : Int,headers : HTTPHeaders,completion : @escaping (String,LocationModel?)-> Void) {
        
        Alamofire.request("\(Constants.LocationApiUrl)/\(id)", method: .get,encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            print(response.request as Any)
            print(response.result.value as Any)
            
            switch response.result {
                
            case .success :
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let itemList = LocationModel(json: json) {
                        
                        completion("success",itemList)
                    }
                    
                }
                
                
            case .failure(let error):
                
                print(error.localizedDescription)
                completion(error.localizedDescription,nil)
                
            }
            
        }
        
    }
    
    
    /**********************************getPlace Lat long*************************************************/
    
    /************************City Api****************************/
    
    func getPlaceCordinates(placeid_Str:String,completion : @escaping (Double,Double) -> Void) {
        
        let parameters: Parameters = ["placeid": placeid_Str , "key" : "AIzaSyDmfYE1gIA6UfjrmOUkflK9kw0nLZf0nYw"]
        
        Alamofire.request(Constants.PlaceDetailApi, parameters: parameters).validate().responseJSON { response in
            
            print(response.request as Any)
            
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    let resultjson = json["result"]["geometry"]["location"]
                    
                    if let lat = resultjson["lat"].double,let lng = resultjson["lng"].double {
                        
                        completion(lat,lng)
                    } else {
                        
                         completion(0,0)
                        
                    }
                    
                    
                }
                
            case .failure(let error) :
                print(error)
                completion(0,0)
            
            }
            
        }
        
    }
    
    /************************City Api****************************/
    
    func getPlaceGeocode(placeid_Str:String,completion : @escaping (String,String) -> Void) {
        
        let parameters: Parameters = ["latlng": placeid_Str , "key" : "AIzaSyDmfYE1gIA6UfjrmOUkflK9kw0nLZf0nYw"]
        
        Alamofire.request(Constants.PlaceGeoCodeApi, parameters: parameters).validate().responseJSON { response in
            
            print(response.request as Any)
            
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    if let jsonarray = json["results"].array {
                        
                        for (no,item) in jsonarray.enumerated() {
                            
                            if let address = item["formatted_address"].string {
                                
                                if no == 0 {
                                    
                                    completion("OK",address)
                                }
                                
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            case .failure(let error) :
                print(error)
                completion("No",error.localizedDescription)
                
            }
            
        }
        
    }
    
    ///////******** Get Bookmarks **********/////////
    func getBookmarks(id : Int,page : String,headers : HTTPHeaders,completion : @escaping (String,BookMarkMainModel?)-> Void) {
        
        Alamofire.request("\(Constants.Bookmarkpost)/\(id)/bookmarks?\(page)", method: .get,encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            
            switch response.result {
                
            case .success :
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    if let list = BookMarkMainModel(json: json) {
                        
                        completion("success",list)
                        
                    }
                    
                }
                
                
            case .failure(let error):
                
                print(error.localizedDescription)
                completion(error.localizedDescription,nil)
                
            }
            
        }
        
    }
    
    
    /************************Delete Bookmark*******************************/
    func deleteBookmark(id:Int,headers : HTTPHeaders,completion : @escaping (String) -> Void) {
        
        Alamofire.request("\(Constants.bookMarkApi)/\(id)",method: .delete, encoding: JSONEncoding.default,headers: headers).validate().responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                if let httpStatusCode = response.response?.statusCode {
                
                    if httpStatusCode == 200{
                        
                        completion("success")
                    }
                    
                    
                } else {
                    
                    completion("failure")
                }
                
                
            case .failure(let error):
                
                print(error)
                if let httpStatusCode = response.response?.statusCode {
                    
                    if httpStatusCode == 200 {
                        
                        completion("success")
                    }
                    
                    
                } else {
                    
                    completion("failure")
                }
                
            }
            
        }
        
    }
    

    /************************Delete Image*******************************/
    func deleteImage(id:Int,image : String,headers : HTTPHeaders,completion : @escaping (String) -> Void) {
        
        Alamofire.request("\(Constants.Bookmarkpost)/\(id)/images/\(image)",method: .delete, encoding: JSONEncoding.default,headers: headers).validate().responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                if let httpStatusCode = response.response?.statusCode {
                    
                    if httpStatusCode == 200 {
                        
                        completion("success")
                    }
                    
                    
                } else {
                    
                    completion("failure")
                }
                
                
            case .failure(let error):
                
                print(error)
                if let httpStatusCode = response.response?.statusCode {
                    
                    if httpStatusCode == 200 {
                        
                        completion("success")
                    }
                    
                    
                } else {
                    
                    completion("failure")
                }
                
            }
            
        }
        
    }
    
    
}
