//
//  CustomButtonView.swift
//  HappyPaws
//
//  Created by nino on 1/20/25.
//

import UIKit

func createButton(title: String, iconName: String) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 18)
    button.setImage(UIImage(systemName: iconName), for: .normal)
    button.tintColor = .black
    button.backgroundColor = .clear
    button.layer.cornerRadius = 0
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
    button.contentHorizontalAlignment = .left
    button.heightAnchor.constraint(equalToConstant: 30).isActive = true
    
    return button
}

