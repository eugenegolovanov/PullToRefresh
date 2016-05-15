//
//  RefreshView.swift
//  PullToRefresh
//
//  Created by eugene golovanov on 5/14/16.
//  Copyright © 2016 eugene golovanov. All rights reserved.
//

import UIKit

private let sceneHeight:CGFloat = 200

class RefreshView: UIView {

    
    private unowned var scrollView:UIScrollView
    var progressPercentage:CGFloat = 0
    
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
    }
    
}


extension RefreshView: UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let refreshViewVisibleHeight = max(0, -(scrollView.contentOffset.y + scrollView.contentInset.top))
        
        progressPercentage = min(1.0, refreshViewVisibleHeight/sceneHeight)
        
        print("progressPercentage = \(progressPercentage)")
//        print("refreshViewVisibleHeight = \(refreshViewVisibleHeight)")
    }
    
    
}
