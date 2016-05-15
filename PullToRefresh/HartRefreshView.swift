//
//  HartRefreshView.swift
//  PullToRefresh
//
//  Created by eugene golovanov on 5/15/16.
//  Copyright © 2016 eugene golovanov. All rights reserved.
//

import UIKit
import QuartzCore
import Foundation


//-------------------------------------------------------------------------------------------------------------
//MARK: protocol

protocol HartRefreshViewDelegate {
    func refreshViewDidRefresh(refreshView: HartRefreshView)
}



//-------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------
//MARK: class

class HartRefreshView: UIView, UIScrollViewDelegate {
    
    //-------------------------------------------------------------------------------------------------------------
    //MARK: properties
    
    var delegate: HartRefreshViewDelegate?
    var scrollView: UIScrollView?
    var refreshing: Bool = false
    var progress: CGFloat = 0.0
    
    var isRefreshing = false
    
    let ovalShapeLayer: CAShapeLayer = CAShapeLayer()
    let airplaneLayer: CALayer = CALayer()
    let textLayer = CATextLayer()
    
    
    
    //-------------------------------------------------------------------------------------------------------------
    //MARK: init
    init(frame: CGRect, scrollView: UIScrollView) {
        super.init(frame: frame)
        
        self.scrollView = scrollView
        
        //add the background
        
        self.backgroundColor = UIColor.darkGrayColor()
//        addSubview(UIImageView(image: UIImage(named: "refresh-view-bg")))
        
        
        //OVAL REFRESH
        ovalShapeLayer.strokeColor = UIColor.whiteColor().CGColor
        ovalShapeLayer.fillColor = UIColor.clearColor().CGColor
        ovalShapeLayer.lineWidth = 4.0
        ovalShapeLayer.lineDashPattern = [2, 3]
        let refreshRadius = frame.size.height/2 * 0.8
        ovalShapeLayer.path = UIBezierPath(ovalInRect: CGRect(
            x: frame.size.width/2 - refreshRadius,
            y: frame.size.height/2 - refreshRadius,
            width: 2 * refreshRadius,
            height: 2 * refreshRadius)
            ).CGPath
        
        layer.addSublayer(ovalShapeLayer)

        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    //-------------------------------------------------------------------------------------------------------------
    //MARK: - Stroke
    
    func redrawFromProgress() {
        ovalShapeLayer.strokeEnd = self.progress
        airplaneLayer.opacity = Float(self.progress)
    }


    
    
    //-------------------------------------------------------------------------------------------------------------
    //MARK: Scroll View Delegate methods
    
    func scrollViewDidScroll(scrollView: UIScrollView) {

        let refreshViewVisibleHeight = max(0, -(scrollView.contentOffset.y + scrollView.contentInset.top))
        self.progress = min(max(refreshViewVisibleHeight/frame.size.height, 0.0), 1.0)
        print("progressPercentage = \(self.progress)")
        
        if !isRefreshing {
            redrawFromProgress()
        }


    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if !isRefreshing && self.progress >= 1.0 {
            delegate?.refreshViewDidRefresh(self)
            beginRefreshing()
        }
        
    }
    
    //-------------------------------------------------------------------------------------------------------------
    //MARK: animate the Refresh View
    
    func beginRefreshing() {
        isRefreshing = true
        
        UIView.animateWithDuration(0.3, animations: {
            var newInsets = self.scrollView!.contentInset
            newInsets.top += self.frame.size.height
            self.scrollView!.contentInset = newInsets
        })
        
        
        //Refreshing Animation
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = -0.5
        strokeStartAnimation.toValue   = 1.0
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue = 1.0
        
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 1.5
        strokeAnimationGroup.repeatDuration = 5.0
        strokeAnimationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        
        ovalShapeLayer.addAnimation(strokeAnimationGroup, forKey: nil)

        
    }
    
    func endRefreshing() {
        
        isRefreshing = false
        
        UIView.animateWithDuration(0.3, delay:0.0, options: .CurveEaseOut ,animations: {
            var newInsets = self.scrollView!.contentInset
            newInsets.top -= self.frame.size.height
            self.scrollView!.contentInset = newInsets
            }, completion: {_ in
                //finished
        })
        
        ovalShapeLayer.removeAllAnimations()

    }


}
