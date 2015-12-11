//
//  Item.swift
//  NSWindowShopper
//
//  Created by iGuest on 12/1/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import CoreLocation

class Item {
 
    var profile : Profile?
    var name : String?
    var description : String?
    var price : NSNumber?
    var location : CLLocation?
    var locationName : String?
    var datePosted : NSDate?
    var imageURL : String?
    var hdImageURL : String?
    
    func formattedPriceText() -> String {
        if (self.price!.doubleValue % 1 == 0) {
            return "$\(self.price!.integerValue)"
        } else {
            return "$\(String(format: "%.2f", self.price!.doubleValue))"
        }
    }
    
}