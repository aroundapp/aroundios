//
//  AppData.swift
//  SnapyTag
//
//  Created by Rishi Mukherjee on 21/01/16.
//  Copyright © 2016 snapyTag. All rights reserved.
//

import Foundation

struct STAppDataKeys {
    static let appToken = "appToken"
    static let deviceUUID = "deviceUUID"
}


class STAppData {

    static let sharedInstance = STAppData()
    private init() {}

    private var userDefaults = NSUserDefaults.standardUserDefaults()

    static var isLogined: Bool {

        if let _ = STAppData.sharedInstance.appToken {
            return true
        } else {
            return false
        }
    }


    var appToken: String? {
        set (token) {
            userDefaults.setObject(token, forKey: STAppDataKeys.appToken)
        }
        get {
            var token: String?
            if let apptoken = userDefaults.stringForKey(STAppDataKeys.appToken) {
                token = apptoken
            }
            return token
        }
    }

    var deviceId: String {
        get {
            let deviceUUID: String

            if let deviceuuid = userDefaults.stringForKey(STAppDataKeys.deviceUUID) {
                deviceUUID = deviceuuid
            } else {
                let uuid = NSUUID().UUIDString
                deviceUUID = uuid
                userDefaults.setObject(uuid, forKey: STAppDataKeys.deviceUUID)
            }
            return deviceUUID
        }
    }
    
}