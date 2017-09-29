//
//  Alert.swift
//  GVMaterial
//
//  Created by Quanggv on 9/27/17.
//  Copyright © 2017 memesages. All rights reserved.
//

import UIKit

class Alert {
  static func show(title: String, message: String, okTitle: String, okAction: (() -> ())?) {
    DispatchQueue.main.async {
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: okTitle, style: .default, handler: { (alert) in
        okAction?()
      }))
      var topController = UIApplication.shared.keyWindow!.rootViewController!
      while let presentedViewController = topController.presentedViewController {
        topController = presentedViewController
      }
      topController.present(alert, animated: true, completion: nil)
    }
  }
}
