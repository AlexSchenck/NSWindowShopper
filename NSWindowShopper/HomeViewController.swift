//
//  HomeViewController.swift
//  NSWindowShopper
//
//  Created by iGuest on 12/1/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController : UIViewController {
    
    var itemsToDisplay : [Item]?
    
    override func viewDidLoad() {
        super.viewDidLoad();

        loadItems();
    }
    
    // MARK - IBAction

    @IBAction func handleItemDetailNavigation(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "ItemDetailViewController", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ItemDetailViewController") as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func handleSearchSettingsNavigation(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "SearchSettingsViewController", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("SearchSettingsViewController") as UIViewController
        let navController = UINavigationController(rootViewController: vc);
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    // MARK - Network Interactions
    
    func loadItems() {
        weak var weakSelf = self;
        SearchResultsProxy().loadDefaultItemsWithCompletionHandler { (items) -> Void in
            if (weakSelf != nil && items != nil) {
                weakSelf!.itemsToDisplay = items;
                weakSelf!.reloadCurrentViewController();
            }
        }
    }
    
    func reloadCurrentViewController() {
        
    }
}