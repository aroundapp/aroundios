//
//  FeedViewController.swift
//  SnapyTag
//
//  Created by Rishi Mukherjee on 07/02/16.
//  Copyright © 2016 snapyTag. All rights reserved.
//

import UIKit
import SnapKit

class FeedViewController: UIPageViewController {

    var navBarHairlineImageView: UIImageView?

    @IBOutlet weak var addNewSnapButton: UIBarButtonItem!
    @IBOutlet weak var feedControl: UISegmentedControl!

    private(set) lazy var feedControllerViewControllers: [UIViewController] = {
        return [self.getFeedViewControllerOfType("Nearest"),
            self.getFeedViewControllerOfType("Popular")]
    }()

    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : AnyObject]?) {
        super.init(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: options)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navBarHairlineImageView?.hidden = true

        for (index, subview) in feedControl.subviews.enumerate() {
            subview.tintColor = UIColor.snapyTagNavgationBarTitleColor()
            feedControl.selectedSegmentIndex = index
        }
        feedControl.selectedSegmentIndex = 0
        addNewSnapButton.tintColor = UIColor.snapyTagNavgationBarTitleColor()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navBarHairlineImageView?.hidden = false
    }

    func setViewControllerForIndex(index: Int) {
        setViewControllers(
            [index == 0 ? feedControllerViewControllers[0] : feedControllerViewControllers[1]],
            direction: index == 0 ? .Reverse : .Forward,
            animated: true,
            completion: nil
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = true
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Feed"
        definesPresentationContext = true
        for recognizer in self.gestureRecognizers {
            recognizer.enabled = false
        }
        navBarHairlineImageView = self.findHairlineImageViewUnder(self.navigationController!.navigationBar)

        STNetwork.sharedInstance.verifyAppToken({
            response in
                print("Verification  Successful \nResponse: \(response)")
                self.setupNearbyFeedIfUserVerified()
            },
            failure: {
                error in
                if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                    appDelegate.startLoginStory()
                }
        })
    }

    func setupNearbyFeedIfUserVerified() {
        dataSource = self
        delegate = self
        setViewControllerForIndex(0)
        feedControl.selectedSegmentIndex = 0
    }

    func findHairlineImageViewUnder(navBar: UIView) -> UIImageView? {
        if navBar.isKindOfClass(UIImageView) && navBar.bounds.size.height <= 1.0 {
            return navBar as? UIImageView
        }
        for subview in navBar.subviews {
            let imageView = self.findHairlineImageViewUnder(subview)
            if let view = imageView {
                return view
            }
        }
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    private func getFeedViewControllerOfType(type: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewControllerWithIdentifier("\(type)FeedViewController")
    }


    @IBAction func addNewSnapButtonPressed(sender: UIBarButtonItem) {

    }

    @IBAction func feedControlValueChanged(sender: UISegmentedControl) {
        setViewControllerForIndex(sender.selectedSegmentIndex)
    }

}


extension FeedViewController: UIPageViewControllerDataSource {

    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            if viewController == feedControllerViewControllers[1] {
                return feedControllerViewControllers[0]
            }
            return nil
    }

    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            if viewController == feedControllerViewControllers[0] {
                return feedControllerViewControllers[1]
            }
        return nil
    }
}

extension FeedViewController: UIPageViewControllerDelegate {

    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let currentIndex = pageViewController.viewControllers![0].view.tag
            self.feedControl.selectedSegmentIndex = currentIndex
        }
    }

}


