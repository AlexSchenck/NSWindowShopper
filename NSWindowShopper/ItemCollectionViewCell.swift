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
    
    func configureWithItem(item : Item) {
        if (!hasConfiguredStaticUI) {
            self.contentView.layer.cornerRadius = 3.0;
            self.contentView.layer.borderColor = UIColor(white: 0.9, alpha: 1).CGColor
            self.contentView.layer.borderWidth = 2
            self.contentView.clipsToBounds = true;
            
            self.itemImageView.clipsToBounds = true;
            
            self.itemImageView.contentMode = UIViewContentMode.ScaleAspectFill
            hasConfiguredStaticUI = true
        }
        
        self.contentView.backgroundColor = generateRandomPastelColor(withMixedColor: UIColor.grayColor())
        
        self.mostRecentlyLoadedImageURL = item.imageURL!
        weak var weakSelf = self;
        ImageLoader.loadImageAtURL(item.imageURL!) { (loadedImage, loadedImageURL) -> Void in
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
    
    func generateRandomPastelColor(withMixedColor mixColor: UIColor?) -> UIColor {
        let randomColorGenerator = { ()-> CGFloat in
            CGFloat(arc4random() % 256 ) / 256
        }
        
        var red: CGFloat = 0//randomColorGenerator() / 1.25
        var green: CGFloat = randomColorGenerator() / 1.75
        var blue: CGFloat = randomColorGenerator() / 1.25
        
        // Mix the color
        if let mixColor = mixColor {
            var mixRed: CGFloat = 0, mixGreen: CGFloat = 0, mixBlue: CGFloat = 0;
            mixColor.getRed(&mixRed, green: &mixGreen, blue: &mixBlue, alpha: nil)
            
            red = (red + mixRed) / 2;
            green = (green + mixGreen) / 2;
            blue = (blue + mixBlue) / 2;
        }
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
}