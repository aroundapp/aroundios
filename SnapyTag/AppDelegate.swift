//
//  AppDelegate.swift
//  SnapyTag
//
//  Created by Rishi Mukherjee on 21/01/16.
//  Copyright © 2016 snapyTag. All rights reserved.
//

import UIKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let appStartTimeStamp = NSDate()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // connect facebook delegate

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        // App Activated facebook log
        FBSDKAppEvents.activateApp()

        customAppearance()

        if !STAppData.isLogined {
            startLoginStory()
        }

        UIApplication.sharedApplication().statusBarStyle = .LightContent

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func startLoginStory() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let rootViewController = storyboard.instantiateViewControllerWithIdentifier("LoginNavigationController") as! UINavigationController
        window?.rootViewController = rootViewController
    }

    func startMainStory() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = storyboard.instantiateViewControllerWithIdentifier("MainNavigationController") as! UINavigationController
        window?.rootViewController = rootViewController
    }

    private func customAppearance() {

        // Global Tint Color

        window?.tintColor = UIColor.snapyTagTintColor()
        window?.tintAdjustmentMode = .Normal

        // NavigationBar Item Style

        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.snapyTagTintColor()], forState: .Normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.snapyTagTintColor().colorWithAlphaComponent(0.3)], forState: .Disabled)

        // NavigationBar Title Style


        let textAttributes = [
            NSForegroundColorAttributeName: UIColor.snapyTagNavgationBarTitleColor(),
            NSFontAttributeName: UIFont.navigationBarTitleFont()
        ]

        UINavigationBar.appearance().titleTextAttributes = textAttributes
        UINavigationBar.appearance().barTintColor = UIColor.snapyTagTintColor()
    }
    
}

