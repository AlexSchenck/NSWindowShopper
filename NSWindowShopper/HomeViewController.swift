//
//  HomeViewController.swift
//  NSWindowShopper
//
//  Created by iGuest on 12/1/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController : UIViewController, ItemDataProvider, SearchResultsProxyDelegate {
    
    var itemsToDisplay : [Item]?
    var hasAddedConstraints = false
    var searchResultsProxy : SearchResultsProxy?
    
    var itemListTableViewController : ItemListTableViewController?
    var itemCollectionViewController: ItemCollectionViewController?
    var windowShopperViewController : WindowShopperViewController?
    
    @IBOutlet weak var viewSelector: UISegmentedControl!
    @IBOutlet weak var loadingOverlay: UIVisualEffectView!
    
    // MARK - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad();

        createNavigationButtons();
        createSubViewControllers();
        
        self.searchResultsProxy = SearchResultsProxy(delegate: self)
        loadItems();
    }
    
    func createNavigationButtons() {
        let filterButton = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("handleSearchSettingsNavigation:"))
        self.navigationItem.setRightBarButtonItem(filterButton, animated: false)
        
        let reloadButton = UIBarButtonItem(title: "Reload", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("reloadItems"))
        self.navigationItem.setLeftBarButtonItem(reloadButton, animated: false)
    }
    
    func createSubViewControllers() {
        self.itemListTableViewController = storyboard?.instantiateViewControllerWithIdentifier("ItemListTableViewController") as? ItemListTableViewController
        self.itemListTableViewController!.dataProvder = self;
        
        self.itemCollectionViewController = storyboard?.instantiateViewControllerWithIdentifier("ItemCollectionViewController") as? ItemCollectionViewController
        self.itemCollectionViewController!.dataProvder = self;
        
        self.windowShopperViewController = storyboard?.instantiateViewControllerWithIdentifier("WindowShopperViewController") as? WindowShopperViewController
        
        self.addChildViewController(self.itemListTableViewController!)
        self.addChildViewController(self.itemCollectionViewController!)
        self.itemCollectionViewController!.view.hidden = true
        self.addChildViewController(self.windowShopperViewController!)
        self.windowShopperViewController!.view.hidden = true
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
        let viewDictionary = ["view" : viewController.view]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: NSLayoutFormatOptions.AlignAllTop, metrics: nil, views: viewDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: NSLayoutFormatOptions.AlignAllTop, metrics: nil, views: viewDictionary))
    }
    
    // MARK - Updating UI
    
    func reloadViewControllers() {
        for viewController in self.childViewControllers {
            if (viewController is NeedsDataFromSearchResults) {
                (viewController as! NeedsDataFromSearchResults).reloadWithData(self.itemsToDisplay);
            }
        }
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
        self.startLoadingAnimations()
        
        self.itemsToDisplay = nil;
        self.searchResultsProxy!.loadItems()
    }
    
    func reloadItems() {
        self.startLoadingAnimations()
        
        self.itemsToDisplay = nil;
        self.searchResultsProxy!.reloadItems()
    }
    
    // Mark - ItemDataProvider
    
    func loadNextPage() {
        self.startLoadingAnimations()
        self.searchResultsProxy!.loadNextPage()
    }
    
    // Mark - SearchResultsProxyDelegate
    
    func loadedItems(items : [Item]) {
        self.itemsToDisplay = items
        self.reloadViewControllers()
        self.stopLoadingAnimations()
    }
    
    func failedToLoadItems() {
        self.itemsToDisplay = nil
        self.reloadViewControllers()
        self.stopLoadingAnimations()
    }
    
    // MARK - Animation
    
    func startLoadingAnimations() {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            self.loadingOverlay.alpha = 1
            }, completion: nil)
    }
    
    func stopLoadingAnimations() {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            self.loadingOverlay.alpha = 0
            }, completion: nil)
    }
    
}