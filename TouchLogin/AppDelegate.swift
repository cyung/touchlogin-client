//
//  AppDelegate.swift
//  TouchLogin
//
//  Created by Christopher Yung on 2/13/16.
//  Copyright © 2016 TouchLogin. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions:
    [NSObject: AnyObject]?) -> Bool {
      
//      let settings: UIUserNotificationSettings =
//      UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
//      application.registerUserNotificationSettings(settings)
//      application.registerForRemoteNotifications()
      
      
      
      let notificationActionOk :UIMutableUserNotificationAction = UIMutableUserNotificationAction()
      notificationActionOk.identifier = "ACCEPT_IDENTIFIER"
      notificationActionOk.title = "Ok"
      notificationActionOk.destructive = false
      notificationActionOk.authenticationRequired = false
      notificationActionOk.activationMode = UIUserNotificationActivationMode.Background
      
      let notificationActionCancel :UIMutableUserNotificationAction = UIMutableUserNotificationAction()
      notificationActionCancel.identifier = "NOT_NOW_IDENTIFIER"
      notificationActionCancel.title = "No"
      notificationActionCancel.destructive = true
      notificationActionCancel.authenticationRequired = false
      notificationActionCancel.activationMode = UIUserNotificationActivationMode.Background
      
      let notificationCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
      notificationCategory.identifier = "INVITE_CATEGORY"
      notificationCategory .setActions([notificationActionOk,notificationActionCancel], forContext: UIUserNotificationActionContext.Default)
      notificationCategory .setActions([notificationActionOk,notificationActionCancel], forContext: UIUserNotificationActionContext.Minimal)
      
      
      let settings: UIUserNotificationSettings =
      UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: NSSet(array:[notificationCategory]) as! Set<UIUserNotificationCategory>)
      application.registerUserNotificationSettings(settings)
      application.registerForRemoteNotifications()
      return true
  }
  
  func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken
    deviceToken: NSData ) {
      print("registered for remote notifications")
      let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
      var tokenString = ""
      
      for i in 0..<deviceToken.length {
        tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
      }
      
      let parameters = [
//        "UID": UIDevice.currentDevice().identifierForVendor!.UUIDString,
        "tokenHex": tokenString
      ]
      
      print(deviceToken)
      print(parameters)
      
//      let url = "https://alpha-004-dot-touch-login.appspot.com/_ah/api/touchloginAPI/v1/SetAPNsToken"
//      let url = "http://BigMac.local:3000/auth"
//      
//      Alamofire.request(.GET, url, parameters: parameters, encoding: .JSON)
//        .response { response in
//          print(response)
//      }
  }
  
  func application( application: UIApplication, didFailToRegisterForRemoteNotificationsWithError
    error: NSError ) {
      print("Registration for remote notification failed with error: \(error.localizedDescription)")

  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    // display the userInfo
    print("RECEIVED REMOTE NOTIFICATION")
  }
  
//  func application( application: UIApplication,
//    didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
//      print("Notification received: \(userInfo)")
//  }

}

