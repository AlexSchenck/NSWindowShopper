//
//  WindowShopperViewController.swift
//  NSWindowShopper
//
//  Created by Jacob Alewel on 12/6/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import UIKit

class WindowShopperViewController : UICollectionViewController, NeedsDataFromSearchResults {
    
    var items : [Item]?
    weak var dataProvder : ItemDataProvider?
    
    private let padding : CGFloat = 10.0
    
    // MARK - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false;
        
        self.collectionView?.backgroundColor = UIColor.clearColor()
        self.collectionView?.backgroundView?.backgroundColor = UIColor.clearColor()
        self.collectionView?.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 0, right: 0)
        self.collectionView?.pagingEnabled = true
        if let scrollView = self.collectionView as UIScrollView? {
            scrollView.indicatorStyle = UIScrollViewIndicatorStyle.White
        }
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.sectionInset = UIEdgeInsets(top: self.padding, left: self.padding, bottom: self.padding, right: self.padding)
        layout.minimumLineSpacing = self.padding * 2
        self.collectionView?.setCollectionViewLayout(layout, animated: false)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceOrientationDidChange", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillLayoutSubviews() {
        if (UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
            self.collectionView?.contentInset.top = 88
        } else if (UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)) {
            self.collectionView?.contentInset.top = 108
        }
        
        super.viewWillLayoutSubviews()
    }
    
    func deviceOrientationDidChange() {
        if (UIDevice.currentDevice().orientation == UIDeviceOrientation.PortraitUpsideDown) {
            return;
        }
        
        if (UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
            self.collectionView?.contentInset.top = 88
        } else if (UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)) {
            self.collectionView?.contentInset.top = 108
            
            if(self.collectionView?.contentOffset.y == -88) {
                self.collectionView?.contentOffset.y = -108
            }
        }
        
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }

    func reloadWithData(items: [Item]?) {
        self.items = items;
        self.collectionView?.reloadData()
    }
    
    // MARK - UICollectionView
    
    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.width - self.padding * 2, collectionView.frame.height - collectionView.contentInset.top - self.padding * 2)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.items == nil) {
            return 0
        }
        return items!.count + 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if (indexPath.item < self.items!.count) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WindowShopperViewCell", forIndexPath: indexPath) as! WindowShopperViewCell
            cell.configureWithItem(self.items![indexPath.item])
            cell.contentView.backgroundColor = ColorProvider.colorForItemPosition(indexPath.item)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("LoadMoreCollectionViewCell", forIndexPath: indexPath)
            cell.layer.cornerRadius = 3.0
            cell.clipsToBounds = true
            return cell;
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        if (indexPath.row < self.items!.count) {
            CommandNavigateToItemDetail.executeWithNavigationController(self.navigationController!, withItem: self.items![indexPath.row], andColor: ColorProvider.colorForItemPosition(indexPath.item))
        } else {
            self.dataProvder?.loadNextPage()
        }
    }

    
}
