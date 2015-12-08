//
//  NetworkService.swift
//  NSWindowShopper
//
//  Created by Jacob Alewel on 12/3/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import CoreLocation

protocol SearchResultsProxyDelegate : AnyObject {
    
    func loadedItems(items : [Item]);
    func failedToLoadItems();
    
}

class SearchResultsProxy {
    
    private weak var delegate : SearchResultsProxyDelegate?
    private var loadedItems : [Item]?
    private var pageNumber : Int = 0
    
    // MARK - Lifecycle
    
    init(delegate: SearchResultsProxyDelegate) {
        self.delegate = delegate;
    }
    
    // MARK - Network Interface
    
    func loadItems() {
        let urlToLoad = NSURL(string: "https://\(self.urlToLoad())/?page=\(self.pageNumber)");
        print(urlToLoad)
        if (urlToLoad == nil) {
            return;
        }
        
        let request = NSURLRequest(URL: urlToLoad!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60);
        let urlSession = NSURLSession.sharedSession();
        
        let task = urlSession.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if (error != nil || data == nil) {
                    self.notifyDelegateOfFailure()
                } else {
                    let parsedItemData : [Item]? = self.parseJsonData(data!);
                    if (parsedItemData == nil) {
                        self.notifyDelegateOfFailure()
                    } else {
                        if (self.loadedItems == nil) {
                            self.loadedItems = parsedItemData!
                        } else {
                            self.loadedItems!.appendContentsOf(parsedItemData!)
                        }
                        self.notifyDelegateOfLoadedItems()
                    }
                }
            })
        }
        task.resume()
    }
    
    func loadNextPage() {
        self.pageNumber++
        self.loadItems()
    }
    
    func reloadItems() {
        self.loadedItems = nil
        self.pageNumber = 0
        self.loadItems()
    }
    
    // MARK - Delegate Interface
    
    func notifyDelegateOfFailure() {
        if(self.delegate != nil) {
            self.delegate!.failedToLoadItems()
        }
    }
    
    func notifyDelegateOfLoadedItems() {
        if(self.delegate != nil) {
            self.delegate!.loadedItems(self.loadedItems!)
        }
    }
    
    // Mark - JSON Parsing
    
    func parseJsonData(jsonData : NSData) -> [Item]? {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options:NSJSONReadingOptions.AllowFragments)
            let dataJsonDictionary = json["data"] as! NSDictionary
            let itemsJsonArray : [NSDictionary] = dataJsonDictionary["items"] as! [NSDictionary];
            
            return self.parseItems(itemsJsonArray);
        } catch {
            return nil;
        }
    }
    
    func parseItems(jsonArray: NSArray) -> [Item]? {
        var itemsToReturn : [Item] = [];
        
        for itemData in jsonArray {
            let itemDictionary = itemData as! NSDictionary;
            let newItem = itemForItemDictionary(itemDictionary);
            itemsToReturn.append(newItem);
        }
        
        return itemsToReturn;
    }
    
    func itemForItemDictionary(itemDictionary : NSDictionary) -> Item {
        let item = Item();
        item.name = itemDictionary["title"] as! String?;
        item.description = itemDictionary["description"] as! String?;
        item.imageURL = itemDictionary["get_img_permalink_small"] as! String?;
        item.price = numberForString(itemDictionary["price"] as! String)
        
        item.datePosted = dateForString(itemDictionary["post_date"] as! String);
        
        let itemLongitude = numberForString(itemDictionary["longitude"] as! String).doubleValue;
        let itemLatitude = numberForString(itemDictionary["latitude"] as! String).doubleValue;
        item.location = CLLocation(latitude: itemLongitude, longitude: itemLatitude);
        item.locationName = itemDictionary["location_name"] as! String?
        
        let ownerDictionary = itemDictionary["owner"] as! NSDictionary;
        item.profile = profileForOwnerDictionary(ownerDictionary);
        
        return item;
    }
    
    func profileForOwnerDictionary(ownerDictionary: NSDictionary) -> Profile {
        let profile = Profile();

        profile.displayName = ownerDictionary["first_name"] as! String?;
        profile.dateJoined = dateForString(ownerDictionary["date_joined"] as! String);
        
        let profileDictionary = ownerDictionary["get_profile"] as! NSDictionary;
        profile.avatarURL = ownerDictionary["get_profile"]!["avatar_normal"] as! String?;

        let ratingDictionary = profileDictionary["rating"] as! NSDictionary;
        profile.ratingCount = (ratingDictionary["count"] as! NSNumber).integerValue;
        profile.ratingScore = ratingScoreForRatingDictionary(ratingDictionary);
        
        return profile;
    }
    
    func ratingScoreForRatingDictionary(ratingDictionary : NSDictionary) -> NSNumber {
        let ratingAverage = ratingDictionary["average"];
        if (ratingAverage == nil || ratingAverage!.isKindOfClass(NSNull)){
            return 0
        } else {
            if (ratingAverage!.isKindOfClass(NSNumber)) {
                return ratingAverage as! NSNumber;
            }
            
            let ratingAverageString = ratingAverage as! String;
            return numberForString(ratingAverageString)
        }
    }
    
    // MARK - Helper
    
    func numberForString(string : String) -> NSNumber {
        let numberFormatter = NSNumberFormatter();
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle;
        return numberFormatter.numberFromString(string)!
    }
    
    func dateForString(string : String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
        return dateFormatter.dateFromString(string)!
    }

    // MARK - Source
    
    func urlToLoad() -> String {
        let sourceString : NSString = obfuscatedURLString();
        let modifiedString = NSMutableString();
        for var index = 0; index < sourceString.length; index++ {
            var character = (CChar(sourceString.characterAtIndex(index)) - CChar(1));
            let newString = NSString(bytes: &character, length: sizeofValue(character), encoding: NSUTF8StringEncoding)
            modifiedString.appendString(newString as! String)
        }
        return modifiedString as String;
    }
    
    func obfuscatedURLString() -> NSString {
        return "bqj/pggfsvq.tuh/dpn0bqj0w30jufnt"
    }
    
}