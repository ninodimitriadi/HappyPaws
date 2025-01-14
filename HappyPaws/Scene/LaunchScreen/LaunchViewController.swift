//
//  LaunchViewController.swift
//  HappyPaws
//
//  Created by nino on 1/13/25.
//

import UIKit
import SwiftUI

class LaunchViewController: UIViewController {

    private lazy var logoImageView: UIImageView = {
        let imageView = createImageView(imageName: "HappyPowsLogo", contentMode: .scaleAspectFit)
        if let logoImage = UIImage(named: "HappyPowsLogo") {
            let coloredImage = logoImage.withRenderingMode(.alwaysTemplate)
            imageView.image = coloredImage
            imageView.tintColor = .orange
        }
        return imageView
    }()

    private lazy var gifImageView: UIImageView = {
        return createImageView(imageName: nil, contentMode: .scaleAspectFit)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureLayout()
        loadGIF()
        startTransitionToMainApp()
    }

    private func setupUI() {
        setupImageViews()
        view.backgroundColor = .white
    }
    
    private func setupImageViews() {
        view.addSubview(logoImageView)
        view.addSubview(gifImageView)
    }

    private func createImageView(imageName: String?, contentMode: UIView.ContentMode) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = contentMode
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        if let imageName = imageName {
            imageView.image = UIImage(named: imageName)
        }
        
        return imageView
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 350),
            logoImageView.heightAnchor.constraint(equalToConstant: 200)
        ])

        NSLayoutConstraint.activate([
            gifImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gifImageView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: -100),
            gifImageView.widthAnchor.constraint(equalToConstant: 300),
            gifImageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

    private func loadGIF() {
        if let walkGif = UIImage.gifImageWithName("playing") {
            gifImageView.image = walkGif
        }
    }

    private func startTransitionToMainApp() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.transitionToMainApp()
        }
    }

    private func transitionToMainApp() {
        let mainViewController = LogInViewController()
        mainViewController.modalTransitionStyle = .crossDissolve
        mainViewController.modalPresentationStyle = .fullScreen
        present(mainViewController, animated: true, completion: nil)
    }

}

@available(iOS 16.0, *)
struct LaunchViewController_Preview: PreviewProvider {
    static var previews: some View {
        LaunchViewControllerRepresentable()
    }
}

@available(iOS 16.0, *)
struct LaunchViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> LaunchViewController {
        return LaunchViewController()
    }

    func updateUIViewController(_ uiViewController: LaunchViewController, context: Context) {}
}
