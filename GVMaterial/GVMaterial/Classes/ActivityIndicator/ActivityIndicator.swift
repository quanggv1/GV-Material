//
//  ActivityIndicator.swift
//  GVMaterial
//
//  Created by Quanggv on 9/28/17.
//  Copyright © 2017 memesages. All rights reserved.
//

import UIKit

class ActivityIndicator {
  private init() {
    activityView = UIView()
    activityView.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
    activityView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    activityIndicatorImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    activityIndicatorImage.image = #imageLiteral(resourceName: "ic_autorenew.png").withRenderingMode(.alwaysTemplate)
    activityIndicatorImage.tintColor = UIColor.blue.withAlphaComponent(0.4)
    activityIndicatorImage.contentMode = .scaleAspectFill
    activityView.addSubview(activityIndicatorImage)
    activityIndicatorImage.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin]
  }
  
  static let shared = ActivityIndicator()
  
  var activityView: UIView!
  var activityIndicatorImage: UIImageView!
  
  func start() {
    let window = UIApplication.shared.keyWindow
    activityView.frame = UIScreen.main.bounds
    window?.addSubview(activityView)
    activityIndicatorImage.center = activityView.center
    
    let rotate = CABasicAnimation(keyPath: "transform.rotation")
    rotate.fromValue = NSNumber(floatLiteral: 0)
    rotate.toValue = NSNumber(floatLiteral: 2 * Double.pi)
    rotate.duration = 1.0
    rotate.repeatCount = HUGE
    activityIndicatorImage.layer.add(rotate, forKey: "customspin")
  }
  
  func stop() {
    activityIndicatorImage.layer.removeAllAnimations()
    activityView.removeFromSuperview()
  }
  
}
