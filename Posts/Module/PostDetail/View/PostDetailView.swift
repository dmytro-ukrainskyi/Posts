//
//  PostDetailView.swift
//  Posts
//
//  Created by Dmytro Ukrainskyi on 31.08.2023.
//

import UIKit

final class PostDetailView: UIView {
    
    // MARK: Public Properties
    let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        
        return label
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        
        return label
    }()
    
    let likesCountLabel = UILabel()
    
    let datePostedLabel = UILabel()
    
    // MARK: Private Properties
    
    private let scrollView = UIScrollView()
    
    private let contentView = UIView()
    
    private let imagePlaceholderView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .secondarySystemBackground
        
        return view
    }()
    
    private let footerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .systemBackground
        
        return view
    }()
    
    // MARK: Public Methods
    
    func setupUI() {
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
    }
    
    // MARK: Private Methods
    
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
                .constraint(equalToConstant: 42)
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
                .constraint(equalToConstant: 256)
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
                .constraint(equalTo: imagePlaceholderView.bottomAnchor, constant: 24),
            titleLabel
                .leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel
                .trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func layoutTextLabel() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textLabel
                .topAnchor
                .constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            textLabel
                .leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textLabel
                .trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textLabel
                .bottomAnchor
                .constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    private func layoutLikesCountLabel() {
        likesCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            likesCountLabel
                .leadingAnchor
                .constraint(equalTo: footerView.leadingAnchor, constant: 16),
            likesCountLabel
                .bottomAnchor
                .constraint(equalTo: footerView.bottomAnchor, constant: -8)
        ])
    }
    
    private func layoutDatePostedLabel() {
        datePostedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePostedLabel
                .trailingAnchor
                .constraint(equalTo: footerView.trailingAnchor, constant: -16),
            datePostedLabel
                .bottomAnchor
                .constraint(equalTo: footerView.bottomAnchor, constant: -8)
        ])
    }
    
}
