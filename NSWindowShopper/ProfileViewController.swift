//
//  ProfileViewController.swift
//  NSWindowShopper
//
//  Created by iGuest on 12/1/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController : UIViewController {
    
    @IBOutlet weak var profileRating: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileMemberSince: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var ratingStar: CosmosView!
    
    var testProfile : Profile? //= Profile(displayName: "Harry McDonough", dateJoined: NSDate(), ratingScore: 3.7, ratingCount: 47, avatarURL: "https://graph.facebook.com/1069772458/picture?type=normal&return_ssl_resources=true")
    
    override func viewDidLoad() {
        if let url = NSURL(string: testProfile!.avatarURL!) {
            if let data = NSData(contentsOfURL: url) {
                profileImage.image = UIImage(data: data)
            }        
        }
        profileImage.clipsToBounds = true
        
        profileName.text = testProfile!.displayName
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        profileMemberSince!.text = "Member since: " + dateFormatter.stringFromDate(testProfile!.dateJoined!)
  
        ratingStar.rating = Double((testProfile?.ratingScore)!)
        ratingStar.settings.fillMode = .Precise
        profileRating.text = String(Double((testProfile?.ratingScore)!)) + " stars across " + String(testProfile!.ratingCount!) + " reviews"
    }
}
