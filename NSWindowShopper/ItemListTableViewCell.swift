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
    
    var hasConfiguredStaticUI : Bool = false
    
    func configureWithItem(item : Item) {

        if (!hasConfiguredStaticUI) {
            self.itemImageView.layer.cornerRadius = 3.0;
            self.itemImageView.layer.borderColor = UIColor(white: 0.9, alpha: 1).CGColor
            self.itemImageView.layer.borderWidth = 2
            self.itemImageView.clipsToBounds = true;
            
            self.itemImageView.contentMode = UIViewContentMode.ScaleAspectFill
            hasConfiguredStaticUI = true
        }
        
        self.contentView.backgroundColor = generateRandomPastelColor(withMixedColor: UIColor.grayColor())
        
        weak var weakSelf = self;
        ImageLoader.loadImageAtURL(item.imageURL!) { (loadedImage) -> Void in
            if (weakSelf != nil) {
                weakSelf!.itemImageView.image = loadedImage
            }
        }
        
        self.titleLabel.text = item.name;
        
        if (item.price!.doubleValue % 1 == 0) {
            self.priceLabel.text = "$\(item.price!.integerValue)"
        } else {
            self.priceLabel.text = "$\(String(format: "%.2f", item.price!.doubleValue))"
        }
    
        // Really boot hack to fix textview bug
        // http://stackoverflow.com/questions/19049917/uitextview-font-is-being-reset-after-settext
        self.descriptionTextView.selectable = true;
        self.descriptionTextView.text = item.description;
        self.descriptionTextView.selectable = false;
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