//
//  RankViewController.swift
//  Anyone
//
//  Created by Halcao on 2017/12/20.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import Material
import Alamofire

class RankViewController: UIViewController {
    var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    var items: [StatModel] = []
    var tintLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化 tableView
        tableView = UITableView()
        tableView.frame = view.bounds
        tableView.contentInset.top = 44
        tableView.contentInset.bottom = 84
//        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 150
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
        tintLabel.text = "No Data!"
        tintLabel.textColor = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.00)
        tintLabel.font = UIFont.boldSystemFont(ofSize: 22)
        tintLabel.sizeToFit()
        tintLabel.center = view.center.applying(CGAffineTransform(translationX: 0, y: -60))
        self.view.addSubview(tintLabel)
        
        // 导航栏
        navigationItem.titleLabel.text = "Rank"

        self.refreshControl.beginRefreshing()
        self.refresh()
    }
    
}

// MARK: Request
extension RankViewController {
    func refresh() {
        refreshControl.setRefreshControl(title: "Refreshing...")
        Alamofire.request("https://halcao.me/getRank").responseJSON { response in
            self.refreshControl.endRefreshing()
            switch response.result {
            case .success:
                if let data = response.result.value  {
                    if let dict = data as? [String: [[String: Any]]],
                        let items = dict["list"] {
                        self.items.removeAll()
                        let sortedItems = items.sorted(by: { a, b in
                            return (a["total_time"]! as! Int) > (b["total_time"]! as! Int)
                        })
                        for item in sortedItems {
                            let model = StatModel(name: item["name"]! as! String, weekTime: item["week_time"]! as! Int, totalTime: item["total_time"]!as! Int, updateTime: item["update_at"]! as! String)
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
extension RankViewController: UITableViewDataSource {
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
        
        toolbar.title = item.name
        toolbar.titleLabel.textAlignment = .left
        
        let contentView = UILabel()
        contentView.numberOfLines = 0
        contentView.text = "week: \(item.weekTime)\ntotal: \(item.totalTime)"
        contentView.font = RobotoFont.regular(with: 14)
        contentView.sizeToFit()
        
        let bottomBar = Bar()
        let dateLabel = UILabel()
        dateLabel.font = RobotoFont.regular(with: 12)
        dateLabel.textColor = Color.grey.base
        dateLabel.text = item.updateTime
        
        bottomBar.leftViews = [dateLabel]
        
        card.toolbar = toolbar
        card.toolbarEdgeInsetsPreset = .square3
        card.toolbarEdgeInsets.bottom = 0
        card.toolbarEdgeInsets.right = 8
        
        card.contentView = contentView
        card.contentViewEdgeInsetsPreset = .wideRectangle1
        card.contentViewEdgeInsets.left = 25

        card.bottomBar = bottomBar
        card.bottomBarEdgeInsetsPreset = .wideRectangle1
//        card.bottomBarEdgeInsets.top = -10
        card.bottomBarEdgeInsets.left = 20

        cell.contentView.backgroundColor = Color.grey.lighten5
        
//        cell.contentView.layout(card).horizontally(left: 20, right: 20).center()
        cell.contentView.layout(card).horizontally(left: 0, right: 0).center()
        return cell
    }
}
