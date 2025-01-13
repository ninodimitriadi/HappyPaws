//
//  ButtonExtension.swift
//  HappyPaws
//
//  Created by nino on 1/14/25.
//

import Foundation
import UIKit

extension UIButton {
    func configureButton(title: String? = nil, fontSize: Int? = nil, titleColor: UIColor? = nil, image: UIImage? = nil, tintColor: UIColor? = .white, backgroundColor: UIColor? = nil, font: String? = nil) {
        
        self.titleLabel?.font = UIFont(name: font ?? "Raleway-Bold", size: CGFloat(fontSize ?? 20))
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.tintColor = .white
        self.setImage(image, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.textAlignment = .center
    }
}
