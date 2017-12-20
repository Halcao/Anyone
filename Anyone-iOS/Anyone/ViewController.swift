//
//  ViewController.swift
//  Anyone
//
//  Created by Halcao on 2017/12/19.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var cardTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        cardTableView = UITableView()
        cardTableView.frame = view.frame
        
        cardTableView.delegate = self
        cardTableView.dataSource = self
        cardTableView.estimatedRowHeight = 200
        cardTableView.rowHeight = UITableViewAutomaticDimension
        cardTableView.separatorStyle = .none
        cardTableView.allowsSelection = false
        self.view.addSubview(cardTableView)
    }

}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let card = CardView()
        cell.contentView.addSubview(card)
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
