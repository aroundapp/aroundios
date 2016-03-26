//
//  Snap.swift
//  SnapyTag
//
//  Created by Rishi Mukherjee on 11/03/16.
//  Copyright © 2016 snapyTag. All rights reserved.
//

import Foundation
import SwiftyJSON

final class STSnap: ResponseObjectSerializable, ResponseCollectionSerializable, CustomStringConvertible {

    var description: String {
        return "distanceInKilometers: \(distanceInKilometers), image_url: \(image_url), userName: \(userName), postId: \(postId)"
    }

    enum UserVote: Int {
        case up = 1
        case Down = -1
        case None = 0
    }

    var distance: Double
    var distanceInKilometers: Double
    var distanceInMiles: Double
    var downvotes: Int
    var image_url: String
    var lat: Double
    var lng: Double
    var postDescription: String
    var postId: Int
    var upvotes: Int
    var userId: Int
    var userName: String
    var userVote: UserVote

    required init?(response: NSHTTPURLResponse, representation: AnyObject) {
        let snapJson = JSON(representation)
        self.distance = (snapJson["distance"].stringValue as NSString).doubleValue
        self.distanceInKilometers = (snapJson["distance_in_kms"].stringValue as NSString).doubleValue
        self.distanceInMiles = (snapJson["distance_in_miles"].stringValue as NSString).doubleValue
        self.downvotes = snapJson["downvotes"].intValue
        self.image_url = snapJson["image_url"].stringValue
        self.lat = (snapJson["lat"].stringValue as NSString).doubleValue
        self.lng = (snapJson["lng"].stringValue as NSString).doubleValue
        self.postDescription = snapJson["post_description"].stringValue
        self.postId = snapJson["post_id"].intValue
        self.upvotes = snapJson["upvotes"].intValue
        self.userId = snapJson["user_id"].intValue
        self.userName = snapJson["user_name"].stringValue
        self.userVote = UserVote(rawValue: snapJson["uservote"].intValue)!
    }

    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [STSnap] {
        let json = JSON(representation)
        let snapsJson = json["posts"].object
        var snaps: [STSnap] = []
        if let representation = snapsJson as? [[String: AnyObject]] {
            for spanRepresentation in representation {
                if let snap = STSnap(response: response, representation: spanRepresentation) {
                    snaps.append(snap)
                }
            }
        }
        return snaps
    }
    
}
