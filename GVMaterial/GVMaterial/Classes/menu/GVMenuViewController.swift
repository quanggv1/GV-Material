//
//  GVMenuViewController.swift
//  GVMaterial
//
//  Created by Quanggv on 9/27/17.
//  Copyright © 2017 memesages. All rights reserved.
//

import UIKit


class GVMenuViewController: UIViewController {
  private static var menuVC: GVMenuViewController!
  static var shared: GVMenuViewController {
    get {
      if menuVC == nil {
        menuVC = GVMenuViewController(nibName: "GVMenuViewController", bundle: nil)
      }
      return menuVC
    }
  }
  
  @IBOutlet weak var menuTableView: UITableView!
  
  private var menuItems: [MenuItem] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let nib = UINib(nibName: "GVMenuTableViewCell", bundle: nil)
    menuTableView.register(nib, forCellReuseIdentifier: "gvmenucellid")
    menuTableView.dataSource = self
    menuTableView.delegate = self
    menuTableView.rowHeight = 44
    menuTableView.tableFooterView = UIView(frame: CGRect.zero)
    menuTableView.layer.borderWidth = 1
    menuTableView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
  }
  
  func setContent(_ items: [MenuItem]) {
    menuItems = items
  }
  
  func show() {
    let windows = UIApplication.shared.keyWindow!
    var menuFrame = UIScreen.main.bounds
    menuFrame.origin.x = -menuFrame.size.width
    view.frame = menuFrame
    windows.addSubview(view)
    NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: windows, attribute: .width, multiplier: 1.0, constant: 0.0).isActive = true
    NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: windows, attribute: .height, multiplier: 1.0, constant: 0.0).isActive = true
    UIView.animate(withDuration: 0.3) {
      self.view.frame = UIScreen.main.bounds
    }
  }
  
  @IBAction func hide() {
    var menuFrame = UIScreen.main.bounds
    menuFrame.origin.x = -menuFrame.size.width
    UIView.animate(withDuration: 0.3, animations: {
      self.view.frame = menuFrame
    }) { (isFinished) in
      if isFinished { self.view.removeFromSuperview() }
    }
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    view.frame = UIScreen.main.bounds
  }
}

extension GVMenuViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "gvmenucellid") as! GVMenuTableViewCell
    let menuItem = menuItems[indexPath.row]
    cell.title = menuItem.menuTitle
    cell.icon = menuItem.menuIcon
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let menuItem = menuItems[indexPath.row]
    menuItem.action?()
    hide()
  }
}

class MenuItem {
  var menuIcon: UIImage?
  var menuTitle: String!
  var action: (() -> ())?
  
  init(icon: UIImage?, title: String, action: (() -> ())?) {
    self.menuIcon = icon
    self.menuTitle = title
    self.action = action
  }
}
