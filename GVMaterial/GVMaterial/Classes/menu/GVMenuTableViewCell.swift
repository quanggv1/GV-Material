//
//  GVMenuTableViewCell.swift
//  GVMaterial
//
//  Created by Quanggv on 9/27/17.
//  Copyright © 2017 memesages. All rights reserved.
//

import UIKit

class GVMenuTableViewCell: UITableViewCell {
  @IBOutlet weak var menuIconImageView: UIImageView!
  @IBOutlet weak var menuDescriptionLabel: UILabel!
  @IBOutlet weak var menuIconWidthConstaint: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  var title: String {
    get {
      return menuDescriptionLabel.text ?? ""
    }
    set {
      menuDescriptionLabel.text = newValue
      guard (menuIconImageView.image != nil) else { return }
      menuIconWidthConstaint.constant = 0
    }
  }
  
  var icon: UIImage? {
    get {
      return menuIconImageView.image
    }
    set {
      if let menuIcon = newValue {
        menuIconImageView.image = menuIcon
        menuIconWidthConstaint.constant = 35
      } else {
        menuIconWidthConstaint.constant = 0
      }
    }
  }
  
  
}
