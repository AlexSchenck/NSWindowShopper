//
//  ItemDetailViewController.swift
//  NSWindowShopper
//
//  Created by iGuest on 12/1/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class ItemDetailViewController : UIViewController {
    
    @IBOutlet weak var ItemImage: UIImageView!
    @IBOutlet weak var ItemPrice: UILabel!
    @IBOutlet weak var ItemName: UILabel!
    @IBOutlet weak var ItemLocation: UILabel!
    @IBOutlet weak var DatePosted: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var ItemDescription: UILabel!
    @IBOutlet weak var ToProfileButton: UIButton!
    @IBOutlet weak var ShadowView: UIView!
    
    var item : Item?
    
    override func viewDidLoad() {
        
        weak var weakSelf = self;
        ImageLoader.loadImageAtURL(item!.hdImageURL!) { (loadedImage, _) -> Void in
            if (weakSelf != nil) {
                weakSelf!.ItemImage.image = loadedImage
            }
        }
        
        ItemImage.clipsToBounds = true
        ItemImage.contentMode = UIViewContentMode.ScaleAspectFill
        ItemImage.layer.cornerRadius = 5
        
        ItemName.text = item!.name
        ItemPrice.text = item!.formattedPriceText()
        ItemLocation.text = "Located in \(item!.locationName!)"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        DatePosted.text = "Posted on \(dateFormatter.stringFromDate(item!.datePosted!))"
        
        if (item!.description != "") {
            ItemDescription.text = item!.description
        } else {
            ItemDescription.text = "There is no description for this item."
        }
        
        let vendorName = item!.profile!.displayName!
        
        if (vendorName != "") {
            ToProfileButton.setTitle("\(vendorName)'s Profile", forState: UIControlState.Normal)
        }
        
        ToProfileButton.layer.cornerRadius = 5
        
        self.title = item!.name
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        ToProfileButton.setTitleColor(self.view.backgroundColor, forState: UIControlState.Normal)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(1, animations: {
            self.ItemImage.alpha = 1
        })
        
        UIView.animateWithDuration(1, delay: 0.5, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
            self.ItemPrice.alpha = 1
            self.ItemName.alpha = 1
            self.ItemLocation.alpha = 1
            self.DatePosted.alpha = 1
            self.DescriptionLabel.alpha = 1
            self.ItemDescription.alpha = 1
            self.ToProfileButton.alpha = 1
        }, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        ShadowView.layer.shadowColor = UIColor.blackColor().CGColor
        ShadowView.layer.shadowOffset = CGSizeZero
        ShadowView.layer.shadowOpacity = 0.7
        ShadowView.layer.shadowRadius = 15
        ShadowView.addSubview(ItemImage)
    }
    
    @IBAction func navigateToProfileViewController(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "ProfileViewController", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        vc.testProfile = item!.profile
        vc.view.backgroundColor = self.view.backgroundColor
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
