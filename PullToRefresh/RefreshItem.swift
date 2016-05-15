//
//  RefreshItem.swift
//  PullToRefresh
//
//  Created by eugene golovanov on 5/14/16.
//  Copyright © 2016 eugene golovanov. All rights reserved.
//

import UIKit

class RefreshItem {
    private var centerStart:CGPoint
    private var centerEnd:CGPoint
    unowned var view:UIView
    
    
    init(view:UIView, centerEnd:CGPoint, parallaxRatio:CGFloat, sceneHeight:CGFloat) {
        self.view = view
        self.centerEnd = centerEnd
        self.centerStart = CGPoint(x: centerEnd.x, y: centerEnd.x + (parallaxRatio * sceneHeight))
        self.view.center = centerStart
    }
    
    func updateViewPositionForPercentage(percentage:CGFloat) {
        let x = centerStart.x + (centerEnd.x - centerStart.x) * percentage
        let y = centerStart.y + (centerEnd.y - centerStart.y) * percentage
        print("X:\(x) Y:\(y)")
        view.center = CGPoint(
            x: centerStart.x + (centerEnd.x - centerStart.x) * percentage,
            y: centerStart.y + (centerEnd.y - centerStart.y) * percentage)

    }
    
    
    
    
}