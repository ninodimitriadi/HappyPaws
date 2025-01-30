//
//  ReminderCell.swift
//  HappyPaws
//
//  Created by nino on 1/30/25.
//

import UIKit

class ReminderCell: UICollectionViewCell {
    static let reuseIdentifier = "ReminderCell"
    var onDeleteReminder: (() -> Void)?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.gray.withAlphaComponent(0.2).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 22)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 11.45
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Regular", size: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let notesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Regular", size: 18)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .black
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        deleteButton.addTarget(self, action: #selector(deleteReminderTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(notesLabel)
        containerView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            
            notesLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 6),
            notesLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            notesLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            notesLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            
            deleteButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            deleteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            deleteButton.widthAnchor.constraint(equalToConstant: 20),
            deleteButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(title: String, date: String, notes: String?) {
        titleLabel.text = title
        dateLabel.text = date
        if let notes = notes, !notes.isEmpty {
            notesLabel.text = notes
            notesLabel.isHidden = false
            notesLabel.preferredMaxLayoutWidth = contentView.frame.width - 30
        } else {
            notesLabel.isHidden = true
        }
    }
    
    @objc private func deleteReminderTapped() {
        onDeleteReminder?()
    }
}
