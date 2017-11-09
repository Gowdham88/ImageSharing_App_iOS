 //
//  AppDelegate.swift
//  Numnu
//
//  Created by Paramesh on 18/09/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import Firebase
import GSMessages
import UserNotifications
import SystemConfiguration
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift

 
 
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GMSServices.provideAPIKey(Constants.MapApiKey)
        GMSPlacesClient.provideAPIKey(Constants.MapApiKey)
        Thread.sleep(forTimeInterval: 3.0)
        
        /*****Screen opening function******/
        openFirstScreen()
        IQKeyboardManager.sharedManager().enable = true

        return true
  }
    
 

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }


    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

 func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
 }
 
 /********************opening onboard screen***********************/
  
    func openFirstScreen() {

        let when = DispatchTime.now() + 0
        DispatchQueue.main.asyncAfter(deadline: when) {

            self.window    = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: Constants.Auth, bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: Constants.LoginStoryId)
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()

        }

    }

 }
 extension UIViewController {
   

    func showAlertMessage() {

//        self.showMessage("Oops! It seems you are not connected to internet.", type: .warning,options: [
//            .animation(.slide),
//            .animationDuration(0.3),
//            .autoHide(true),
//            .autoHideDelay(3.0),
//            .height(44.0),
//            .hideOnTap(true),
//            .position(.bottom),
//            .textAlignment(.center),
//            .textColor(UIColor.white),
//            .textNumberOfLines(1),
//            .textPadding(30.0)
//            ])

    }

    func showAlertMessagepop(title : String) {

//        self.showMessage(title, type: .warning,options: [
//            .animation(.slide),
//            .animationDuration(0.3),
//            .autoHide(true),
//            .autoHideDelay(3.0),
//            .height(44.0),
//            .hideOnTap(true),
//            .position(.bottom),
//            .textAlignment(.center),
//            .textColor(UIColor.white),
//            .textNumberOfLines(1),
//            .textPadding(30.0)
//            ])

    }
    
   

    /*****Keyboard close******/

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
 }
 
