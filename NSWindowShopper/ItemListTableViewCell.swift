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
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    
    func configureWithItem(item : Item) {
        
        weak var weakSelf = self;
        ImageLoader.loadImageAtURL(item.imageURL!) { (loadedImage) -> Void in
            if (weakSelf != nil) {
                weakSelf!.itemImageView.image = loadedImage
            }
        }
        
        self.titleLabel.text = item.name;
        self.descriptionTextView.text = item.description;
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.itemImageView.image = nil;
//        self.titleLabel.text = nil;
//        self.descriptionTextView.text = nil;
    }
}