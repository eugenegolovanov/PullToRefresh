//
//  RefreshView.swift
//  PullToRefresh
//
//  Created by eugene golovanov on 5/14/16.
//  Copyright © 2016 eugene golovanov. All rights reserved.
//

import UIKit

protocol RefreshViewDelegate: class {
    func refreshViewDidRefresh(refreshView:RefreshView)
}



private let sceneHeight:CGFloat = 150

class RefreshView: UIView {
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: - properties
    
    private unowned var scrollView:UIScrollView
    var progressPercentage:CGFloat = 0
    
    var refreshItems = [RefreshItem]()
    
    
    weak var delegate: RefreshViewDelegate?
    var isRefreshing = false
    
    var signRefreshItem: RefreshItem!
    var isSignVisible = false

    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: - init

    required init?(coder aDecoder: NSCoder) {
        //creating fake view
        scrollView = UIScrollView()
        assert(false, "use init(frame:scrollView:)")
        super.init(coder: aDecoder)
    }
    
    
    init(frame: CGRect, scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init(frame: frame)
        backgroundColor = UIColor.redColor()
        
        setupRefreshItems()
    }
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: - Building RefreshItems
    
    func setupRefreshItems() {
        let buildingsImageView = UIImageView(image: UIImage(named: "buildings"))
        let groundImageView = UIImageView(image: UIImage(named: "ground"))
        let sunImageView = UIImageView(image: UIImage(named: "sun"))
        let catImageView = UIImageView(image: UIImage(named: "cat"))
        let capeBack = UIImageView(image: UIImage(named: "cape_back"))
        let capeFront = UIImageView(image: UIImage(named: "cape_front"))

        

        
        let buildingsItem = RefreshItem(
            view: buildingsImageView,
            centerEnd: CGPointMake(CGRectGetMidX(bounds), CGRectGetHeight(bounds) - CGRectGetHeight(groundImageView.bounds) - CGRectGetHeight(buildingsImageView.bounds)/2),
            parallaxRatio: 1.5,
            sceneHeight: sceneHeight)
        
        let groundItem = RefreshItem(
            view: groundImageView,
            centerEnd: CGPointMake(CGRectGetMidX(bounds), CGRectGetHeight(bounds) - CGRectGetHeight(groundImageView.bounds)/2),
            parallaxRatio: 0.5,
            sceneHeight: sceneHeight)
        
        let sunItem = RefreshItem(
            view: sunImageView,
            centerEnd: CGPointMake(CGRectGetWidth(bounds) * 0.1, CGRectGetHeight(bounds) - CGRectGetHeight(buildingsImageView.bounds) - CGRectGetHeight(sunImageView.bounds)),
            parallaxRatio: 3.0,
            sceneHeight: sceneHeight)

        let catItem = RefreshItem(
            view: catImageView,
            centerEnd: CGPointMake(CGRectGetMidX(bounds), CGRectGetHeight(bounds) - CGRectGetHeight(catImageView.bounds)/2 - CGRectGetHeight(groundImageView.bounds)/2),
            parallaxRatio: 1,
            sceneHeight: sceneHeight)

        let capeBackItem = RefreshItem(
            view: capeBack,
            centerEnd: CGPointMake(CGRectGetMidX(bounds), CGRectGetHeight(bounds) - CGRectGetHeight(catImageView.bounds)/2 - CGRectGetHeight(groundImageView.bounds)/2),
            parallaxRatio: -3,
            sceneHeight: sceneHeight)
        
        let capeFrontItem = RefreshItem(
            view: capeFront,
            centerEnd: CGPointMake(CGRectGetMidX(bounds), CGRectGetHeight(bounds) - CGRectGetHeight(catImageView.bounds)/2 - CGRectGetHeight(groundImageView.bounds)/2),
            parallaxRatio: -3,
            sceneHeight: sceneHeight)


        
        
        refreshItems = [buildingsItem, sunItem, groundItem, capeBackItem, catItem, capeFrontItem]
        
        
        
        for refreshItem in refreshItems {
            addSubview(refreshItem.view)
        }
        
        
        let signImageView = UIImageView(image: UIImage(named: "sign"))
        signRefreshItem = RefreshItem(view: signImageView, centerEnd: CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetHeight(bounds) - CGRectGetHeight(signImageView.bounds)/2), parallaxRatio: 0.5, sceneHeight: sceneHeight)
        addSubview(signImageView)



    }
    
    
    func updateRefreshItemsPositions() {
        for item in self.refreshItems {
            item.updateViewPositionForPercentage(self.progressPercentage)
        }
        
    }
    
    
    
    func showSign(show: Bool) {
        if isSignVisible == show {
            return
        }
        
        isSignVisible = show
        
        UIView.animateWithDuration(0.2, delay: 0, options: [.CurveEaseInOut, .BeginFromCurrentState], animations: { () -> Void in
            self.signRefreshItem.updateViewPositionForPercentage(show ? 1 : 0)
            }, completion: nil)
    }

    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: - Refresh Methods

    func beginRefresh() {
        self.isRefreshing = true
        
        UIView.animateKeyframesWithDuration(0.4, delay: 0, options: [], animations: {
            self.scrollView.contentInset.top += sceneHeight
            }) { (_) -> Void in
                
        }
        
        showSign(false)
        
        // Animate cat and cape
        let cape = refreshItems[3].view
        let cat = refreshItems[4].view
        cape.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/32))
        cat.transform = CGAffineTransformMakeTranslation(1.0, 0)
        UIView.animateWithDuration(0.2, delay: 0, options: [.Repeat, .Autoreverse], animations: { () -> Void in
            cape.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/32))
            cat.transform = CGAffineTransformMakeTranslation(-1.0, 0)
            }, completion: nil)
        
        // Animate ground and buildings
        let buildings = refreshItems[0].view
        let ground = refreshItems[2].view
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            ground.center.y += sceneHeight
            buildings.center.y += sceneHeight
            }, completion: nil)


    }
    
    func endRefresh() {
        
        UIView.animateKeyframesWithDuration(0.4, delay: 0, options: [], animations: {
            self.scrollView.contentInset.top -= sceneHeight
        }) { (_) -> Void in
            self.isRefreshing = false
        }
        
        //Remove All Animations
        let cape = refreshItems[3].view
        let cat = refreshItems[4].view
        cape.transform = CGAffineTransformIdentity
        cat.transform = CGAffineTransformIdentity
        cape.layer.removeAllAnimations()
        cat.layer.removeAllAnimations()

    }

    
    
    
    
    
}

//-------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------
// MARK: - extension for refreshing
extension RefreshView {
    
    //when user scrolls and let go
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if !isRefreshing && progressPercentage == 1 {
            self.beginRefresh()
            targetContentOffset.memory.y = -scrollView.contentInset.top
            delegate?.refreshViewDidRefresh(self)
        }
    }
}

//-------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------
// MARK: - extension for scrolling

extension RefreshView {
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //IF we refreshing do not scroll
        if self.isRefreshing {
            return
        }
        
        
        let refreshViewVisibleHeight = max(0, -(scrollView.contentOffset.y + scrollView.contentInset.top))
        
        progressPercentage = min(1.0, refreshViewVisibleHeight/sceneHeight)
        
        print("progressPercentage = \(progressPercentage)")
//        print("refreshViewVisibleHeight = \(refreshViewVisibleHeight)")
        
        self.updateRefreshItemsPositions()
        if progressPercentage == 1 {
            showSign(true)
        } else {
            showSign(false)
        }
//        showSign(progressPercentage == 1)
    }
    
    
}
