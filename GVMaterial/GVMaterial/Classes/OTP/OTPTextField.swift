//
//  OTPTextField.swift
//  Agent-App
//
//  Created by Quanggv on 9/18/17.
//  Copyright © 2017 Agent-App. All rights reserved.
//
//  Tutorial
//  This textfield need padding top atleast 20px and padding bottom 25, height 35px
//


import UIKit

class OTPTextField: UITextField {
  private var underline: UIView!
  private var headerLabel: UILabel!
  private var footerLabel: UILabel!
  private var otpTimeoutView: UIView!
  
  private var timer: Timer!
  private var timeleft = 0
  private var timeout = 20
  private var timeoutCB: (() -> ())?
  
  var maxLength: Int = 0 {
    didSet {
      for item in 1...maxLength {
        let width = self.frame.size.height
        let x = CGFloat(item - 1) * width
        let height = width
        let pinField = UITextField(frame: CGRect(x: x, y: 0, width: width, height: height))
        pinField.tag = item
        pinField.borderStyle = .none
        pinField.placeholder = "●"
        pinField.textAlignment = .center
        pinField.backgroundColor = .white
        pinField.isEnabled = false
        pinField.autoresizingMask = .flexibleHeight
        pinField.font = UIFont.boldSystemFont(ofSize: 20)
        pinField.textColor = activeColor
        self.addSubview(pinField)
      }
    }
  }
  
  var header: String = "" {
    didSet {
      headerLabel.text = header
    }
  }
  
  var footer: String = "" {
    didSet {
      footerLabel.text = footer
    }
  }
  
  var baseColor: UIColor = .lightGray {
    didSet {
      underline.backgroundColor = baseColor
      headerLabel.textColor = baseColor
    }
  }
  
  var activeColor: UIColor = .orange {
    didSet {
      underline.backgroundColor = activeColor
      headerLabel.textColor = activeColor
    }
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    self.borderStyle = .none
    underline = UIView(frame: CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: 1))
    underline.backgroundColor = baseColor
    underline.autoresizingMask = .flexibleWidth
    self.addSubview(underline)
    
    self.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
    self.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
    self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    
    self.tintColor = UIColor.clear
    self.textColor = UIColor.clear
    self.keyboardType = .numberPad
    self.clipsToBounds = false
    
    headerLabel = UILabel(frame: CGRect(x: 0, y: -15, width: self.frame.size.width, height: 20))
    headerLabel.font = UIFont.systemFont(ofSize: 13)
    headerLabel.textColor = baseColor
    headerLabel.autoresizingMask = (.flexibleWidth)
    self.addSubview(headerLabel)
    
    footerLabel = UILabel(frame: CGRect(x: 0, y: self.frame.size.height + 5, width: self.frame.size.width, height: 20))
    footerLabel.font = UIFont.italicSystemFont(ofSize: 13)
    footerLabel.textColor = activeColor
    footerLabel.autoresizingMask = .flexibleWidth
    self.addSubview(footerLabel)
    
    self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
  }
  
  @objc func textFieldDidEndEditing(_ textField: UITextField) {
    underline.backgroundColor = baseColor
    headerLabel.textColor = baseColor
  }
  
  @objc func textFieldDidBeginEditing(_ textField: UITextField) {
    underline.backgroundColor = activeColor
    headerLabel.textColor = activeColor
  }
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    textField.text = textField.text!.safelyLimitedTo(length: maxLength)
    // clear all pinfields
    for tag in 1...maxLength {
      (self.viewWithTag(tag) as! UITextField).text = ""
    }
    // update pinfields
    if let pin = textField.text?.characters {
      for (index, element) in pin.enumerated() {
        if let pinField = self.viewWithTag(index + 1) as? UITextField {
          pinField.text = String(element)
        }
      }
    }
  }
  
  func setOTPTimeExpired(_ seconds: Int, expired: (() -> ())?) {
    otpTimeoutView = UIView(frame: CGRect(x: 0,
                                          y: self.frame.size.height + 30,
                                          width: self.frame.size.width,
                                          height: 2))
    otpTimeoutView.backgroundColor = UIColor.green.withAlphaComponent(0.5)
    otpTimeoutView.autoresizingMask = .flexibleWidth
    self.addSubview(otpTimeoutView)
    timeout = seconds
    timeleft = seconds
    timeoutCB = expired
    UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
    RunLoop.current.add(timer, forMode: .commonModes)
  }
  
  @objc func countDown() {
    if timeleft <= 0 {
      timer.invalidate()
      timeoutCB?()
      return
    }
    timeleft -= 1
    let width = self.frame.size.width * CGFloat(timeleft) / CGFloat(timeout)
    var frame = otpTimeoutView.frame
    frame.size.width = width
    UIView.animate(withDuration: 1) {
      self.otpTimeoutView.frame = frame
    }
  }
  
  func otpTimeoutCancel() {
    if timer != nil { timer.invalidate() }
  }
}

