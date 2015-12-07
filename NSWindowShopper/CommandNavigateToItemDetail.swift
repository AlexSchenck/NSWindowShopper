//
//  CommandNavigateToItemDetail.swift
//  NSWindowShopper
//
//  Created by Jacob Alewel on 12/6/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import UIKit

class CommandNavigateToItemDetail {
    
    static func executeWithNavigationController(navigationController : UINavigationController, andItem itemToNavigateTo : Item) {
        
        let storyboard = UIStoryboard(name: "ItemDetailViewController", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ItemDetailViewController") as! ItemDetailViewController
        vc.item = itemToNavigateTo
        navigationController.pushViewController(vc, animated: true)
        
    }
}