//
//  RefreshTVC.swift
//  PullToRefresh
//
//  Created by eugene golovanov on 5/14/16.
//  Copyright © 2016 eugene golovanov. All rights reserved.
//

import UIKit


private let refreshViewHeight:CGFloat = 200

func delayBySeconds(seconds: Double, delayedCode: ()->()) {
    let targetTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * seconds))
    dispatch_after(targetTime, dispatch_get_main_queue()) {
        delayedCode()
    }
}


class RefreshTVC: UITableViewController, RefreshViewDelegate {

    var refreshView:RefreshView!
    
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //creating refreshView
        refreshView = RefreshView(frame: CGRect(x: 0, y: -refreshViewHeight, width: CGRectGetWidth(self.view.bounds), height: refreshViewHeight), scrollView: tableView)
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        refreshView.delegate = self
        view.insertSubview(refreshView, atIndex: 0)
    }

    //-------------------------------------------------------------------------------------------------------------
    // MARK: - -Scroll View delegate methods-

    
    
    //This Function forwarding scrolling of tableView into refreshView
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        refreshView.scrollViewDidScroll(scrollView)
    }
    
    //This Function forwarding end of scrolling of tableView into refreshView
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        refreshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: - -RefreshView delegate method-
    
    func refreshViewDidRefresh(refreshView: RefreshView) {
        delayBySeconds(3) { 
            self.refreshView.endRefresh()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel!.text = "cell\(indexPath.row)"
        return cell
    }
 


}
