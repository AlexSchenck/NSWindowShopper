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
 
    init(profile : Profile, name : String, description : String,
        price : NSNumber, location : CLLocation, locationName : String,
        datePosted : NSDate, imageURL : String) {
        
        self.profile = profile
        self.name = name
        self.description = description
        self.price = price
        self.location = location
        self.locationName = locationName
        self.datePosted = datePosted
        self.imageURL = imageURL
    }
    
    init() {
        
    }
}