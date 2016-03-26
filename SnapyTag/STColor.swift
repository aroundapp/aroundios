//
//  STColor.swift
//  SnapyTag
//
//  Created by Rishi Mukherjee on 07/02/16.
//  Copyright © 2016 snapyTag. All rights reserved.
//

import UIKit
import DynamicColor

extension UIColor {

    class func snapyTagTintColor() -> UIColor {
        return UIColor(hexString: "#03A9F4")
    }

    class func snapyTagRefreshTintColor() -> UIColor {
        return UIColor(hexString: "#FFFFFF")
    }

    class func snapyTagRefreshBackgroundColor() -> UIColor {
        return UIColor(hexString: "#03A9F4")
    }

    class func snapyTagNavgationBarTitleColor() -> UIColor {
        return UIColor(hexString: "#FFFFFF")
    }

    class func snapyTagSegmentedControlColor() -> UIColor {
        return snapyTagSegmentedControlBackgroundColor().darkenColor(4.0)
    }

    class func snapyTagSegmentedControlBackgroundColor() -> UIColor {
        return UIColor(hexString: "#28b5f5")
    }

}