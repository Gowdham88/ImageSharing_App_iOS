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

class  ApiClient {
    
    /*********************Login Api*****************************/
    
    func userLogin(parameters : Parameters,completion : @escaping (String,UserList?) -> Void) {
        
        Alamofire.request(Constants.LoginApiUrl, method: .post, parameters: parameters).validate().responseJSON { response in
       
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
    
    func usernameexists(parameters : Parameters, completion : @escaping (String,Bool?) -> Void) {
        Alamofire.request(Constants.CheckUserName, method: .get, parameters: parameters).validate().responseJSON { response in
            
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
    func getEventsApi(parameters : Parameters,completion : @escaping (String,TagList?) -> Void) {
        
        Alamofire.request(Constants.EventApiUrl, method: .get, parameters: parameters).validate().responseJSON { response in
            
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
    
    /************************Items Api**********************************/
    func getItemsApi(parameters : Parameters,completion : @escaping (String,TagList?) -> Void) {
        
        Alamofire.request(Constants.ItemsApiUrl, method: .get, parameters: parameters).validate().responseJSON { response in
            
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
    
}
