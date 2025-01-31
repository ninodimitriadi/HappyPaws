//
//  TabBarViewController.swift
//  HappyPaws
//
//  Created by nino on 1/14/25.
//

import UIKit
import SwiftUI

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        navigationItem.hidesBackButton = true
    }

    private func setupTabBar() {
        let swiftUIHomeVC = UIHostingController(
            rootView: HomeSwiftUIView()
                .environmentObject(LanguageManager.shared)
        )
        let homeNavController = UINavigationController(rootViewController: swiftUIHomeVC)
        homeNavController.isNavigationBarHidden = false
        homeNavController.tabBarItem = configureTabBarItem(
            title: "Home",
            image: UIImage(systemName: "pawprint.fill"),
            tag: 1
        )

        let vetClinicVC = VetClinicViewController()
        let vetNavController = UINavigationController(rootViewController: vetClinicVC)
        vetNavController.tabBarItem = configureTabBarItem(
            title: "Health",
            image: resizeImage(image: UIImage(systemName: "stethoscope"), to: CGSize(width: 25, height: 25)),
            tag: 2
        )

        let groomingSalonVC = GroomingSalonViewController()
        let groomingNavController = UINavigationController(rootViewController: groomingSalonVC)
        groomingNavController.tabBarItem = configureTabBarItem(
            title: "Grooming",
            image: resizeImage(image: UIImage(named: "grooming"), to: CGSize(width: 25, height: 25)),
            tag: 3
        )

        let userProfileVC = UserProfileViewController()
        let profileNavController = UINavigationController(rootViewController: userProfileVC)
        profileNavController.isNavigationBarHidden = true
        profileNavController.tabBarItem = configureTabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            tag: 4
        )

        self.viewControllers = [homeNavController, vetNavController, groomingNavController, profileNavController]
        self.selectedIndex = 0

        customizeTabBarAppearance()
    }
    
    private func configureTabBarItem(title: String, image: UIImage?, tag: Int) -> UITabBarItem {
        let tabBarItem = UITabBarItem(title: title, image: image, tag: tag)
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        return tabBarItem
    }
    
    private func resizeImage(image: UIImage?, to size: CGSize) -> UIImage? {
        guard let image = image else { return nil }
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    private func customizeTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .white
        
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = .gray
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = .mainYellow
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 12)
        ]
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.mainYellow,
            .font: UIFont.boldSystemFont(ofSize: 12)
        ]
        
        self.tabBar.standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            self.tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        
        DispatchQueue.main.async {
            self.tabBar.layer.cornerRadius = 20
            self.tabBar.layer.masksToBounds = true
            self.tabBar.layer.borderWidth = 1
            self.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        self.tabBar.isTranslucent = true
        self.tabBar.clipsToBounds = false
    }
}

