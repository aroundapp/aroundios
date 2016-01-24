//
//  Utils.swift
//  SnapyTag
//
//  Created by Rishi Mukherjee on 21/01/16.
//  Copyright © 2016 snapyTag. All rights reserved.
//

import Foundation


class STUtils {

    static let sharedInstance = STUtils()
    private init() {}


}

class STStatusCodes {
    static let SUCCESS = 200
    static let BAD_REQUEST = 400
    static let UNAUTHORIZED = 401
    static let FORBIDDEN = 403
    static let NOT_FOUND = 404
    static let METHOD_NOT_ALLOWED = 405
    static let APPLICATION_ERROR = 500
}