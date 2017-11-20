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
    
    /*********************Login *****************************/
    
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
    
    
    
}
