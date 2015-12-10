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
    
    // MARK - Static Colors
    
    static let darkBorderColor = UIColor(white: 0.2, alpha: 1.0)
    static let whiteColor = UIColor(white: 0.9, alpha: 1.0)
    
    // MARK - Item List Background Colors
    
    private static var blueComponent : CGFloat = ColorProvider.randomColorGenerator() / 1.25
    
    private static var indicesPerCycle : Double = Double(arc4random() % 5) + 20.0
    private static var indexOffset : Int = Int(arc4random() % 10)
    
    static func colorForItemPosition(itemPosition : Int) -> UIColor {
        
        var red: CGFloat = 0
        var green: CGFloat = CGFloat(abs(sin(Double(itemPosition + ColorProvider.indexOffset) * M_PI / ColorProvider.indicesPerCycle))) / 1.75
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
    
    static func reset() {
        ColorProvider.blueComponent = ColorProvider.randomColorGenerator() / 1.25
        ColorProvider.indicesPerCycle = Double(arc4random() % 5) + 10.0
        ColorProvider.indexOffset = Int(arc4random() % 10)
    }
    
    // MARK - Private Helper
    
    private static func randomColorGenerator() -> CGFloat {
        var randomColorComponent : CGFloat = 0
        while (randomColorComponent < 0.25 || randomColorComponent > 0.75) {
            randomColorComponent = CGFloat(arc4random() % 256 ) / 256
        }
        return randomColorComponent
    }
    
}
