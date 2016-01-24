//
//  LoginDot.swift
//  SnapyTag
//
//  Created by Rishi Mukherjee on 23/01/16.
//  Copyright © 2016 snapyTag. All rights reserved.
//

import UIKit

class LoginDot: UIView {

    let greyColor = UIColor(red: 179.0/255.0, green: 179.0/255.0, blue: 179.0/255.0, alpha: 1.0).CGColor

    override func drawRect(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        CGContextAddEllipseInRect(ctx, rect)
        CGContextSetFillColor(ctx, CGColorGetComponents(greyColor))
        CGContextFillPath(ctx);
    }

}
