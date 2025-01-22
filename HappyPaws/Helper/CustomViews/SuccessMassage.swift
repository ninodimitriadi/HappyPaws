//
//  SuccessMassage.swift
//  HappyPaws
//
//  Created by nino on 1/21/25.
//

import Foundation
import UIKit


func showSaveSuccessView(massage: String, parentView: UIView) {
    let successView = UIView()
    successView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
    successView.layer.cornerRadius = 12
    successView.layer.masksToBounds = true
    successView.translatesAutoresizingMaskIntoConstraints = false

    let messageLabel = UILabel()
    messageLabel.text = massage
    messageLabel.textColor = .gray
    messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    messageLabel.textAlignment = .center
    messageLabel.translatesAutoresizingMaskIntoConstraints = false

    successView.addSubview(messageLabel)
    parentView.addSubview(successView)

    NSLayoutConstraint.activate([
        successView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
        successView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor),
        successView.widthAnchor.constraint(equalToConstant: 250),
        successView.heightAnchor.constraint(equalToConstant: 60)
    ])

    NSLayoutConstraint.activate([
        messageLabel.centerXAnchor.constraint(equalTo: successView.centerXAnchor),
        messageLabel.centerYAnchor.constraint(equalTo: successView.centerYAnchor)
    ])

    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        successView.removeFromSuperview()
    }
}
