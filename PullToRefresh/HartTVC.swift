//
//  HartTVC.swift
//  PullToRefresh
//
//  Created by eugene golovanov on 5/15/16.
//  Copyright © 2016 eugene golovanov. All rights reserved.
//

import UIKit

let kRefreshViewHeight:CGFloat = 110.0


class HartTVC: UITableViewController, HartRefreshViewDelegate {
    
    var hartRefreshView:HartRefreshView!
    
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshRect = CGRect(x: 0.0, y: -kRefreshViewHeight, width: CGRectGetWidth(self.view.bounds), height: kRefreshViewHeight)
        hartRefreshView = HartRefreshView(frame: refreshRect, scrollView: self.tableView)
        hartRefreshView.delegate = self
        view.addSubview(hartRefreshView)
    }
    
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: - -Scroll View delegate methods-
    
    
    
    //This Function forwarding scrolling of tableView into refreshView
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        hartRefreshView.scrollViewDidScroll(scrollView)
    }
    
    //This Function forwarding end of scrolling of tableView into refreshView
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        hartRefreshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: - -RefreshView delegate method-
    
    func refreshViewDidRefresh(refreshView: HartRefreshView) {
        delayBySeconds(3) {
            self.hartRefreshView.endRefreshing()
        }
    }
    
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: - -Table view data source-
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseHartIdentifier", forIndexPath: indexPath)
        
        // Configure the cell...
        cell.textLabel!.text = "hart cell \(indexPath.row)"
        return cell
    }
    
    
    
}
