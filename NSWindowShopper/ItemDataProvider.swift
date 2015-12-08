//
//  ItemDataProvider.swift
//  NSWindowShopper
//
//  Created by Jacob Alewel on 12/8/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation

protocol ItemDataProvider : AnyObject {
    
    func loadNextPage();
    
}