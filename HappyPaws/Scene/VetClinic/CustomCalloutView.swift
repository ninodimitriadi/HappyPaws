//
//  CustomCalloutView.swift
//  HappyPaws
//
//  Created by nino on 1/17/25.
//


import UIKit

class CustomCalloutView: UIView {

    private let nameLabel = UILabel()
    private let distanceLabel = UILabel()
    private let phoneLabel = UILabel()
    private let ratingLabel = UILabel()
    private var clinicPhoneNumber: String?

    var onTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true

        backgroundColor = .white
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4

        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)

        distanceLabel.font = UIFont.systemFont(ofSize: 14)
        distanceLabel.textColor = .darkGray
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(distanceLabel)

        phoneLabel.font = UIFont.systemFont(ofSize: 14)
        phoneLabel.textColor = .blue
        phoneLabel.isUserInteractionEnabled = true
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(phoneLabel)

        let phoneTapGesture = UITapGestureRecognizer(target: self, action: #selector(phoneLabelTapped))
        phoneLabel.addGestureRecognizer(phoneTapGesture)

        ratingLabel.font = UIFont.systemFont(ofSize: 14)
        ratingLabel.textColor = .darkGray
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ratingLabel)

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            distanceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            distanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            distanceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            phoneLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 5),
            phoneLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            phoneLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            ratingLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 5),
            ratingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            ratingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }

    @objc private func handleTap() {
        onTap?()
    }

    @objc private func phoneLabelTapped() {
        guard let phoneNumber = clinicPhoneNumber else { return }
        let cleanedPhoneNumber = phoneNumber.filter { $0.isNumber }
        if let url = URL(string: "tel://\(cleanedPhoneNumber)") {
            UIApplication.shared.open(url)
        }
    }

    func configure(vetClinic: ClinicModel, distance: String, clinicNumber: String) {
        nameLabel.text = vetClinic.title
        distanceLabel.text = distance
        phoneLabel.text = "📞 \(clinicNumber)"
        clinicPhoneNumber = clinicNumber
        ratingLabel.text = "⭐️ \(vetClinic.rating)"
    }
}

