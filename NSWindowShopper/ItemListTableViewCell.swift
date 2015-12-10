//
//  ItemListTableViewCell.swift
//  NSWindowShopper
//
//  Created by Jacob Alewel on 12/6/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import UIKit

class ItemListTableViewCell : UITableViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var mostRecentlyLoadedImageURL : String?
    var hasConfiguredStaticUI : Bool = false
    
    // MARK - UI Configuration
    
    func configureWithItem(item : Item) {
        firstTimeUISetupIfNeeded()
        
        self.loadItemImage(item.imageURL!)
        self.titleLabel.text = item.name;
        self.priceLabel.text = item.formattedPriceText()
        self.setDescriptionText(item.description)
    }
    
    private func firstTimeUISetupIfNeeded() {
        if (!hasConfiguredStaticUI) {
            self.itemImageView.layer.cornerRadius = 3.0;
            self.itemImageView.layer.borderColor = ColorProvider.darkBorderColor.CGColor
            self.itemImageView.layer.borderWidth = 2
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
    
    private func setDescriptionText(descriptionText : String?) {
        // Really boot hack to fix textview bug
        // http://stackoverflow.com/questions/19049917/uitextview-font-is-being-reset-after-settext
        self.descriptionTextView.selectable = true;
        self.descriptionTextView.text = descriptionText;
        self.descriptionTextView.selectable = false;
    }
    
    // MARK - Cell Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.itemImageView.image = nil;
    }
    
}