//
//  CustomButtonView.swift
//  HappyPaws
//
//  Created by nino on 1/20/25.
//

import UIKit

func createButton(title: String, iconName: String, backgroundColor: UIColor) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    button.setImage(UIImage(systemName: iconName), for: .normal)
    button.tintColor = .white
    button.backgroundColor = backgroundColor
    button.layer.cornerRadius = 12
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    button.contentHorizontalAlignment = .left
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    return button
}
