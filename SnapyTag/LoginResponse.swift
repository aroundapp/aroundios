//
//  LoginResponse.swift
//  SnapyTag
//
//  Created by Rishi Mukherjee on 27/01/16.
//  Copyright © 2016 snapyTag. All rights reserved.
//

import Foundation
import SwiftyJSON

class LoginResponse: ResponseObjectSerializable, CustomStringConvertible {

    var description: String {
        return "token: \(token), user: \(user), app_version: \(appVersion)"
    }

    var token: String
    var user: STUser?
    var appVersion: STAppVersion?

    init?(token: String, user: STUser) {
        self.token = token
        self.user = user

        if self.token.isEmpty {
            return nil
        }
    }

    required init?(response: NSHTTPURLResponse, representation: AnyObject) {

        let responseJson = JSON(representation)
        self.token = responseJson["token"].stringValue
        STAppData.sharedInstance.appToken = token

        self.user = STUser(response: response, representation: responseJson["user"].object)
        self.appVersion = STAppVersion(response: response, representation: responseJson["app_version"].object)

        if token.isEmpty {
            return nil
        }
    }
}