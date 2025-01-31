//
//  Navigation.swift
//  HappyPaws
//
//  Created by nino on 1/25/25.
//

import UIKit

extension UINavigationController {
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}

extension UITabBarController {
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        tabBar.standardAppearance = appearance
    }
}
