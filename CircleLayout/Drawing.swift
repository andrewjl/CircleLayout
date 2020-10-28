//
//  Drawing.swift
//  CircleLayout
//
//  Created by Andrew Lauer Barinov on 10/26/20.
//  Copyright © 2020 Elysian Fields. All rights reserved.
//

import UIKit

public typealias DrawingBlock = (UIGraphicsImageRendererContext) -> Void

func circleRenderer(fillColor: UIColor,
                    backgroundColor: UIColor = .secondaryLabel,
                    radius: CGFloat = 25.0,
                    borderWidth: CGFloat = 4.0) -> DrawingBlock {
    return { context in
        let ctxt = context.cgContext
        
        let borderRect = CGRect(x: borderWidth,
                                y: borderWidth,
                                width: radius-(borderWidth*2),
                                height: radius-(borderWidth*2))
        ctxt.setStrokeColor(backgroundColor.cgColor)
        ctxt.setFillColor(fillColor.cgColor)
        ctxt.fillEllipse(in: borderRect)
        ctxt.strokeEllipse(in: borderRect)
        ctxt.fillPath()
    }
}
