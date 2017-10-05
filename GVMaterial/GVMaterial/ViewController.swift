//
//  ViewController.swift
//  GVMaterial
//
//  Created by Quanggv on 9/27/17.
//  Copyright © 2017 memesages. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  lazy var textfieldController: UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "storyboardtextfieldid")
  lazy var otpFieldController: UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "storyboardotpfieldid")
  lazy var pullTofreshTableController: UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "storyboardpulltorefreshtable")
  
  var rootViewController: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareMenu()
    updateRootViewController(textfieldController)
  }
  
  func updateRootViewController(_ vc: UIViewController) {
    if rootViewController != nil {
      rootViewController.removeFromSuperview()
    }
    rootViewController = vc.view
    rootViewController.frame = UIScreen.main.bounds
    view.addSubview(rootViewController)
    
  }
}

extension ViewController {
  func prepareMenu() {
    let item1 = MenuItem(icon: nil, title: "TextField") {
      self.updateRootViewController(self.textfieldController)
    }
    let item2 = MenuItem(icon: nil, title: "OTP") {
      self.updateRootViewController(self.otpFieldController)
    }
    let item3 = MenuItem(icon: nil, title: "Pull To Refresh Table") {
      self.updateRootViewController(self.pullTofreshTableController)
    }
    GVMenuViewController.shared.setContent([item1, item2, item3])
  }
}

