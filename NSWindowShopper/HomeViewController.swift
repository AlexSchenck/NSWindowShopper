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
    var hasAddedConstraints = false
    
    var itemListTableViewController : ItemListTableViewController?
    var itemCollectionViewController: ItemCollectionViewController?
    var windowShopperViewController : WindowShopperViewController?
    
    @IBOutlet weak var viewSelector: UISegmentedControl!
    
    // MARK - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad();

        createNavigationButtons();
        createSubViewControllers();
        loadItems();
    }
    
    func createNavigationButtons() {
        let filterButton = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleSearchSettingsNavigation:"))
        self.navigationItem.setRightBarButtonItem(filterButton, animated: false)
        
        let reloadButton = UIBarButtonItem(title: "Reload", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("loadItems"))
        self.navigationItem.setLeftBarButtonItem(reloadButton, animated: false)
    }
    
    func createSubViewControllers() {
        self.itemListTableViewController = storyboard?.instantiateViewControllerWithIdentifier("ItemListTableViewController") as? ItemListTableViewController
        
        self.itemCollectionViewController = storyboard?.instantiateViewControllerWithIdentifier("ItemCollectionViewController") as? ItemCollectionViewController
        
        self.windowShopperViewController = storyboard?.instantiateViewControllerWithIdentifier("WindowShopperViewController") as? WindowShopperViewController
        
        self.addChildViewController(self.itemListTableViewController!)
        self.addChildViewController(self.itemCollectionViewController!)
        self.addChildViewController(self.windowShopperViewController!)
    }
    
    override func addChildViewController(childController: UIViewController) {
        super.addChildViewController(childController)
        
        self.view.addSubview(childController.view)
        self.view.sendSubviewToBack(childController.view)
    }
    
    override func updateViewConstraints() {
        if (self.hasAddedConstraints == false) {
            self.addConstraintsToViewController(self.itemListTableViewController!);
            self.addConstraintsToViewController(self.itemCollectionViewController!);
            self.addConstraintsToViewController(self.windowShopperViewController!);
            
            self.hasAddedConstraints = true;
        }
        super.updateViewConstraints()
    }
    
    func addConstraintsToViewController(viewController : UIViewController) {
        let metricsDictionary = ["heightOffset" : 110]
        let viewDictionary = ["view" : viewController.view]
        
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: NSLayoutFormatOptions.AlignAllTop, metrics: nil, views: viewDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(heightOffset)-[view]|", options: NSLayoutFormatOptions.AlignAllTop, metrics: metricsDictionary, views: viewDictionary))
    }
    
    // MARK - IBAction

    @IBAction func segmentedControlChangedValue(sender: UISegmentedControl) {
        for var index = 0; index < self.childViewControllers.count; index++ {
           self.childViewControllers[index].view.hidden = index != sender.selectedSegmentIndex
        }
    }
    
    func handleSearchSettingsNavigation(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "SearchSettingsViewController", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("SearchSettingsViewController") as! SearchSettingsViewController
        let navController = UINavigationController(rootViewController: vc);
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    // MARK - Network Interactions
    
    func loadItems() {
        self.itemsToDisplay = nil;
        self.reloadCurrentViewController()
        
        weak var weakSelf = self;
        SearchResultsProxy().loadDefaultItemsWithCompletionHandler { (items) -> Void in
            if (weakSelf != nil && items != nil) {
                weakSelf!.itemsToDisplay = items;
                weakSelf!.reloadCurrentViewController();
            }
        }
    }
    
    func reloadCurrentViewController() {
        for viewController in self.childViewControllers {
            if (viewController is NeedsDataFromSearchResults) {
                (viewController as! NeedsDataFromSearchResults).reloadWithData(self.itemsToDisplay);
            }
        }
    }
}