//
//  SceneDelegate.swift
//  HappyPaws
//
//  Created by nino on 1/13/25.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let launchViewController = LaunchViewController()
        print("Setting LaunchViewController as root")
        window?.rootViewController = UINavigationController(rootViewController: launchViewController)
        window?.makeKeyAndVisible()

        handleNavigationAfterLaunch()
    }


    func handleNavigationAfterLaunch() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self = self else { return }
            print("Handling navigation after launch...")

            if Auth.auth().currentUser != nil {
                print("User is authenticated, navigating to TabBarViewController")
                let tabBarController = TabBarViewController()
                self.window?.rootViewController = tabBarController
            } else {
                print("User is not authenticated, navigating to LogInViewController")
                let loginViewController = LogInViewController()
                self.window?.rootViewController = UINavigationController(rootViewController: loginViewController)
            }

            self.window?.makeKeyAndVisible()
        }
    }

}

