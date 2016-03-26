//
//  NearestFeedViewController
//  SnapyTag
//
//  Created by Rishi Mukherjee on 07/02/16.
//  Copyright © 2016 snapyTag. All rights reserved.
//

import UIKit
import CoreLocation
import SVProgressHUD
import SwiftLocation
import CoreLocation
import SwiftDate

class NearestFeedViewController: UITableViewController {

    let snapFeedCellIdentifier = "SnapFeedCell"
    var nearestFeed: [STSnap] = []
    var location: CLLocation?
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var populatingPhotos = false
    var shouldRequestMore = true
    var kLoadingCellTag = 256

    var notIds: String {
        get {
            return nearestFeed.map({
                String($0.postId)
            }).joinWithSeparator(",")
        }
    }

    enum SnapRequestType: String {
        case After = "after"
        case Before = "before"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setDefaultMaskType(.Gradient)
        configureTableView()
        getLocation()
        view.tag = 0
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.navigationBar.translucent = false

        // Refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.snapyTagRefreshBackgroundColor()
        self.refreshControl?.tintColor = UIColor.snapyTagRefreshTintColor()
        self.refreshControl?.addTarget(self, action: #selector(getLatestSnaps), forControlEvents: .ValueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 350.0
        tableView.showsVerticalScrollIndicator = false
    }


    func getLocation() {
        SVProgressHUD.showWithStatus("Getting Location...")
        do {
            try SwiftLocation.shared.currentLocation(.Neighborhood, timeout: 10,
                                                 onSuccess: {
                                                    (location) -> Void in
                                                    self.location = location
                                                    self.getSnapsForLocation(location!, notIds: "", requestType: .Before, showLoading: true, callback: nil)
                },
                                                 onFail: {
                                                    error in
                                                    SVProgressHUD.dismiss()
                                                    let alert = UIAlertController(title: "Could not fetch location.", message: nil, preferredStyle: .Alert)
                                                    let ok = UIAlertAction(title: "Ok", style: .Default, handler: { (alert) in
                                                        self.getLocation()
                                                    })
                                                    alert.addAction(ok)
                                                    self.presentViewController(alert, animated: true, completion: nil)
            })
        } catch (let error) {
            print("Error \(error)")
            SVProgressHUD.dismiss()
        }
    }

    func getSnapsForLocation(location: CLLocation, notIds: String = "", requestType: SnapRequestType = .Before, showLoading: Bool = false, callback: (() -> ())? = nil) {
        if populatingPhotos || (!shouldRequestMore && requestType == .Before) {
            return
        }
        populatingPhotos = true

        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        if showLoading {
            SVProgressHUD.showWithStatus("Getting Feed...")
        }
        STNetwork.sharedInstance.getSnaps("\(latitude),\(longitude)", notIds: notIds, timestamp: appDelegate.appStartTimeStamp.toString(.Custom("yyyy-MM-dd HH:mm:ss"))!, when: requestType.rawValue,
            success: {
                response in
                if showLoading {
                    SVProgressHUD.dismiss()
                }

                if response.count == 0 {
                    switch requestType {
                    case .Before:
                        self.shouldRequestMore = false
                    case .After:
                        self.refreshControl?.endRefreshing()
                    }
                    self.populatingPhotos = false
                    return
                }

                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                    var indexPaths: [NSIndexPath] = []
                    switch requestType {
                    case .Before:
                        let last = self.nearestFeed.count
                        self.nearestFeed = self.nearestFeed + response
                        let newLast = self.nearestFeed.count
                        indexPaths = (last..<newLast).map({
                            NSIndexPath(forItem: $0, inSection: 0)
                        })
                    case .After:
                        let first = 0
                        self.nearestFeed = response + self.nearestFeed
                        let newFirst = response.count
                        indexPaths = (first..<newFirst).map({
                            NSIndexPath(forItem: $0, inSection: 0)
                        })
                    }

                    dispatch_async(dispatch_get_main_queue()) {
                        self.populatingPhotos = false
                        self.tableView?.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
                        if response.count < 10 && requestType == .Before {
                            self.shouldRequestMore = false
                            self.tableView?.deleteRowsAtIndexPaths([NSIndexPath(forItem: self.nearestFeed.count, inSection: 0)], withRowAnimation: .None)
                        }
                    }
                }
                callback?()
            },
            failure: {
                error in
                SVProgressHUD.dismiss()
                self.populatingPhotos = false
                print("Could not fetch snaps = \(error)")
        })
    }

    func getLatestSnaps() {
        getSnapsForLocation(location!, notIds: self.notIds, requestType: .After, showLoading: false, callback: nil)
    }
}

extension NearestFeedViewController {

    func feedForIndexPath(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: SnapFeedCell
        if tableView.dequeueReusableCellWithIdentifier(snapFeedCellIdentifier) == nil {
            cell = SnapFeedCell()
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(snapFeedCellIdentifier) as! SnapFeedCell
        }
        cell.snapImageView.image = nil
        cell.descriptionLabel.text = nearestFeed[indexPath.row].postDescription
        let totalVotes = nearestFeed[indexPath.row].upvotes - nearestFeed[indexPath.row].downvotes
        cell.voteCountLabel.text = "\(totalVotes)"
        let distanceString = STUtils.sharedInstance.distanceInKmOrMilesDependingOnLocale(
            nearestFeed[indexPath.row].distanceInKilometers,
            mile: nearestFeed[indexPath.row].distanceInMiles
        )
        cell.directionButton.setTitle(distanceString, forState: .Normal)
        cell.imageLoadingIndicator.startAnimating()
        STNetwork.sharedInstance.getImage(nearestFeed[indexPath.row].image_url,
                                          success: {
                                            image in
                                            cell.imageLoadingIndicator.stopAnimating()
                                            cell.snapImageView.image = image
            },
                                          failure: {
                                            error in
                                            print("Could not get image \(error)")
        })
        return cell
    }

    func loadingCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.center = cell.center
        cell.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        cell.tag = kLoadingCellTag
        return cell
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row < self.nearestFeed.count {
            return self.feedForIndexPath(tableView, cellForRowAtIndexPath: indexPath)
        } else {
            return self.loadingCell()
        }
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.tag == kLoadingCellTag {
            if let loc = location {
                getSnapsForLocation(loc, notIds: self.notIds, requestType: .Before, showLoading: false, callback: nil)
            }
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.shouldRequestMore {
            return nearestFeed.count + 1
        }
        return nearestFeed.count
    }
}
