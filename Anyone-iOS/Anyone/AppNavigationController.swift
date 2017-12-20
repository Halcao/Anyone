//
//  AppNavigationController.swift
//  Anyone
//
//  Created by Halcao on 2017/12/20.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import Material

class AppNavigationController: NavigationController {
    open override func prepare() {
        super.prepare()
        
        guard let v = navigationBar as? NavigationBar else {
            return
        }
        
        v.depthPreset = .none
        v.dividerColor = Color.grey.lighten2
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}
