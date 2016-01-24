//
//  Network.swift
//  SnapyTag
//
//  Created by Rishi Mukherjee on 21/01/16.
//  Copyright © 2016 snapyTag. All rights reserved.
//

import Alamofire

public protocol ResponseObjectSerializable {
    init?(response: NSHTTPURLResponse, representation: AnyObject)
}

extension Request {
    public func responseObject<T: ResponseObjectSerializable>(completionHandler: Response<T, NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<T, NSError> { request, response, data, error in
            guard error == nil else { return .Failure(error!) }

            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)

            switch result {
            case .Success(let value):
                if let
                    response = response,
                    responseObject = T(response: response, representation: value)
                {
                    return .Success(responseObject)
                } else {
                    let failureReason = "JSON could not be serialized into response object: \(value)"
                    let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                    return .Failure(error)
                }
            case .Failure(let error):
                return .Failure(error)
            }
        }

        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}


enum STRouter: URLRequestConvertible {
    static let baseURLString = "http://api.snapytag.in"

    case SignUp(String)
    case VerifyLogin()

    var method: Alamofire.Method {
        switch self {
        case .SignUp:
            return .POST
        case .VerifyLogin:
            return .POST
        }
    }

    var path: String {
        switch self {
        case .SignUp:
            return "/signup"
        case .VerifyLogin:
            return "/verifylogin"
        }
    }

    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: STRouter.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue

        switch self {
        case .SignUp(let fb_token):
            let params: [String: AnyObject] = ["fb_token": fb_token, "device_id": STAppData.sharedInstance.deviceId]
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
        case .VerifyLogin():
            let params = ["token": STAppData.sharedInstance.appToken!, "device_id": STAppData.sharedInstance.deviceId]
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
        }
    }
}

class STNetwork {
    static let sharedInstance = STNetwork()
    private init() {}

    func verifyAppToken(success: ((user: STUser) -> ()), failure: ((error: NSError) -> ())) {
        Alamofire.request(STRouter.VerifyLogin())
            .validate()
            .responseObject {
                (response: Response<STUser, NSError>) in
                switch response.result {
                case .Success(let user):
                    success(user: user)
                case .Failure(let error):
                    failure(error: error)
                }
        }
    }

    func signUpUserWithFBToken(fbToken: String, success: ((user: STUser) -> ()), failure: ((error: NSError) -> ())) {
        Alamofire.request(STRouter.SignUp(fbToken))
            .validate()
            .responseObject {
                (response: Response<STUser, NSError>) in
                switch response.result {
                case .Success(let user):
                    success(user: user)
                case .Failure(let error):
                    failure(error: error)
                }
        }
    }
}
