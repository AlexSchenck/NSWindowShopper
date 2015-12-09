//
//  ImageLoader.swift
//  NSWindowShopper
//
//  Created by Jacob Alewel on 12/6/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import UIKit

class ImageLoader {
    
    static var cachedImageDictionary : NSMutableDictionary?
    
    static func loadImageAtURL(urlToLoad : String, andCompletionHander completionHandler: (loadedImage : UIImage, loadedImageURL : String) -> Void) {
        
        if (cachedImageDictionary == nil) {
            cachedImageDictionary = NSMutableDictionary();
        }
        
        let cachedImage = cachedImageDictionary![urlToLoad];
        
        if (cachedImage != nil) {
            completionHandler(loadedImage: cachedImage as! UIImage, loadedImageURL: urlToLoad)
        } else {
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                if let url = NSURL(string: urlToLoad) {
                    if let data = NSData(contentsOfURL: url) {
                        if let loadedImage = UIImage(data: data) {
                            dispatch_async(dispatch_get_main_queue()) {
                                cachedImageDictionary!.setObject(loadedImage, forKey: urlToLoad)
                                completionHandler(loadedImage: loadedImage, loadedImageURL:urlToLoad);
                            }
                        }
                    }
                }
            }
        }
    }
}
