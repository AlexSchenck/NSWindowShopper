//
//  Profile.swift
//  NSWindowShopper
//
//  Created by iGuest on 12/1/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation

class Profile {
    
    var displayName : String?;
    var dateJoined : NSDate?;
    var ratingScore : NSNumber?;
    var ratingCount : Int?;
    var avatarURL : String?;

    init(displayName : String, dateJoined : NSDate, ratingScore : NSNumber, ratingCount : Int, avatarURL : String) {
        self.displayName = displayName
        self.dateJoined = dateJoined
        self.ratingScore = ratingScore
        self.ratingCount = ratingCount
        self.avatarURL = avatarURL
    }
    
    init() {
        
    }
    
}