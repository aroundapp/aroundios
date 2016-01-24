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

class ViewController: UIViewController {

    @IBOutlet weak var connectToFacebookLable: UILabel!
    @IBOutlet weak var loginUserImageView: UIImageView!
    @IBOutlet weak var faceBookLoginButton: FBSDKLoginButton!
    @IBOutlet weak var loginPlaceholderImageView: UIImageView!
    @IBOutlet weak var loginDot1: LoginDot!
    @IBOutlet weak var loginDot2: LoginDot!
    @IBOutlet weak var loginDot3: LoginDot!
    @IBOutlet weak var loginDot4: LoginDot!
    @IBOutlet weak var loginDot5: LoginDot!

    override func viewDidLoad() {
        super.viewDidLoad()
        faceBookLoginButton.loginBehavior = .Web
        faceBookLoginButton.readPermissions = ["public_profile", "email"]
        faceBookLoginButton.delegate = self
        hideLoginUI()
        guard let _ = STAppData.sharedInstance.appToken else {
            showLoginUI()
            return
        }

        verifyAppTokenAndMoveToFeed()
    }

    func hideLoginUI() {
        connectToFacebookLable.hidden = true
        loginUserImageView.hidden = true
        faceBookLoginButton.hidden = true
        loginPlaceholderImageView.hidden = true
        loginDot1.hidden = true
        loginDot2.hidden = true
        loginDot3.hidden = true
        loginDot4.hidden = true
        loginDot5.hidden = true
    }

    func showLoginUI() {
        connectToFacebookLable.hidden = false
        loginUserImageView.hidden = false
        faceBookLoginButton.hidden = false
        loginPlaceholderImageView.hidden = false
        loginDot1.hidden = false
        loginDot2.hidden = false
        loginDot3.hidden = false
        loginDot4.hidden = false
        loginDot5.hidden = false
    }

    func verifyAppTokenAndMoveToFeed() {
        STNetwork.sharedInstance.verifyAppToken({
            (user) -> () in
            print("Token Verification Successful \nUser: \(user)")
            // Move to feed
            },
            failure: {
                (error) -> () in
                if error.code == STStatusCodes.UNAUTHORIZED {
                    self.showLoginUI()
                } else {
                    print(error)
                }
        })
    }

    func signUpUserWithFBTokenAndMoveToFeed(fbToken: String) {
        STNetwork.sharedInstance.signUpUserWithFBToken(fbToken,
            success: {
                (user) -> () in
                print("Sign Up Successful \nUser: \(user)")
                // Move to the feed
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
extension ViewController: FBSDKLoginButtonDelegate {

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error != nil {
            print("Process error")
        } else if result.isCancelled {
            print("Cancelled by user")
        } else {
            let token = result.token.tokenString
            self.faceBookLoginButton.hidden = true
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

