//
//  User.swift
//  SnapyTag
//
//  Created by Rishi Mukherjee on 23/01/16.
//  Copyright © 2016 snapyTag. All rights reserved.
//

import Foundation
import SwiftyJSON

class STUser: ResponseObjectSerializable, CustomStringConvertible {

    var description: String {
        return "firstName: \(firstName), lastName: \(lastName), gender: \(gender), pictureUrl: \(pictureUrl)"
    }

    var firstName: String
    var lastName: String
    var gender: String
    var pictureUrl: String

    init?(firstName: String, lastName: String, gender: String, pictureUrl: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.pictureUrl = pictureUrl

        if self.firstName.isEmpty {
            return nil
        }
    }

    required init?(response: NSHTTPURLResponse, representation: AnyObject) {
        let userJson = JSON(representation)
        let token = userJson["token"].stringValue
        STAppData.sharedInstance.appToken = token
        self.firstName = userJson["user"]["first_name"].stringValue
        self.lastName = userJson["user"]["last_name"].stringValue
        self.gender = userJson["user"]["gender"].stringValue
        self.pictureUrl = userJson["user"]["picture"].stringValue

        if self.firstName.isEmpty {
            return nil
        }

        if token.isEmpty {
            return nil
        }
    }

}
