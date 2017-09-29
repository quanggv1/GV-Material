//
//  ShareViewController.swift
//  GVMaterialShare
//
//  Created by Quanggv on 9/28/17.
//  Copyright © 2017 memesages. All rights reserved.
//

import UIKit
import Social

class ShareViewController: UIViewController {
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let item = self.extensionContext?.inputItems.first as? NSExtensionItem {
      for ele in item.attachments! {
        let itemProvider = ele as! NSItemProvider
        
        if itemProvider.hasItemConformingToTypeIdentifier("public.jpeg") ||
          itemProvider.hasItemConformingToTypeIdentifier("public.png") {
          NSLog("itemprovider: %@", itemProvider)
          itemProvider.loadItem(forTypeIdentifier: itemProvider.registeredTypeIdentifiers.first!, options: nil, completionHandler: { (item, error) in
            
            var imgData: Data!
            if let url = item as? URL { imgData = try! Data(contentsOf: url) }
            if let img = item as? UIImage { imgData = UIImagePNGRepresentation(img) }
            let userDefault = UserDefaults(suiteName: "group.GVMaterial")!
            userDefault.set(imgData, forKey: "img")
          
            DispatchQueue.main.async {
              self.backToMainApplication()
              self.extensionContext!.completeRequest(returningItems: [self.extensionContext?.inputItems.first as! NSExtensionItem], completionHandler: nil)
            }
          })
        } else {
          self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        }
      }
    }
  }
  
  func backToMainApplication() {
    var responder = self as UIResponder?
    let url = NSURL(string: "GVMaterial://")
    let selectorOpenURL = sel_registerName("openURL:")
    let context = NSExtensionContext()
    context.open(url! as URL, completionHandler: nil)
    while (responder != nil){
      if responder?.responds(to: selectorOpenURL) == true {
        if responder?.perform(selectorOpenURL, with: url) != nil {}
      }
      responder = responder!.next
    }
  }
}
