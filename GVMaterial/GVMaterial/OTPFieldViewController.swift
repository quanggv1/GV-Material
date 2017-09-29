//
//  OTPFieldViewController.swift
//  GVMaterial
//
//  Created by Quanggv on 9/27/17.
//  Copyright © 2017 memesages. All rights reserved.
//

import UIKit

class OTPFieldViewController: UIViewController {
  @IBOutlet weak var otpField: OTPTextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareOtpField()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func showMenu() {
    GVMenuViewController.shared.show()
  }
  
}

extension OTPFieldViewController {
  func prepareOtpField() {
    otpField.header = "Nhập mã OTP"
    otpField.footer = "Mã OTP được gửi về số điện thoại của bạn"
    otpField.maxLength = 6
    otpField.setOTPTimeExpired(10) {
      Alert.show(title: "", message: "Time out!", okTitle: "OK", okAction: {
        self.otpField.setOTPTimeExpired(10, expired: nil)
      })
    }
  }
}
