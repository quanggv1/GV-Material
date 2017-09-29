//
//  FloatingTextField.swift
//  Agent-App
//
//  Created by Quanggv on 9/19/17.
//  Copyright © 2017 Agent-App. All rights reserved.
//

import UIKit

class FloatingTextField: UITextField {
  private var headerLabel: UILabel!
  private var footerLabel: UILabel!
  private var underline: UIView!
  
  enum FloatingStyle {
    case none
    case currency
  }
  
  var isFooterAlwaysShow: Bool = false {
    didSet {
      footerLabel.isHidden = !isFooterAlwaysShow
    }
  }
  
  var isFooterHidden: Bool = true {
    didSet {
      footerLabel.isHidden = isFooterAlwaysShow ? false : isFooterHidden
    }
  }
  
  var footerColor: UIColor = .red {
    didSet {
      footerLabel.textColor = footerColor
    }
  }
  
  var style: FloatingStyle = .none
  var maxLength: Int?

  override public var text: String? {
    didSet {
      self.headerLabel.alpha = 1
    }
  }
  
  var header: String = "" {
    didSet {
      headerLabel.text = header
      self.placeholder = header
    }
  }
  
  var footer: String = "" {
    didSet {
      footerLabel.text = footer
    }
  }
  
  var validate: (() -> Bool)?
  
  var basecolor: UIColor = UIColor.lightGray {
    didSet {
      underline.backgroundColor = basecolor
    }
  }
  
  var activecolor: UIColor = UIColor.orange {
    didSet {
      self.tintColor = activecolor
    }
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    
    self.borderStyle = .none
    self.clipsToBounds = false
    self.tintColor = activecolor
    
    
    underline = UIView(frame: CGRect(x: 0,
                                     y: self.frame.size.height,
                                     width: self.frame.size.width,
                                     height: 1))
    underline.backgroundColor = basecolor
    underline.autoresizingMask = .flexibleWidth
    self.addSubview(underline)
    
    headerLabel = UILabel(frame: CGRect(x: 0,
                                        y: -15,
                                        width: self.frame.size.width,
                                        height: 20))
    headerLabel.font = UIFont.systemFont(ofSize: 13)
    headerLabel.alpha = 0
    headerLabel.textColor = basecolor
    headerLabel.autoresizingMask = (.flexibleWidth)
    self.addSubview(headerLabel)
    
    footerLabel = UILabel(frame: CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: 20))
    footerLabel.font = UIFont.systemFont(ofSize: 12)
    footerLabel.textColor = footerColor
    footerLabel.isHidden = isFooterAlwaysShow ? false : isFooterHidden
    footerLabel.autoresizingMask = .flexibleWidth
    self.addSubview(footerLabel)
    self.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
    self.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
    self.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
  }
  
  @objc func textFieldDidBeginEditing(_ textField: UITextField) {
    isFooterHidden = true
    self.headerLabel.textColor = self.activecolor
    self.underline.backgroundColor = self.activecolor
    self.placeholder = ""
    
    UIView.animate(withDuration: 0.5) {
      self.headerLabel.alpha = 1
      var frame = self.underline.frame
      frame.size.height = 2
      self.underline.frame = frame
    }
  }
  
  @objc func textFieldDidEndEditing(_ textField: UITextField) {
    self.headerLabel.textColor = self.basecolor
    self.underline.backgroundColor = self.basecolor
    if textField.text!.isEmpty {
      UIView.animate(withDuration: 0.3, animations: {
        self.headerLabel.alpha = 0
      }, completion: { (finished) in
        if finished { self.placeholder = self.header }
      })
    }
    
    var frame = underline.frame
    frame.size.height = 1
    underline.frame = frame
    
    guard validate != nil else { return }
    isFooterHidden = validate!()
  }
  
  @objc func myTextFieldDidChange(_ textField: UITextField) {
    textField.text = textField.text!.safelyLimitedTo(length: maxLength)
    if style == .none { return }
    if let amountString = textField.text?.currencyInputFormatting() {
      textField.text = amountString
    }
  }
}

//private var __maxLengths = [UITextField: Int]()
//extension UITextField {
//  @IBInspectable var maxLength: Int {
//    get {
//      guard let l = __maxLengths[self] else {
//        return 150 // (global default-limit. or just, Int.max)
//      }
//      return l
//    }
//    set {
//      __maxLengths[self] = newValue
//      addTarget(self, action: #selector(fix), for: .editingChanged)
//    }
//  }
//  @objc func fix(textField: UITextField) {
//    let t = textField.text
//    textField.text = t?.safelyLimitedTo(length: maxLength)
//  }
//}

extension String
{
  func safelyLimitedTo(length n: Int?) -> String {
    guard n != nil else { return self }
    let c = self.characters
    if (c.count <= n!) { return self }
    return String( Array(c).prefix(upTo: n!) )
  }
  
  func currencyInputFormatting() -> String {
    
    var number: NSNumber!
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    
    var amountWithPrefix = self
    // remove from String: "$", ".", "," "..."
    let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
    amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
    let double = (amountWithPrefix as NSString).doubleValue
    number = NSNumber(value: (double))
    // if first number is 0 or all numbers were deleted
    guard number != 0 as NSNumber else {
      return ""
    }
    return formatter.string(from: number)!
  }
  
  func intFromCurrency() -> Int {
    var amountWithPrefix = self
    let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
    amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
    return (amountWithPrefix as NSString).integerValue
  }
}


