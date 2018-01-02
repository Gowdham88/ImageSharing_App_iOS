 //
//  AppDelegate.swift
//  Numnu
//
//  Created by Paramesh on 18/09/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit
import Firebase
//import GSMessages
import UserNotifications
import SystemConfiguration
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import FirebaseMessaging

 
 
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
//    var orientationLock = UIInterfaceOrientationMask.portrait
    var orientationLock = UIInterfaceOrientationMask.portrait
//    var myOrientation: UIInterfaceOrientationMask = .portrait

    var window: UIWindow?
    var shouldRotate = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GMSServices.provideAPIKey(Constants.MapApiKey)
        GMSPlacesClient.provideAPIKey(Constants.MapApiKey)
        
        /******************Notification****************************/
        
        if #available(iOS 10.0, *) {
            
            
            // For iOS 10 display notification (sent via APNS)
            
            UNUserNotificationCenter.current().delegate = self
            
            // For iOS 10 data message (sent via FCM)
            
            Messaging.messaging().delegate = self
            
        }
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.tokenRefreshNotification),
//                                               name: .,
//                                               object: nil)
        
        Thread.sleep(forTimeInterval: 3.0)
        
        /*****Screen opening function******/
        openFirstScreen()
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        return true
  }
    
    
    /******************Notification****************************/
    
    func tokenRefreshNotification(_ notification: Notification) {
        
        if let refreshedToken = InstanceID.instanceID().token() {
            
            print("InstanceID token: \(refreshedToken)")
          
        }
        
        
        connectToFcm()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        print("%@", userInfo)
        
        _ = userInfo["title"] as? String ?? ""
        
        
        
        
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired NotificationQueuen the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        // Print full message.
        print("%@", userInfo)
        
        _ = userInfo["title"] as? String ?? ""
     
        
    }
    
    
    func connectToFcm() {
        Messaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(String(describing: error))")
            } else {
                print("Connected to FCM.")
            }
        }
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quiNotificationQueuend it begins the transition to the background state.
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
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        /****************** Notification ****************************/
        
        connectToFcm()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications \(error)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        InstanceID.instanceID().setAPNSToken(deviceToken, type: InstanceIDAPNSTokenType.unknown)
        
        print("Firtoken: \(InstanceID.instanceID().token())")
        
        if let refreshedToken = InstanceID.instanceID().token() {
            
//            Devicetoken = refreshedToken
        }
        
        
        
    }


    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        return orientationLock
//    }
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) ->
//        UIInterfaceOrientationMask {
//    
//            return orientationLock
//    }
    
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        if self.window?.rootViewController?.presentedViewController is PostImageZoomViewController {
            
            let secondController = self.window!.rootViewController!.presentedViewController as! PostImageZoomViewController
            
            if secondController.isPresented { // Check current controller state
                return UIInterfaceOrientationMask.all;
            } else {
                return UIInterfaceOrientationMask.portrait;
            }
        } else {
            return UIInterfaceOrientationMask.portrait;
        }
        
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
 
 protocol Utilities {
 }
 
 extension NSObject:Utilities{
    
    
    enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }
    
    var currentReachabilityStatus: ReachabilityStatus {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        
        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }
    
 }

 extension UIApplication{
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    
    
    if let nav = base as? UINavigationController {
    return topViewController(base: nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
    let moreNavigationController = tab.moreNavigationController
    
    if let top = moreNavigationController.topViewController, top.view.window != nil {
    return topViewController(base: top)
    } else if let selected = tab.selectedViewController {
    return topViewController(base: selected)
    }
    }
    if let presented = base?.presentedViewController {
    return topViewController(base: presented)
    }
    
    return base
    }
    
   
    
    
 }
 
 @available(iOS 10, *)
 extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"] as? String ?? "fcm")")
        
        // Print full message.
        print("%@", userInfo)
        
        let title = userInfo["my_key"] as? String ?? ""
        
        // Print full message.
        print("date", title)
        
        completionHandler([.alert,.badge,.sound])
    }
    
    
    
    
 }
 
 extension AppDelegate : MessagingDelegate {
    // Receive data message on iOS 10 devices.
    func application(received remoteMessage: MessagingRemoteMessage) {
        print("dateds", remoteMessage.appData)
        
        
    }
 }
  
 
