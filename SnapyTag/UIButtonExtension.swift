//
//  UIButtonExtension.swift
//  SnapyTag
//
//  Created by Rishi Mukherjee on 10/03/16.
//  Copyright © 2016 snapyTag. All rights reserved.
//

import UIKit

extension UIButton {

    public override func intrinsicContentSize() -> CGSize {

        let intrinsicContentSize = super.intrinsicContentSize()

        let adjustedWidth = intrinsicContentSize.width + titleEdgeInsets.left + titleEdgeInsets.right
        let adjustedHeight = intrinsicContentSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom

        return CGSize(width: adjustedWidth, height: adjustedHeight)
        
    }
    
}
