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
    @IBOutlet weak var ItemName: UILabel!
    @IBOutlet weak var ItemLocation: UILabel!
    @IBOutlet weak var DatePosted: UILabel!
    @IBOutlet weak var ItemDescription: UILabel!
    @IBOutlet weak var ToProfileButton: UIButton!
    
    var item : Item?
    
    override func viewDidLoad() {
        
        weak var weakSelf = self;
        ImageLoader.loadImageAtURL(item!.imageURL!) { (loadedImage) -> Void in
            if (weakSelf != nil) {
                weakSelf!.ItemImage.image = loadedImage
            }
        }
        
        ItemImage.clipsToBounds = true
        
        ItemName.text = "\(item!.name!), $\(item!.price!.stringValue)"
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
    }
    
    @IBAction func navigateToProfileViewController(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "ProfileViewController", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        vc.testProfile = item!.profile
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
