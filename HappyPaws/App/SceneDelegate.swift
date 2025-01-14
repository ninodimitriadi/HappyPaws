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
        window?.rootViewController = UINavigationController(rootViewController: launchViewController)
        window?.makeKeyAndVisible()

        handleNavigationAfterLaunch()
    }

    func handleNavigationAfterLaunch() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self = self else { return }

            if Auth.auth().currentUser != nil {
                let tabBarController = TabBarViewController()
                self.window?.rootViewController = tabBarController
            } else {
                let loginViewController = LogInViewController()
                self.window?.rootViewController = UINavigationController(rootViewController: loginViewController)
            }

            self.window?.makeKeyAndVisible()
        }
    }
}

