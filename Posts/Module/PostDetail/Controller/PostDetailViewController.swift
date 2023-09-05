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
    private let activityIndicator = UIActivityIndicatorView()

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
                activityIndicator.startAnimating()
                
                let postDetail = try await postManager.fetchPostDetailWith(id: postID!)
                setupPostDetailView(postDetail: postDetail)
                
                activityIndicator.stopAnimating()
            } catch {
                activityIndicator.stopAnimating()
                show(error: error as NSError)
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
        
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func show(error: NSError) {
        let errorLabel = UILabel()
        view.addSubview(errorLabel)

        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.font = .boldSystemFont(ofSize: 20)
        errorLabel.text = "\(error.localizedDescription) \n\n Error Code: \(error.code)"
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32)
        ])
    }
    
}
