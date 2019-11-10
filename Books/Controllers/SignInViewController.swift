//
//  SignInViewController.swift
//  Books
//
//  Created by Dzmitry on 11/6/19.
//  Copyright © 2019 Dzmitry Krukov. All rights reserved.
//

import UIKit
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInDelegate {
    
    var isLoggedIn: Bool  {
        return GIDSignIn.sharedInstance()?.currentUser?.authentication != nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        GIDSignIn.sharedInstance().delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selector()
    }
    
    // MARK: - setup SignIn Button
    fileprivate func setupSignInButton() {
        let signInButton = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        
        signInButton.center = view.center
        signInButton.style = .standard
        
        view.addSubview(signInButton)
    }

    // MARK: - Selector
    private func selector() {
        if isLoggedIn {
            navigateToMainScreen()
        } else {
            setupSignInButton()
        }
    }

    private func navigateToMainScreen() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let mainNavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "MainNavigationController") as? MainNavigationController else { return }
        
        present(mainNavigationVC, animated: true, completion: nil)
    }
    
    // MARK: - GIDSignInDelegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
        } else {
            guard let fullName = user.profile.name else {
                return
            }
            self.navigateToMainScreen()
            
            print("The user has been registered. Full name is \(fullName).")
        }
    }
    
}
