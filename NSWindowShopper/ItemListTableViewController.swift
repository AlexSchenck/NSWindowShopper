//
//  ItemListTableViewController.swift
//  NSWindowShopper
//
//  Created by Jacob Alewel on 12/6/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import UIKit

class ItemListTableViewController : UITableViewController, NeedsDataFromSearchResults {
    
    var items : [Item]?
    weak var dataProvder : ItemDataProvider?
    
    // MARK - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false;
        self.view.clipsToBounds = true;
        self.view.backgroundColor = UIColor.clearColor()
        
        self.tableView.separatorColor = UIColor.whiteColor()
        self.tableView.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 0, right: 0)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceOrientationDidChange", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        if (UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
            self.tableView.contentInset.top = 88
        } else if (UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)) {
            self.tableView.contentInset.top = 108
        }
        
        super.viewWillLayoutSubviews()
    }
    
    func deviceOrientationDidChange() {
        if (UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
            self.tableView.contentInset.top = 88
        } else if (UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)) {
            self.tableView.contentInset.top = 108
            
            if(self.tableView.contentOffset.y == -88) {
                self.tableView.contentOffset.y = -108
            }
        }
    }
    
    // MARK - NeedsDataFromSearchResults
    
    func reloadWithData(items: [Item]?) {
        self.items = items;
        self.tableView.reloadData()
    }
    
    // MARK - UITableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.items == nil {
            return 0;
        } else {
            return self.items!.count + 1;
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row < self.items!.count) {
            return 108;
        } else {
            return 88;
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row < self.items!.count) {
            let cell = tableView.dequeueReusableCellWithIdentifier("ItemListTableViewCell") as! ItemListTableViewCell;
            cell.configureWithItem(self.items![indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("LoadMoreTableViewCell");
           return cell!
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if (indexPath.row < self.items!.count) {
            CommandNavigateToItemDetail.executeWithNavigationController(self.navigationController!, andItem: self.items![indexPath.row])
        } else {
            self.dataProvder?.loadNextPage()
        }
    }
    
}