//
//  PTFTableView.swift
//  Sale App
//
//  Created by Quanggv on 9/23/17.
//  Copyright © 2017 TMN. All rights reserved.
//

import UIKit

class PTRTableView: UITableView {
  private var ptfAction: (() -> ())?
  private var isFreshing = false
  private var ptfLabel: UILabel?
  private var imageView: UIImageView?
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    
    let view = UIView(frame: CGRect(x: 0, y: -70, width: UIScreen.main.bounds.size.width, height: 70))
    ptfLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 70))
    ptfLabel!.font = UIFont.boldSystemFont(ofSize: 15)
    ptfLabel!.text = "Kéo để cập nhật"
    ptfLabel!.textColor = .darkGray
    ptfLabel!.textAlignment = .center
    ptfLabel!.autoresizingMask = .flexibleWidth
    
    imageView = UIImageView(frame: CGRect(x: 10, y: 5, width: 60, height: 60))
    imageView!.image = #imageLiteral(resourceName: "ic_arrow_downward").withRenderingMode(.alwaysTemplate)
    imageView?.tintColor = UIColor.blue.withAlphaComponent(0.4)
    
    view.addSubview(imageView!)
    view.addSubview(ptfLabel!)
    self.addSubview(view)
  }
  
  func pullToFresh(_ action: @escaping () -> ()) {
    ptfAction = action
  }
  
  override var contentOffset: CGPoint {
    willSet {
      ptfLabel?.text = contentOffset.y < -70.0 ? "Thả để cập nhật" : "Kéo để cập nhật"
      if contentOffset.y < -70 {
        UIView.animate(withDuration:0.2, animations: {
          self.imageView?.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
        })
      } else {
        UIView.animate(withDuration:0.2, animations: {
          self.imageView?.transform = CGAffineTransform(rotationAngle: 0)
        })
      }
      if isDragging {
        isFreshing = false
      }
      if !isDragging && contentOffset.y <= -70.0 && !isFreshing {
        isFreshing = true
        self.ptfAction?()
      }
    }
  }
}
