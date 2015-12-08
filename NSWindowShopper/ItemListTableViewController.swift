//
//  ItemListTableViewController.swift
//  NSWindowShopper
//
//  Created by Jacob Alewel on 12/6/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import UIKit

class ItemListTableViewController : UITableViewController, NeedsDataFromSearchResults {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false;
        self.view.clipsToBounds = true;
    }
    
    func reloadWithData(items: [Item]) {
        print("itemlist shouldReload");
    }
    
}