//
//  PostDetailView.swift
//  Posts
//
//  Created by Dmytro Ukrainskyi on 31.08.2023.
//

import UIKit

final class PostDetailView: UIView {
    
    // MARK: Private Properties
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let textLabel = UILabel()
    private let likesCountLabel = UILabel()
    private let datePostedLabel = UILabel()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imagePlaceholderView = UIView()
    private let footerView = UIView()
    
    // MARK: Public Methods
    
    func configure(
        imageURL: String,
        title: String,
        text: String,
        likesCount: String,
        datePosted: String
    ) {
        if let imageURL = URL(string: imageURL) {
            imageView.setImageFrom(url: imageURL)
        } else {
            imageView.setPlaceholderImage()
        }
        
        titleLabel.text = title
        textLabel.text = text
        likesCountLabel.text = likesCount
        datePostedLabel.text = datePosted
        
        setupUI()
    }
    
    // MARK: Private Methods
    
    private func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imagePlaceholderView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(textLabel)
        imagePlaceholderView.addSubview(imageView)
        
        addSubview(footerView)
        footerView.addSubview(likesCountLabel)
        footerView.addSubview(datePostedLabel)
        
        layoutScrollView()
        layoutContentView()
        layoutImagePlaceholderView()
        layoutFooterView()
        
        layoutImageView()
        layoutTitleLabel()
        layoutTextLabel()
        layoutLikesCountLabel()
        layoutDatePostedLabel()
        
        imagePlaceholderView.backgroundColor = .secondarySystemBackground
        
        footerView.backgroundColor = .systemBackground
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        titleLabel.font = .boldSystemFont(ofSize: Constants.titleLabelFontSize)
        titleLabel.numberOfLines = Constants.titleLabelNumberOfLines
        
        textLabel.numberOfLines = Constants.textLabelNumberOfLines
    }
    
    private func layoutScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView
                .topAnchor
                .constraint(equalTo: self.topAnchor),
            scrollView
                .leadingAnchor
                .constraint(equalTo: self.leadingAnchor),
            scrollView
                .trailingAnchor
                .constraint(equalTo: self.trailingAnchor),
            scrollView
                .bottomAnchor
                .constraint(equalTo: footerView.topAnchor)
        ])
    }
    
    func layoutContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView
                .topAnchor
                .constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView
                .leadingAnchor
                .constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView
                .trailingAnchor
                .constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView
                .bottomAnchor
                .constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView
                .widthAnchor
                .constraint(equalTo: self.widthAnchor)
        ])
    }
    
    private func layoutFooterView() {
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            footerView
                .leadingAnchor
                .constraint(equalTo: self.leadingAnchor),
            footerView
                .trailingAnchor
                .constraint(equalTo: self.trailingAnchor),
            footerView
                .bottomAnchor
                .constraint(equalTo: self.bottomAnchor),
            footerView
                .heightAnchor
                .constraint(equalToConstant: Constants.footerHeight)
        ])
    }
    
    private func layoutImagePlaceholderView() {
        imagePlaceholderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imagePlaceholderView
                .topAnchor
                .constraint(equalTo: contentView.topAnchor),
            imagePlaceholderView
                .leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor),
            imagePlaceholderView
                .trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor),
            imagePlaceholderView
                .heightAnchor
                .constraint(equalToConstant: Constants.imageHeight)
        ])
    }
    
    private func layoutImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView
                .topAnchor
                .constraint(equalTo: imagePlaceholderView.topAnchor),
            imageView
                .leadingAnchor
                .constraint(equalTo: imagePlaceholderView.leadingAnchor),
            imageView
                .trailingAnchor
                .constraint(equalTo: imagePlaceholderView.trailingAnchor),
            imageView
                .bottomAnchor
                .constraint(equalTo: imagePlaceholderView.bottomAnchor)
        ])
    }
    
    private func layoutTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel
                .topAnchor
                .constraint(equalTo: imagePlaceholderView.bottomAnchor,
                            constant: Constants.verticalSpacing * 3),
            titleLabel
                .leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor,
                            constant: Constants.horizontalSpacing * 2),
            titleLabel
                .trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor,
                            constant: Constants.horizontalSpacing * -2)
        ])
    }
    
    private func layoutTextLabel() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textLabel
                .topAnchor
                .constraint(equalTo: titleLabel.bottomAnchor,
                            constant: Constants.verticalSpacing * 3),
            textLabel
                .leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor,
                            constant: Constants.horizontalSpacing * 2),
            textLabel
                .trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor,
                            constant: Constants.horizontalSpacing * -2),
            textLabel
                .bottomAnchor
                .constraint(equalTo: contentView.bottomAnchor,
                            constant: Constants.verticalSpacing * -3)
        ])
    }
    
    private func layoutLikesCountLabel() {
        likesCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            likesCountLabel
                .leadingAnchor
                .constraint(equalTo: footerView.leadingAnchor,
                            constant: Constants.horizontalSpacing * 2),
            likesCountLabel
                .bottomAnchor
                .constraint(equalTo: footerView.bottomAnchor,
                            constant: Constants.verticalSpacing * -1)
        ])
    }
    
    private func layoutDatePostedLabel() {
        datePostedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePostedLabel
                .trailingAnchor
                .constraint(equalTo: footerView.trailingAnchor,
                            constant: Constants.horizontalSpacing * -2),
            datePostedLabel
                .bottomAnchor
                .constraint(equalTo: footerView.bottomAnchor,
                            constant: Constants.verticalSpacing * -1)
        ])
    }
    
}

// MARK: - Constants

private extension PostDetailView {
    
    enum Constants {
        
        static let titleLabelFontSize: CGFloat = 20
        static let titleLabelNumberOfLines: Int = 0
        
        static let textLabelNumberOfLines: Int = 0
        
        static let imageHeight: CGFloat = 256
        
        static let footerHeight: CGFloat = 42
        
        static let verticalSpacing: CGFloat = 8
        static let horizontalSpacing: CGFloat = 8
        
    }
    
}
