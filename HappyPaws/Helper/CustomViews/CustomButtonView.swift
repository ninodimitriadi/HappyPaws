//
//  CustomButtonView.swift
//  HappyPaws
//
//  Created by nino on 1/20/25.
//

import UIKit

func createButton(iconName: String) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 18)
    button.setImage(UIImage(systemName: iconName), for: .normal)
    button.tintColor = .black
    button.backgroundColor = .clear
    button.layer.cornerRadius = 0
    button.contentHorizontalAlignment = .left
    button.heightAnchor.constraint(equalToConstant: 30).isActive = true
    
    if #available(iOS 15.0, *) {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: iconName)
        config.imagePadding = 15
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0)
        button.configuration = config
    } else {
        button.setImage(UIImage(systemName: iconName), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
    }
    
    return button
}

