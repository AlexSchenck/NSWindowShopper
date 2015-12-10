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
    
    static func executeWithNavigationController(navigationController : UINavigationController, withItem itemToNavigateTo : Item, andColor backgroundColor : UIColor) {
        
        let storyboard = UIStoryboard(name: "ItemDetailViewController", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ItemDetailViewController") as! ItemDetailViewController
        vc.item = itemToNavigateTo
        vc.view.backgroundColor = backgroundColor
        navigationController.pushViewController(vc, animated: true)
        
    }
}