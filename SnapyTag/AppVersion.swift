//
//  AppVersion.swift
//  SnapyTag
//
//  Created by Rishi Mukherjee on 27/01/16.
//  Copyright © 2016 snapyTag. All rights reserved.
//

import Foundation
import SwiftyJSON

class STAppVersion: ResponseObjectSerializable, CustomStringConvertible {

    var description: String {
        return "min: \(min), recent: \(recent)"
    }

    var min: String
    var recent: String

    init?(min: String, recent: String) {
        self.min = min
        self.recent = recent

        if self.min.isEmpty {
            return nil
        }
        if self.recent.isEmpty {
            return nil
        }
    }

    required init?(response: NSHTTPURLResponse, representation: AnyObject) {

        let responseJson = JSON(representation)
        self.min = responseJson["min"].stringValue
        self.recent = responseJson["recent"].stringValue

        if self.min.isEmpty {
            return nil
        }
        if self.recent.isEmpty {
            return nil
        }
    }
    
}