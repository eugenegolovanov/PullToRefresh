//
//  RefreshTVC.swift
//  PullToRefresh
//
//  Created by eugene golovanov on 5/14/16.
//  Copyright © 2016 eugene golovanov. All rights reserved.
//

import UIKit


private let refreshViewHeight:CGFloat = 200


class RefreshTVC: UITableViewController {

    var refreshView:RefreshView!
    
    
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //creating refreshView
        refreshView = RefreshView(frame: CGRect(x: 0, y: -refreshViewHeight, width: CGRectGetWidth(self.view.bounds), height: refreshViewHeight), scrollView: tableView)
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(refreshView, atIndex: 0)
    }

    //-------------------------------------------------------------------------------------------------------------
    // MARK: - scroll View

    
    
    //This Function forwarding scroll of tableView into refreshView
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        refreshView.scrollViewDidScroll(scrollView)
    }
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: - Table view data source

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
