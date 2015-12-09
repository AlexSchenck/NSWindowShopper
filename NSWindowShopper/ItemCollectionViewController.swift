//
//  ItemCollectionViewController.swift
//  NSWindowShopper
//
//  Created by Jacob Alewel on 12/6/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import UIKit

class ItemCollectionViewController : UICollectionViewController, NeedsDataFromSearchResults {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false;
        
    }
    
    func reloadWithData(items: [Item]?) {
        print("collection shouldReload");
    }
    
}