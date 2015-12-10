//
//  ColorProvider.swift
//  NSWindowShopper
//
//  Created by Jacob Alewel on 12/10/15.
//  Copyright © 2015 iGuest. All rights reserved.
//

import Foundation
import UIKit

class ColorProvider {
    
    static let blueComponent : CGFloat = ColorProvider.randomColorGenerator() / 1.25
    
    static func randomColorGenerator() -> CGFloat {
        var randomColorComponent : CGFloat = 0
        while (randomColorComponent < 0.25 || randomColorComponent > 0.75) {
            randomColorComponent = CGFloat(arc4random() % 256 ) / 256
        }
        return randomColorComponent
    }
    
    static func colorForItemPosition(itemPosition : Int) -> UIColor {
        
        var red: CGFloat = 0
        var green: CGFloat = CGFloat(abs(sin(Double(itemPosition) * M_PI / 10.0))) / 1.75
        var blue: CGFloat = blueComponent
        
        // Mix the color
        let mixColor : UIColor? = UIColor.grayColor()
        if let mixColor = mixColor {
            var mixRed: CGFloat = 0, mixGreen: CGFloat = 0, mixBlue: CGFloat = 0;
            mixColor.getRed(&mixRed, green: &mixGreen, blue: &mixBlue, alpha: nil)
            
            red = (red + mixRed) / 2;
            green = (green + mixGreen) / 2;
            blue = (blue + mixBlue) / 2;
        }
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
}
