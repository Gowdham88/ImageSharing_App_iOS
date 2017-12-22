//
//  LoadingHepler.swift
//  Numnu
//
//  Created by CZ Ltd on 12/21/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

struct LoadingHepler {
    
    private static let _instance = LoadingHepler()
    
    private init() {}
    
    static var instance: LoadingHepler {
        
        return _instance
        
    }
    
    func show() {
        
        NVActivityIndicatorView.DEFAULT_TYPE = NVActivityIndicatorType.circleStrokeSpin
//        NVActivityIndicatorView.DEFAULT_COLOR = UIColor.appThemeColor()
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
    }
    
    func hide() {
        
         NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        
    }


}
