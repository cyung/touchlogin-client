//
//  TouchViewController.swift
//  TouchLogin
//
//  Created by Christopher Yung on 2/13/16.
//  Copyright © 2016 TouchLogin. All rights reserved.
//

import UIKit
import LocalAuthentication
import Alamofire

class TouchViewController: UIViewController {
  
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var nameForm: UITextField!
  @IBOutlet weak var emailForm: UITextField!
  @IBOutlet weak var authorizeButton: UIButton!
  @IBOutlet weak var updateButton: UIButton!
  var UID : String = UIDevice.currentDevice().identifierForVendor!.UUIDString
  var authorized : Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.statusLabel.text = "Unauthorized"
    loadInfo()
    authorizeButton.addTarget(self, action: "sendToServer", forControlEvents: .TouchUpInside)
    updateButton.addTarget(self, action: "sendToServer", forControlEvents: .TouchUpInside)
    authorizeButton.backgroundColor = UIColor.grayColor()
    authorizeButton.layer.cornerRadius = 5
    authorizeButton.layer.borderWidth = 1
    authorizeButton.layer.borderColor = UIColor.blackColor().CGColor
    authorizeButton.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 5);
    authorizeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    print("UID=\(UID)")
  }
  
  func authenticateUser() {
    if (authorized) {
      self.sendToServer()
      return
    }
    
    let touchIDManager = TouchIDManager()
    
    touchIDManager.authenticateUser(success: { () -> () in
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        self.authorized = true
        self.sendToServer()
        self.statusLabel.text = "AUTHORIZED"
      })
      }, failure: { (evaluationError: NSError) -> () in
        switch evaluationError.code {
        case LAError.SystemCancel.rawValue:
          print("Authentication cancelled by the system")
          self.statusLabel.text = "Unauthorized"
        case LAError.UserCancel.rawValue:
          print("Authentication cancelled by the user")
          self.statusLabel.text = "Unauthorized"
        case LAError.UserFallback.rawValue:
          print("User wants to use a password")
          self.statusLabel.text = "Password not supported"
        case LAError.TouchIDNotEnrolled.rawValue:
          print("TouchID not enrolled")
          self.statusLabel.text = "TouchID not supported"
        case LAError.PasscodeNotSet.rawValue:
          print("Passcode not set")
          self.statusLabel.text = "Unauthorized"
        default:
          print("Authentication failed")
          self.statusLabel.text = "Authentication failed"
        }
    })
  }
  
  func loadInfo() {
    self.nameForm.text = "Johnny"
    self.emailForm.text = "johnnyboy@gmail.com"
    
//    Alamofire.request(.GET, "http://localhost:3000", parameters: ["UID": UID, "origin": "us"])
//      .responseJSON { response in
//        print(response)
//        if let JSON = response.result.value {
//          print("JSON: \(JSON)")
//          self.nameForm.text = "Temp name"
//          self.emailForm.text = "Temp email"
//        }
//        
//        self.authenticateUser()
//    }
    self.authenticateUser()
  }
  
  func sendToServer() {
    let headers = [
      "Content-Type": "application/json",
    ]
    
    let parameters = [
      "name": self.nameForm.text!,
      "email": self.emailForm.text!,
    ]
    
    print("Successfully sent data to server")
    print(UID)
    
    let url = "https://alpha-004-dot-touch-login.appspot.com/_ah/api/touchloginAPI/v1/AuthenticateUser"
    
    Alamofire.request(.POST, url, headers: headers, parameters: parameters, encoding: .JSON)
      .response { response in
//        print(response)
    }
  }
  
  
}
