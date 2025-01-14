//
//  TabBarViewController.swift
//  HappyPaws
//
//  Created by nino on 1/14/25.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        navigationItem.hidesBackButton = true
    }

    private func setupTabBar() {
        let tabBarController = UITabBarController()
        
        let HomeVC = HomeViewController()
//        let LeaderboardVC = LeaderboardHostingVC()
//        let ShopVC = ShopHostingViewController()
//        let ProfileVC = ProfileHostingController()
        
        tabBarController.viewControllers = [HomeVC]
        
        HomeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "homeImage"), tag: 1)
//        LeaderboardVC.tabBarItem = UITabBarItem(title: "Leaderboard", image: UIImage(systemName: "trophy"), tag: 2)
//        ShopVC.tabBarItem = UITabBarItem(title: "Shop", image: UIImage(named: "shopTabBarIcon"), tag: 4)
//        ProfileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 3)
    
        if let tabBar = tabBarController.tabBar as? UITabBar{
            tabBar.barTintColor = .white
            tabBar.isTranslucent = true
            tabBar.backgroundColor = .clear
            tabBar.tintColor = .black
            tabBar.layer.cornerRadius = 40
            tabBar.layer.masksToBounds = true
        }
        
        addChild(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.didMove(toParent: self)
    }
}
