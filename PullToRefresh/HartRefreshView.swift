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
    
    ///'infiniteProgress' does not have 1.0 limit like 'progress' does
    var infiniteProgress: CGFloat = 0.0
    
    var isRefreshing = false
    
    let ovalShapeLayer: CAShapeLayer = CAShapeLayer()
    
    //// Color Declarations
    private let hartBlu = UIColor(red: 0.231, green: 0.741, blue: 0.792, alpha: 1.000)
    private let hartBlueberry = UIColor(red: 0.290, green: 0.584, blue: 1.000, alpha: 1.000)
    
    private let bindPoseEtalonSide:CGFloat = 110

    private let hartLayer = CAShapeLayer()
    private let backgroundHartLayer = CAShapeLayer()

    private var shadowLayer: CAShapeLayer!

    
    //-------------------------------------------------------------------------------------------------------------
    //MARK: init
    init(frame: CGRect, scrollView: UIScrollView) {
        super.init(frame: frame)
        
        self.scrollView = scrollView
        
        //add the background
        
        self.backgroundColor = UIColor.clearColor()
//        addSubview(UIImageView(image: UIImage(named: "refresh-view-bg")))
        
        
//        //OVAL REFRESH
//        ovalShapeLayer.strokeColor = UIColor.whiteColor().CGColor
//        ovalShapeLayer.fillColor = UIColor.clearColor().CGColor
//        ovalShapeLayer.lineWidth = 4.0
//        ovalShapeLayer.lineDashPattern = [2, 3]
//        let refreshRadius = frame.size.height/2 * 0.8
//        ovalShapeLayer.path = UIBezierPath(ovalInRect: CGRect(
//            x: frame.size.width/2 - refreshRadius,
//            y: frame.size.height/2 - refreshRadius,
//            width: 2 * refreshRadius,
//            height: 2 * refreshRadius)
//            ).CGPath
//        
//        layer.addSublayer(ovalShapeLayer)

        let newFrame = CGRectMake(0, 0, self.bounds.width/2, self.bounds.height/2)
        self.drawCanvas(frame: newFrame)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    //-------------------------------------------------------------------------------------------------------------
    //MARK: - Stroke
    
    func redrawFromProgress() {
        hartLayer.strokeEnd = self.progress
        
        

        //Move Heart against scroll
//        if infiniteProgress > 0.5 {
//            hartLayer.position.y = (-(CGRectGetHeight(bounds) * infiniteProgress)) + CGRectGetHeight(bounds)/2
//        } else {
//            hartLayer.position.y = 0
//        }
        
        
        if progress == 1 {
            hartLayer.fillColor = hartBlu.CGColor
        } else {
            hartLayer.fillColor = UIColor.clearColor().CGColor
        }
    

    }


    
    private func drawCanvas(var frame frame: CGRect) {
        
        print("FRAME:\(frame)")
        
        
        
        let width:CGFloat = frame.size.width
        let height:CGFloat = frame.size.height
        let minimumSide:CGFloat = min(width, height)
        let scale = minimumSide/bindPoseEtalonSide
        
        //Works
        frame = CGRectMake(frame.origin.x - bindPoseEtalonSide + CGRectGetWidth(bounds),
                           frame.origin.y + bindPoseEtalonSide/2,
                           frame.size.width,
                           frame.size.height)
        
//        frame = CGRectMake(frame.origin.x - bindPoseEtalonSide + CGRectGetWidth(bounds),
//                           frame.origin.y + bindPoseEtalonSide*1.5,
//                           frame.size.width,
//                           frame.size.height)



        //// Hart Drawing
        let hartPath = UIBezierPath()
//        hartPath.moveToPoint(CGPointMake(scale * (frame.minX + 66.14), scale * (frame.minY + 79.1)))
//        hartPath.addCurveToPoint(CGPointMake(scale * (frame.minX + 107.86), scale * (frame.minY + 79.1)), controlPoint1: CGPointMake(scale * (frame.minX + 76.57), scale * (frame.minY + 69.02)), controlPoint2: CGPointMake(scale * (frame.minX + 97.09), scale * (frame.minY + 68.69)))
//        hartPath.addCurveToPoint(CGPointMake(scale * (frame.minX + 109.5), scale * (frame.minY + 80.82)), controlPoint1: CGPointMake(scale * (frame.minX + 108.44), scale * (frame.minY + 79.65)), controlPoint2: CGPointMake(scale * (frame.minX + 108.98), scale * (frame.minY + 80.23)))
//        hartPath.addCurveToPoint(CGPointMake(scale * (frame.minX + 111.14), scale * (frame.minY + 79.1)), controlPoint1: CGPointMake(scale * (frame.minX + 110.02), scale * (frame.minY + 80.23)), controlPoint2: CGPointMake(scale * (frame.minX + 110.56), scale * (frame.minY + 79.65)))
//        hartPath.addCurveToPoint(CGPointMake(scale * (frame.minX + 124.94), scale * (frame.minY + 71.57)), controlPoint1: CGPointMake(scale * (frame.minX + 115.09), scale * (frame.minY + 75.28)), controlPoint2: CGPointMake(scale * (frame.minX + 119.89), scale * (frame.minY + 72.77)))
//        hartPath.addCurveToPoint(CGPointMake(scale * (frame.minX + 152.86), scale * (frame.minY + 79.1)), controlPoint1: CGPointMake(scale * (frame.minX + 134.63), scale * (frame.minY + 69.28)), controlPoint2: CGPointMake(scale * (frame.minX + 145.29), scale * (frame.minY + 71.79)))
//        hartPath.addCurveToPoint(CGPointMake(scale * (frame.minX + 152.86), scale * (frame.minY + 119.4)), controlPoint1: CGPointMake(scale * (frame.minX + 164.38), scale * (frame.minY + 90.23)), controlPoint2: CGPointMake(scale * (frame.minX + 164.38), scale * (frame.minY + 108.27)))
//        hartPath.addCurveToPoint(CGPointMake(scale * (frame.minX + 110), scale * (frame.minY + 149.25)), controlPoint1: CGPointMake(scale * (frame.minX + 152.74), scale * (frame.minY + 119.52)), controlPoint2: CGPointMake(scale * (frame.minX + 127.06), scale * (frame.minY + 149.25)))
//        hartPath.addCurveToPoint(CGPointMake(scale * (frame.minX + 66.14), scale * (frame.minY + 119.4)), controlPoint1: CGPointMake(scale * (frame.minX + 93), scale * (frame.minY + 149.25)), controlPoint2: CGPointMake(scale * (frame.minX + 66.26), scale * (frame.minY + 119.52)))
//        hartPath.addCurveToPoint(CGPointMake(scale * (frame.minX + 66.14), scale * (frame.minY + 79.1)), controlPoint1: CGPointMake(scale * (frame.minX + 54.62), scale * (frame.minY + 108.27)), controlPoint2: CGPointMake(scale * (frame.minX + 55.71), scale * (frame.minY + 89.17)))
    
        
        
        hartPath.moveToPoint(CGPointMake(scale * (frame.minX + 110), scale * (frame.minY + 149.25)))
        hartPath.addCurveToPoint(CGPointMake(scale * (frame.minX + 66.14), scale * (frame.minY + 119.4)), controlPoint1: CGPointMake(scale * (frame.minX + 93), scale * (frame.minY + 149.25)), controlPoint2: CGPointMake(scale * (frame.minX + 66.26), scale * (frame.minY + 119.52)))
        hartPath.addCurveToPoint(CGPointMake(scale * (frame.minX + 66.14), scale * (frame.minY + 79.1)), controlPoint1: CGPointMake(scale * (frame.minX + 54.62), scale * (frame.minY + 108.27)), controlPoint2: CGPointMake(scale * (frame.minX + 55.71), scale * (frame.minY + 89.17)))
        hartPath.addCurveToPoint(CGPointMake(scale * (frame.minX + 107.86), scale * (frame.minY + 79.1)), controlPoint1: CGPointMake(scale * (frame.minX + 76.57), scale * (frame.minY + 69.02)), controlPoint2: CGPointMake(scale * (frame.minX + 97.09), scale * (frame.minY + 68.69)))
        hartPath.addCurveToPoint(CGPointMake(scale * (frame.minX + 109.5), scale * (frame.minY + 80.82)), controlPoint1: CGPointMake(scale * (frame.minX + 108.44), scale * (frame.minY + 79.65)), controlPoint2: CGPointMake(scale * (frame.minX + 108.98), scale * (frame.minY + 80.23)))
        hartPath.addCurveToPoint(CGPointMake(scale * (frame.minX + 111.14), scale * (frame.minY + 79.1)), controlPoint1: CGPointMake(scale * (frame.minX + 110.02), scale * (frame.minY + 80.23)), controlPoint2: CGPointMake(scale * (frame.minX + 110.56), scale * (frame.minY + 79.65)))
        hartPath.addCurveToPoint(CGPointMake(scale * (frame.minX + 124.94), scale * (frame.minY + 71.57)), controlPoint1: CGPointMake(scale * (frame.minX + 115.09), scale * (frame.minY + 75.28)), controlPoint2: CGPointMake(scale * (frame.minX + 119.89), scale * (frame.minY + 72.77)))
        hartPath.addCurveToPoint(CGPointMake(scale * (frame.minX + 152.86), scale * (frame.minY + 79.1)), controlPoint1: CGPointMake(scale * (frame.minX + 134.63), scale * (frame.minY + 69.28)), controlPoint2: CGPointMake(scale * (frame.minX + 145.29), scale * (frame.minY + 71.79)))
        hartPath.addCurveToPoint(CGPointMake(scale * (frame.minX + 152.86), scale * (frame.minY + 119.4)), controlPoint1: CGPointMake(scale * (frame.minX + 164.38), scale * (frame.minY + 90.23)), controlPoint2: CGPointMake(scale * (frame.minX + 164.38), scale * (frame.minY + 108.27)))
        hartPath.addCurveToPoint(CGPointMake(scale * (frame.minX + 110), scale * (frame.minY + 149.25)), controlPoint1: CGPointMake(scale * (frame.minX + 152.74), scale * (frame.minY + 119.52)), controlPoint2: CGPointMake(scale * (frame.minX + 127.06), scale * (frame.minY + 149.25)))

        
        hartPath.closePath()
        hartBlu.setFill()
        hartPath.fill()
        
        
        
        let center = CGPoint(x: 0, y: 0)
//        let center = CGPoint(x: 0, y: -bindPoseEtalonSide)

        
        
        self.hartLayer.path = hartPath.CGPath
        self.hartLayer.lineCap = kCALineCapRound
        self.hartLayer.opacity = 1.0
        self.hartLayer.position = center
        hartLayer.lineWidth = 2
        
        hartLayer.strokeColor = UIColor(red: 0.231, green: 0.741, blue: 0.792, alpha: 1.000).CGColor
        hartLayer.fillColor = UIColor.clearColor().CGColor
        
        hartLayer.lineDashPattern = [1, 3]// [dashLength, dashSpacing]
        
        layer.addSublayer(hartLayer)

        
        
        
        
        //SHADOW
        layer.shadowColor = UIColor.lightGrayColor().CGColor
        layer.shadowRadius = 3
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSizeMake(0, 0)
//        let margin:CGFloat = 10
//        if shadowLayer == nil {
//            let radiusRect = CGRectMake(margin/2,
//                                        margin/2,
//                                        self.bounds.width - margin,
//                                        self.bounds.height - margin)
//            shadowLayer = CAShapeLayer()
//            shadowLayer.path = UIBezierPath(roundedRect: radiusRect, cornerRadius: CGRectGetHeight(self.bounds) / 2.0).CGPath
//            shadowLayer.fillColor = UIColor.whiteColor().CGColor
//            shadowLayer.masksToBounds = false
//            layer.insertSublayer(shadowLayer, atIndex: 0)
//        }

        
        
    }

    
    //-------------------------------------------------------------------------------------------------------------
    //MARK: Scroll View Delegate methods
    
    func scrollViewDidScroll(scrollView: UIScrollView) {

        let refreshViewVisibleHeight = max(0, -(scrollView.contentOffset.y + scrollView.contentInset.top))
        self.progress = min(max(refreshViewVisibleHeight/frame.size.height, 0.0), 1.0)
        
        self.infiniteProgress = max(refreshViewVisibleHeight/frame.size.height, 0.0)
        print("progress = \(self.progress)")
        print("infiniteProgress = \(self.infiniteProgress)")

        
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
//            newInsets.top += self.frame.size.height
            newInsets.top += self.frame.size.height/2

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
        
        hartLayer.addAnimation(strokeAnimationGroup, forKey: nil)
        hartLayer.fillColor = UIColor.clearColor().CGColor
        hartLayer.position = CGPoint(x: 0, y: 0)
        hartLayer.lineDashPattern = [10, 0]// [dashLength, dashSpacing]

    }
    
    func endRefreshing() {
        
        isRefreshing = false
        
        UIView.animateWithDuration(0.3, delay:0.0, options: .CurveEaseOut ,animations: {
            var newInsets = self.scrollView!.contentInset
//            newInsets.top -= self.frame.size.height
            newInsets.top -= self.frame.size.height/2

            self.scrollView!.contentInset = newInsets
            }, completion: {_ in
                //finished
        })
        hartLayer.lineDashPattern = [1, 3]// [dashLength, dashSpacing]
        hartLayer.position = CGPoint(x: 0, y: 0)
        hartLayer.removeAllAnimations()

    }


}
