//
//  PostCell.swift
//  Posts
//
//  Created by Dmytro Ukrainskyi on 31.08.2023.
//

import UIKit

final class PostCell: UITableViewCell {
    
    static let identifier = "PostCell"
    
    // MARK: Public Properties

    var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        
        return label
    }()
    
    var previewTextLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 2
        
        return label
    }()
    
    var likesCountLabel = UILabel()
    
    var datePostedLabel = UILabel()
    
    var expandCollapseButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 8
        button.setTitle("Expand", for: .normal)
        
        return button
    }()
            
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods

    func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(previewTextLabel)
        contentView.addSubview(likesCountLabel)
        contentView.addSubview(datePostedLabel)
        
        layoutTitleLabel()
        layoutPreviewTextLabel()
        layoutLikesCountLabel()
        layoutDatePostedLabel()
    }
    
    func addExpandCollapseButton() {
        // TODO: Add expand/collapse button to cell
    }
    
    func expand() {
        previewTextLabel.numberOfLines = 0
        expandCollapseButton.setTitle("Collapse", for: .normal)
    }
    
    func collapse() {
        previewTextLabel.numberOfLines = 2
        
        expandCollapseButton.setTitle("Expand", for: .normal)
    }

    // MARK: - Private Methods
    
    private func layoutTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel
            .setContentCompressionResistancePriority(UILayoutPriority(999), for: .vertical)
        titleLabel
            .setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
                
        NSLayoutConstraint.activate([
            titleLabel
                .topAnchor
                .constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel
                .leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel
                .trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
    }
    
    private func layoutPreviewTextLabel() {
        previewTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        previewTextLabel
            .setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        previewTextLabel
            .setContentHuggingPriority(UILayoutPriority(0), for: .vertical)

        NSLayoutConstraint.activate([
            previewTextLabel
                .topAnchor
                .constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            previewTextLabel
                .leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor, constant: 24),
            previewTextLabel
                .trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
    }
    
    private func layoutLikesCountLabel() {
        likesCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            likesCountLabel
                .topAnchor
                .constraint(equalTo: previewTextLabel.bottomAnchor, constant: 16),
            likesCountLabel
                .leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor, constant: 24)
        ])
        
        // Lowering final bottom constraint priority fixes conflicting constraints warning xcode bug
        let bottomConstraint = likesCountLabel
            .bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor, constant: -16)
        
        bottomConstraint.priority = UILayoutPriority(999)
        
        bottomConstraint.isActive = true
    }
    
    private func layoutDatePostedLabel() {
        datePostedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePostedLabel
                .bottomAnchor
                .constraint(equalTo: likesCountLabel.bottomAnchor),
            datePostedLabel
                .trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
    }
    
}
