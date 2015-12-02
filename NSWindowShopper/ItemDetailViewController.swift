//
//  ItemDetailViewController.swift
//  NSWindowShopper
//
//  Created by iGuest on 12/1/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import UIKit

class ItemDetailViewController : UIViewController {
    
    @IBAction func navigateToProfileViewController(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "ProfileViewController", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
}
