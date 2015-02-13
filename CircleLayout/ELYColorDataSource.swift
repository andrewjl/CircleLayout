//
//  ELYColorDataSource.swift
//  CircleLayout
//
//  Created by Andrew Lauer Barinov on 2/12/15.
//  Copyright (c) 2015 Elysian Fields. All rights reserved.
//

import UIKit

class ELYColorDataSource: NSObject {
    
    class func colorScheme() -> Array<UIColor> {

        return [
            UIColor(red: CGFloat(0.454), green: CGFloat(0.833), blue: CGFloat(1), alpha: CGFloat(1)),
            UIColor(red: CGFloat(0.416), green: CGFloat(0.894), blue: CGFloat(0.91), alpha: CGFloat(1)),
            UIColor(red: CGFloat(0.506), green: CGFloat(1), blue: CGFloat(0.875), alpha: CGFloat(1)),
            UIColor(red: CGFloat(0.416), green: CGFloat(0.91), blue: CGFloat(0.647), alpha: CGFloat(1)),
            UIColor(red: CGFloat(0.455), green: CGFloat(1), blue: CGFloat(0.557), alpha: CGFloat(1))
        ]
        
    }
    
}
