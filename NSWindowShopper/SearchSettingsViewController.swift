//
//  SearchSettingsViewController.swift
//  NSWindowShopper
//
//  Created by iGuest on 12/1/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import UIKit

class SearchSettingsViewController : UIViewController {
    
    override func viewDidLoad() {
        let button = UIBarButtonItem(title: "Apply", style: UIBarButtonItemStyle.Done, target: self, action: Selector("handleApplyPressed"))
        self.navigationItem.setRightBarButtonItem(button, animated: false)
    }
    
    func handleApplyPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}