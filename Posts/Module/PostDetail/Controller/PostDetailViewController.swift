//
//  PostDetailViewController.swift
//  Posts
//
//  Created by Dmytro Ukrainskyi on 31.08.2023.
//

import UIKit

final class PostDetailViewController: UIViewController {
    
    // MARK: Public Properties
    
    var postID: Int?

    // MARK: Private Properties

    private let postManager: PostManagerProtocol = PostManager()
    private let postDetailView = PostDetailView()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadPostDetail()
    }
    
    // MARK: Private Methods
    private func loadPostDetail() {
        guard postID != nil else { return }
        Task {
            do {
                // TODO: Display activity indicator
                let postDetail = try await postManager.fetchPostDetailWith(id: postID!)
                setupPostDetailView(postDetail: postDetail)
            } catch {
                // TODO: Handle error
                print(error)
            }
        }
    }
    
    private func setupPostDetailView(postDetail: PostDetail) {
        postDetailView.titleLabel.text = postDetail.title
        postDetailView.textLabel.text = postDetail.text
        postDetailView.likesCountLabel.text = "❤️ \(postDetail.likesCount)"
        postDetailView.datePostedLabel.text = postDetail.datePosted.formatted()
                
        if let imageURL = URL(string: postDetail.imageURL) {
            postDetailView.imageView.setImageFrom(url: imageURL)
        } else {
            postDetailView.imageView.setPlaceholderImage()
        }
        
        layoutPostDetailView()
        postDetailView.setupUI()
    }
    
    private func layoutPostDetailView() {
        postDetailView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            postDetailView
                .topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            postDetailView
                .leadingAnchor
                .constraint(equalTo: view.leadingAnchor),
            postDetailView
                .trailingAnchor
                .constraint(equalTo: view.trailingAnchor),
            postDetailView
                .bottomAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(postDetailView)
        
        title = UIConstants.navigationTitle
    }
    
}
