//
//  HomeViewController.swift
//  HappyPaws
//
//  Created by nino on 1/14/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.configureButton(title: "Log in", fontSize: 17, backgroundColor: .customBlue)
        button.layer.cornerRadius = 5
        
        button.addAction(UIAction(handler: { [weak self] _ in
            AuthService.shared.signOut { error in
                self?.navigationController?.pushViewController(LogInViewController(), animated: false)
            }
        }), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 300),
            loginButton.widthAnchor.constraint(equalToConstant: 300),
        ])
    }
}
