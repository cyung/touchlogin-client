//
//  TouchIDManager.swift
//  TouchLogin
//
//  Created by Christopher Yung on 2/13/16.
//  Copyright © 2016 TouchLogin. All rights reserved.
//

import UIKit
import LocalAuthentication

class TouchIDManager {
  func authenticateUser(success succeed: (() -> ())? = nil, failure fail: (NSError -> ())? = nil) {
    let context = LAContext()
    var error : NSError?
    let authString = "Authentication is required"
    
    if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
      context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: authString as String, reply: { (success : Bool, evaluationError : NSError?) -> Void in
        if success {
          if let succeed = succeed {
            dispatch_async(dispatch_get_main_queue()) {
              succeed()
            }
          }
        } else {
          if let fail = fail {
            dispatch_async(dispatch_get_main_queue()) {
              fail(evaluationError!)
            }
          }
        }
      })
    } else {
      if let fail = fail {
        dispatch_async(dispatch_get_main_queue()) {
          fail(error!)
        }
      }
    }
  }
}