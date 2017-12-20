//
//  ViewController.swift
//  Anyone
//
//  Created by Halcao on 2017/12/19.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import Material
import Alamofire

class ViewController: UIViewController {
    var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    var items: [DeviceModel] = []
    var tintLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化 tableView
        tableView = UITableView()
        tableView.frame = view.bounds
        tableView.contentInset.top = 20
        tableView.contentInset.bottom = 84
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 125
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        self.view.addSubview(tableView)
        
        // 刷新
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = .gray
        refreshControl.setRefreshControl(title: "Pull down to refresh")
        tableView.refreshControl = refreshControl
        tableView.backgroundColor = Color.grey.lighten5
        
        // 提示 label
        tintLabel = UILabel()
        tintLabel.text = "Oops, no one!"
        tintLabel.textColor = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.00)
        tintLabel.font = UIFont.boldSystemFont(ofSize: 22)
        tintLabel.sizeToFit()
        tintLabel.center = view.center.applying(CGAffineTransform(translationX: 0, y: -60))
//        tintLabel.isHidden = true
        self.view.addSubview(tintLabel)
        
        // 导航栏
        navigationItem.titleLabel.text = "Anyone"
        navigationItem.detailLabel.text = "Is there anyone?"
        let rankButton = IconButton(image: Icon.cm.menu)
        rankButton.addTarget(self, action: #selector(pushRankViewController), for: .touchUpInside)
        navigationItem.rightViews = [rankButton]
        self.refresh()
    }

    func pushRankViewController() {
        let rankVC = UIViewController()
        self.navigationController?.pushViewController(rankVC, animated: true)
    }
}

// MARK: Request
extension ViewController {
    func refresh() {
        refreshControl.setRefreshControl(title: "Refreshing...")
        Alamofire.request("https://halcao.me/getPresent").responseJSON { response in
            self.refreshControl.endRefreshing()
            switch response.result {
            case .success:
                if let data = response.result.value  {
                    if let dict = data as? [String: [[String: String]]],
                        let items = dict["list"] {
                        self.items.removeAll()
                        for item in items {
                            let model = DeviceModel(name: item["name"]!, ip: item["ip"]!, updateAt: item["update_at"]!)
                            self.items.append(model)
                        }
                        // 没有就显示提示
                        if self.items.count == 0 {
                            self.tintLabel.alpha = 1
                        } else {
                            self.tintLabel.alpha = 0
                        }
                        self.tableView.reloadData()
                    }
                }
            case .failure(let error):
                if let data = response.result.value  {
                    if let dict = data as? [String: Any],
                    let message = dict["err_msg"] as? String,
                    let snackVC = self.snackbarController {
                        snackVC.snackbar.text = message + " " + error.localizedDescription
                        snackVC.animate(snackbar: .visible, delay: 2, animations: nil, completion: nil)
                    }
                } else {
                    if let snackVC = self.snackbarController {
                        snackVC.snackbar.text = error.localizedDescription
                        snackVC.animate(snackbar: .visible, delay: 2, animations: nil, completion: nil)
                    }
                }
            }
            // reset
            self.refreshControl.setRefreshControl(title: "Pull down to refresh")
        }
    }
}

// MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let card = Card()
        let item = items[indexPath.row]
        let toolbar = Toolbar(rightViews: [])
        
//        toolbar.title = "Material"
        toolbar.title = item.name
        toolbar.titleLabel.textAlignment = .left
        
//                toolbar.detail = "Build Beautiful Software"
        toolbar.detail = item.ip
        toolbar.detailLabel.textAlignment = .left
        toolbar.detailLabel.textColor = Color.grey.base
        
        let bottomBar = Bar()
        let dateLabel = UILabel()
        dateLabel.font = RobotoFont.regular(with: 12)
        dateLabel.textColor = Color.grey.base
        dateLabel.text = Date().description
        
        bottomBar.leftViews = [dateLabel]
        
        card.toolbar = toolbar
        card.toolbarEdgeInsetsPreset = .square3
        card.toolbarEdgeInsets.bottom = -20
        card.toolbarEdgeInsets.right = 8
        
        card.bottomBar = bottomBar
        card.bottomBarEdgeInsetsPreset = .square3
        
        cell.contentView.backgroundColor = Color.grey.lighten5

        cell.contentView.layout(card).horizontally(left: 20, right: 20).center()
        return cell
    }
}

// MARK: UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: UIRefreshControl
fileprivate extension UIRefreshControl {
    func setRefreshControl(title: String, color: UIColor = .gray) {
        self.attributedTitle = NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: color])
    }
}

