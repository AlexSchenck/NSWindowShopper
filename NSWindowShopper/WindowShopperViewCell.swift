//
//  WindowShopperViewCell.swift
//  NSWindowShopper
//
//  Created by Jacob Alewel on 12/10/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import UIKit

class WindowShopperViewCell : UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var mostRecentlyLoadedImageURL : String?
    var hasConfiguredStaticUI : Bool = false
    
    func configureWithItem(item : Item) {
        if (!hasConfiguredStaticUI) {
            self.contentView.layer.cornerRadius = 9.0;
            //self.contentView.layer.borderColor = UIColor(white: 0.9, alpha: 1).CGColor
           // self.contentView.layer.borderWidth = 2
            self.contentView.clipsToBounds = true;
            
            self.itemImageView.clipsToBounds = true;
            
            self.itemImageView.contentMode = UIViewContentMode.ScaleAspectFill
            hasConfiguredStaticUI = true
        }
        
        self.mostRecentlyLoadedImageURL = item.hdImageURL!
        weak var weakSelf = self;
        ImageLoader.loadImageAtURL(item.hdImageURL!) { (loadedImage, loadedImageURL) -> Void in
            if (weakSelf != nil && weakSelf!.mostRecentlyLoadedImageURL == loadedImageURL) {
                weakSelf!.itemImageView.image = loadedImage
            }
        }
        
        self.titleLabel.text = item.name;
        
        if (item.price!.doubleValue % 1 == 0) {
            self.priceLabel.text = "$\(item.price!.integerValue)"
        } else {
            self.priceLabel.text = "$\(String(format: "%.2f", item.price!.doubleValue))"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.itemImageView.image = nil;
    }
    
}