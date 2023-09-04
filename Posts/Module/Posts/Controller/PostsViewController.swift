//
//  PostsViewController.swift
//  Posts
//
//  Created by Dmytro Ukrainskyi on 31.08.2023.
//

import UIKit

final class PostsViewController: UIViewController {
    
    // MARK: Private Properties
    
    private let postManager: PostManagerProtocol = PostManager()
    
    private var posts: [Post] = []
    
    private let tableView = UITableView()
    
    private let expandedCellsIndices: [Int] = []
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadPosts()
    }
    
    // MARK: Private Methods
    
    private func loadPosts() {
        Task {
            do {
                // TODO: Display activity indicator
                posts = try await postManager.fetchPosts()
                tableView.reloadData()
            } catch {
                // TODO: Handle Error
                print(error)
            }
        }
    }
    
    fileprivate func sortPostsBy(_ sortOrder: SortOrder) {
        switch sortOrder {
        case .datePosted:
            posts.sort { $0.timestamp > $1.timestamp }
        case .likes:
            posts.sort { $0.likesCount > $1.likesCount }
        }
        
        tableView.reloadData()
    }
    
}

// MARK: - UI

extension PostsViewController {
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    private func setupNavigationBar() {
        title = UIConstants.navigationTitle
        
        let sortButton = UIBarButtonItem(
            image: UIImage(systemName: SystemImages.sort),
            style: .plain,
            target: nil,
            action: nil
        )
        
        let sortByDateAction = UIAction(title: "Date Posted") { _ in
            self.sortPostsBy(.datePosted)
        }
        let sortByLikesAction = UIAction(title: "Likes") { _ in
            self.sortPostsBy(.likes)
        }
        
        sortButton.menu = UIMenu(
            title: "Sort By",
            children: [sortByDateAction, sortByLikesAction]
        )
        
        navigationItem.rightBarButtonItem = sortButton
    }
    
}

// MARK: - UITableViewDataSource

extension PostsViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return posts.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let postCell = tableView.dequeueReusableCell(
            withIdentifier: PostCell.identifier,
            for: indexPath
        ) as? PostCell else {
            return UITableViewCell()
        }
        
        let post = posts[indexPath.row]
        
        postCell.titleLabel.text = post.title
        postCell.previewTextLabel.text = post.previewText
        postCell.likesCountLabel.text = "❤️ \(post.likesCount)"
        postCell.datePostedLabel.text = post.datePosted.timeAgo()
        
        if postCell.previewTextLabel.isTruncated {
            postCell.addExpandCollapseButton()
        }
        
        return postCell
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

// MARK: - UITableViewDelegate

extension PostsViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)

        let postDetailViewController = PostDetailViewController()
        postDetailViewController.postID = posts[indexPath.row].id

        navigationController?
            .pushViewController(postDetailViewController, animated: true)
    }
    
}
