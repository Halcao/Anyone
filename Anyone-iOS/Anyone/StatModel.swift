//
//  StatModel.swift
//  Anyone
//
//  Created by Halcao on 2017/12/20.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

struct StatModel {
    var name: String
    var weekTime: String
    var totalTime: String
    var updateTime: String
    init(name: String, weekTime: Int, totalTime: Int, updateTime: String) {
        self.name = name
        let formatter: (Int) -> (String) = { minute in
            let m = minute % 60
            let h = minute / 60
            return "\(h)h \(m)m"
        }
        self.totalTime = formatter(totalTime)
        self.weekTime = formatter(weekTime)
        self.updateTime = updateTime
    }
}

