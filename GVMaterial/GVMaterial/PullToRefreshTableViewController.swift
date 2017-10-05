//
//  PullToRefreshTableViewController.swift
//  GVMaterial
//
//  Created by Quanggv on 9/28/17.
//  Copyright © 2017 memesages. All rights reserved.
//

import UIKit

class PullToRefreshTableViewController: UIViewController {
  @IBOutlet weak var pfrTableView: PTRTableView!
  
  private var data = ["value1", "value2", "value3"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    preparePTRTableView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func showMenu() {
    GVMenuViewController.shared.show()
  }
}

extension PullToRefreshTableViewController {
  func preparePTRTableView() {
    pfrTableView.dataSource = self
    pfrTableView.delegate = self
    pfrTableView.rowHeight = 44
    pfrTableView.pullToFresh {
      //fetch data
      ActivityIndicator.shared.start()
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
        ActivityIndicator.shared.stop()
        Alert.show(title: "", message: "Cập nhật thành công!", okTitle: "OK", okAction: nil)
      })
    }
    pfrTableView.tableFooterView = UIView(frame: CGRect.zero)
  }
}

extension PullToRefreshTableViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
    if cell == nil {
      cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
    }
    cell!.textLabel?.text = data[indexPath.row]
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

