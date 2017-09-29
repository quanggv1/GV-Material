//
//  TextFieldViewController.swift
//  GVMaterial
//
//  Created by Quanggv on 9/27/17.
//  Copyright © 2017 memesages. All rights reserved.
//

import UIKit

class TextFieldViewController: UIViewController {
  @IBOutlet weak var floatingTextField: FloatingTextField!
  @IBOutlet weak var ftfWithDescription: FloatingTextField!
  @IBOutlet weak var imageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareFloatingField()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let userDefault = UserDefaults(suiteName: "group.GVMaterial")!
    
    if let imageData = userDefault.value(forKey: "img") as? Data {
      self.imageView.image = UIImage(data: imageData)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func showMenu() {
    view.endEditing(true)
    GVMenuViewController.shared.show()
  }
}

extension TextFieldViewController {
  func prepareFloatingField() {
    floatingTextField.header = "Nhập \"start\" để bắt đầu"
    floatingTextField.footer = "Chưa nhập đúng \"start\""
    floatingTextField.validate = { return self.floatingTextField.text! == "start" }
    
    ftfWithDescription.header = "Always show footer"
    ftfWithDescription.footer = "Description!"
    ftfWithDescription.isFooterAlwaysShow = true
    ftfWithDescription.footerColor = UIColor.blue.withAlphaComponent(0.3)
  }
}

