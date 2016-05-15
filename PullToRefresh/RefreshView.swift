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


    }
    
    
    func updateRefreshItemsPositions() {
        for item in self.refreshItems {
            item.updateViewPositionForPercentage(self.progressPercentage)
        }
        
    }
    
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: - Refresh Methods

    func beginRefresh() {
        self.isRefreshing = true
        
        UIView.animateKeyframesWithDuration(0.4, delay: 0, options: [], animations: {
            self.scrollView.contentInset.top += sceneHeight
            }) { (_) -> Void in
                
        }
    }
    
    func endRefresh() {
        
        UIView.animateKeyframesWithDuration(0.4, delay: 0, options: [], animations: {
            self.scrollView.contentInset.top -= sceneHeight
        }) { (_) -> Void in
            self.isRefreshing = false
        }
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
        
    }
    
    
}
