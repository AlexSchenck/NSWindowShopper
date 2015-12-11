//
//  ItemCollectionViewController.swift
//  NSWindowShopper
//
//  Created by Jacob Alewel on 12/6/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import UIKit

class ItemCollectionViewController : UICollectionViewController, NeedsDataFromSearchResults {
    
    var items : [Item]?
    weak var dataProvder : ItemDataProvider?
    var numberOfColumns : CGFloat = 2
    
    // MARK - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false;
        
        self.collectionView?.backgroundColor = UIColor.clearColor()
        self.collectionView?.backgroundView?.backgroundColor = UIColor.clearColor()
        self.collectionView?.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 0, right: 0)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        self.collectionView?.setCollectionViewLayout(layout, animated: false)
        
        self.updateNumberOfColumns()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNumberOfColumns", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func updateNumberOfColumns() {
        if (UIDevice.currentDevice().orientation == UIDeviceOrientation.PortraitUpsideDown) {
            return;
        }
        
        let originalNumber = self.numberOfColumns;
        if (UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
            self.numberOfColumns = 3
            self.collectionView?.contentInset.top = 88
        } else if (UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)) {
            self.numberOfColumns = 2
            self.collectionView?.contentInset.top = 108
            
            if(self.collectionView?.contentOffset.y == -88) {
                self.collectionView?.contentOffset.y = -108
            }
        }
        
        if (originalNumber != self.numberOfColumns) {
            self.collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
    
    func reloadWithData(items: [Item]?) {
        self.items = items;
        self.collectionView?.reloadData()
    }
    
    // MARK - UICollectionView
    
    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize {
        
        if (indexPath.item < self.items!.count) {
            let imageSize = collectionView.frame.width/self.numberOfColumns - 7.5
            return CGSizeMake(imageSize, imageSize + 80)
        } else {
            let sizeOffset : CGFloat = 10;
            return CGSizeMake(collectionView.frame.width - sizeOffset, 120)
        }

    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.items == nil) {
            return 0
        }
        return items!.count + 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if (indexPath.item < self.items!.count) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ItemCollectionViewCell", forIndexPath: indexPath) as! ItemCollectionViewCell
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
