//
//  ItemCollectionViewCell.swift
//  NSWindowShopper
//
//  Created by Jacob Alewel on 12/8/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import UIKit

class ItemCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var mostRecentlyLoadedImageURL : String?
    var hasConfiguredStaticUI : Bool = false
    
    // UI Configuration
    
    func configureWithItem(item : Item) {
        self.firstTimeUISetupIfNeeded()
        
        self.loadItemImage(item.imageURL!)
        self.titleLabel.text = item.name;
        self.priceLabel.text = item.formattedPriceText()
    }
    
    private func firstTimeUISetupIfNeeded() {
        if (!hasConfiguredStaticUI) {
            self.contentView.layer.cornerRadius = 3.0;
            self.contentView.layer.borderColor = ColorProvider.whiteColor.CGColor
            self.contentView.layer.borderWidth = 2
            self.contentView.clipsToBounds = true;
            
            self.itemImageView.clipsToBounds = true;
            
            self.itemImageView.contentMode = UIViewContentMode.ScaleAspectFill
            hasConfiguredStaticUI = true
        }
    }
    
    private func loadItemImage(imageURL : String) {
        self.mostRecentlyLoadedImageURL = imageURL
        
        weak var weakSelf = self;
        ImageLoader.loadImageAtURL(imageURL) { (loadedImage, loadedImageURL) -> Void in
            if (weakSelf != nil && weakSelf!.mostRecentlyLoadedImageURL == loadedImageURL) {
                weakSelf!.itemImageView.image = loadedImage
            }
        }
    }
    
    // MARK - Cell Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.itemImageView.image = nil;
    }
    
}