//
//  Network.swift
//  SnapyTag
//
//  Created by Rishi Mukherjee on 21/01/16.
//  Copyright © 2016 snapyTag. All rights reserved.
//

import Alamofire
import SwiftyJSON

public protocol ResponseObjectSerializable {
    init?(response: NSHTTPURLResponse, representation: AnyObject)
}

public protocol ResponseCollectionSerializable {
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Self]
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

    public func responseCollection<T: ResponseCollectionSerializable>(completionHandler: Response<[T], NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<[T], NSError> { request, response, data, error in
            guard error == nil else { return .Failure(error!) }

            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONSerializer.serializeResponse(request, response, data, error)

            switch result {
            case .Success(let value):
                if let response = response {
                    return .Success(T.collection(response: response, representation: value))
                } else {
                    let failureReason = "Response collection could not be serialized due to nil response"
                    let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                    return .Failure(error)
                }
            case .Failure(let error):
                return .Failure(error)
            }
        }

        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }

    public static func imageResponseSerializer() -> ResponseSerializer<UIImage, NSError> {
        return ResponseSerializer { request, response, data, error in
            guard error == nil else { return .Failure(error!) }

            let image = UIImage(data: data!, scale: UIScreen.mainScreen().scale)

            return .Success(image!)
        }
    }

    public func responseImage(completionHandler: Response<UIImage, NSError> -> Void) -> Self {
        return response(responseSerializer: Request.imageResponseSerializer(), completionHandler: completionHandler)
    }
}


enum STRouter: URLRequestConvertible {
    static let baseURLString = "http://api.snapytag.in"

    case SignUp(String)
    case VerifyLogin()
    case GetSnaps(String, String, String, String)

    var method: Alamofire.Method {
        switch self {
        case .SignUp:
            return .POST
        case .VerifyLogin:
            return .POST
        case .GetSnaps:
            return .GET
        }
    }

    var path: String {
        switch self {
        case .SignUp:
            return "/signup"
        case .VerifyLogin:
            return "/verifylogin"
        case .GetSnaps:
            return "/posts"
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
        case .GetSnaps(let lat_lng, let not_ids, let timestamp, let when):
            let params = ["token": STAppData.sharedInstance.appToken!, "lat_lng": lat_lng, "not_ids": not_ids, "timestamp": timestamp, "when": when]
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
        }
    }
}

class STNetwork {
    static let sharedInstance = STNetwork()
    var manager: Manager?

    init() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 10.0
        manager = Alamofire.Manager(configuration: configuration)
    }

    func verifyAppToken(success: ((response: LoginResponse) -> ()), failure: ((error: NSError) -> ())) {
        manager?.request(STRouter.VerifyLogin())
            .validate()
            .responseObject {
                (response: Response<LoginResponse, NSError>) in
                switch response.result {
                case .Success(let response):
                    success(response: response)
                case .Failure(let error):
                    failure(error: error)
                }
        }
    }

    func signUpUserWithFBToken(fbToken: String, success: ((response: LoginResponse) -> ()), failure: ((error: NSError) -> ())) {
        manager?.request(STRouter.SignUp(fbToken))
            .validate()
            .responseObject {
                (response: Response<LoginResponse, NSError>) in
                switch response.result {
                case .Success(let response):
                    success(response: response)
                case .Failure(let error):
                    failure(error: error)
                }
        }
    }

    func getSnaps(latLng: String, notIds: String, timestamp: String, when: String = "before", success: ((response: [STSnap]) -> ()), failure: ((error: NSError) -> ())) {
        manager?.request(STRouter.GetSnaps(latLng, notIds, timestamp, when))
            .validate()
            .responseCollection {
                (response: Response<[STSnap], NSError>) in
                switch response.result {
                case .Success(let response):
                    success(response: response)
                case .Failure(let error):
                    failure(error: error)
                }
        }
    }

    func getImage(imageUrl: String, success: ((response: UIImage) -> ()), failure: ((error: NSError) -> ())) {
        manager?.request(.GET, imageUrl).validate().responseImage {
            (response: Response<UIImage, NSError>) in
            switch response.result {
            case .Success(let response):
                success(response: response)
            case .Failure(let error):
                failure(error: error)
            }
        }
    }
}
