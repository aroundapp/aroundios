//
//  ViewController.swift
//  SnapyTag
//
//  Created by Rishi Mukherjee on 21/01/16.
//  Copyright © 2016 snapyTag. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Alamofire
import FBSDKLoginKit
import SVProgressHUD

class SplashViewController: UIViewController {

    @IBOutlet weak var connectToFacebookLabel: UILabel!
    @IBOutlet weak var loginUserImageView: UIImageView!
    @IBOutlet weak var faceBookLoginButton: FBSDKLoginButton!
    @IBOutlet weak var loginPlaceholderImageView: UIImageView!
    @IBOutlet weak var loginDot1: LoginDot!
    @IBOutlet weak var loginDot2: LoginDot!
    @IBOutlet weak var loginDot3: LoginDot!
    @IBOutlet weak var loginDot4: LoginDot!
    @IBOutlet weak var loginDot5: LoginDot!
    @IBOutlet weak var loginViewsContainer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setDefaultMaskType(.Gradient)
        faceBookLoginButton.loginBehavior = .Web
        faceBookLoginButton.readPermissions = ["public_profile", "email"]
        faceBookLoginButton.delegate = self
        UIApplication.sharedApplication().statusBarStyle = .Default

        if FBSDKAccessToken.currentAccessToken() != nil {
            if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                appDelegate.startMainStory()
            }
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)
    }


    func signUpUserWithFBTokenAndMoveToFeed(fbToken: String) {
        SVProgressHUD.showWithStatus("Loading...")
        STNetwork.sharedInstance.signUpUserWithFBToken(fbToken,
            success: {
                (response) -> () in
                SVProgressHUD.dismiss()
                print("Sign Up Successful \nResponse: \(response)")
                if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                    appDelegate.startMainStory()
                }
            },
            failure: {
                (error) -> () in
                print(error)
            }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// Pragma: FBSDKLoginButtonDelegate
extension SplashViewController: FBSDKLoginButtonDelegate {

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error != nil {

            let alertController = UIAlertController(title: NSLocalizedString("Something went wrong", comment: ""), message: NSLocalizedString("A server with the specified hostname could not be found", comment: ""), preferredStyle: .Alert)

            let okAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .Default) { action in
            }

            alertController.addAction(okAction)
            presentViewController(alertController, animated: true, completion: nil)

        } else if result.isCancelled {

            let alertController = UIAlertController(title: NSLocalizedString("Facebook Login Cancelled", comment: ""), message: NSLocalizedString("You need to login to use SnapyTag", comment: ""), preferredStyle: .Alert)

            let okAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .Default) { action in
            }

            alertController.addAction(okAction)
            presentViewController(alertController, animated: true, completion: nil)

        } else {
            let token = result.token.tokenString
            self.signUpUserWithFBTokenAndMoveToFeed(token)
        }
    }

    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        // Nothing to do here
    }
}

