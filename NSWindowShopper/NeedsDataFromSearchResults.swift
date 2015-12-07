//
//  NeedsDataFromSearchResults.swift
//  NSWindowShopper
//
//  Created by Jacob Alewel on 12/6/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation

protocol NeedsDataFromSearchResults {

    func reloadWithData(items : [Item]?) -> Void
    
}